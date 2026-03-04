/* import_parts.js
 *
 * PCPartPicker dataset -> Firestore
 *
 * Each JSON file becomes its own top-level Firestore collection.
 * All raw fields are stored directly on the document (no 'spec' nesting).
 * Computed fields added automatically:
 *   - brand   (all types, via guessBrand)
 *   - socket  (cpu only, via detectCpuSocket)
 *
 * Input:  ../../parts/*.json  (relative to this file)
 * Setup:  tools/etl/serviceAccountKey.json  (DO NOT COMMIT)
 *
 * Run:
 *   cd tools/etl
 *   node import_parts.js
 *
 * Optional env:
 *   LIMIT_PER_FILE=100    import only first N records per file (for testing)
 *   DRY_RUN=1             no Firestore writes, only logs sample output
 */

const admin = require("firebase-admin");
const fs    = require("fs");
const path  = require("path");

// ── CONFIG ────────────────────────────────────────────────────────────────────
const SERVICE_ACCOUNT_PATH = path.join(__dirname, "serviceAccountKey.json");
const INPUT_DIR            = path.join(__dirname, "../../parts");

const LIMIT_PER_FILE = process.env.LIMIT_PER_FILE
  ? parseInt(process.env.LIMIT_PER_FILE, 10)
  : null;

// Accept --dry-run flag (works on all platforms incl. PowerShell)
// or the DRY_RUN=1 env variable (Unix/Mac)
const DRY_RUN =
  process.env.DRY_RUN === "1" ||
  process.argv.includes("--dry-run") ||
  process.argv.includes("--dryrun");

// Firestore max batch size is 500; stay below with a buffer
const BATCH_LIMIT = 400;

// ── FIREBASE INIT ─────────────────────────────────────────────────────────────
let db = null;

function initFirebase() {
  if (!fs.existsSync(SERVICE_ACCOUNT_PATH)) {
    console.error("Missing serviceAccountKey.json at: " + SERVICE_ACCOUNT_PATH);
    console.error(
      "Download: Firebase Console → Project settings → Service accounts → Generate new private key"
    );
    process.exit(1);
  }
  admin.initializeApp({
    credential: admin.credential.cert(require(SERVICE_ACCOUNT_PATH)),
  });
  db = admin.firestore();
}

// ── HELPERS ───────────────────────────────────────────────────────────────────

/**
 * Heuristically guess the manufacturer brand from the product name.
 * Returns null if no match found.
 */
function guessBrand(name) {
  if (!name) return null;
  const n = String(name).toLowerCase();

  // CPUs
  if (n.includes("intel")) return "Intel";
  if (n.includes("amd") || n.includes("ryzen") || n.includes("threadripper"))
    return "AMD";

  // GPUs
  if (n.includes("nvidia") || n.includes("geforce") || n.includes("rtx") || n.includes("gtx"))
    return "NVIDIA";
  if (n.includes("radeon") || n.includes("rx ")) return "AMD";

  // Motherboard / general vendors
  if (n.includes("asus"))                            return "ASUS";
  if (n.includes("msi"))                             return "MSI";
  if (n.includes("gigabyte"))                        return "Gigabyte";
  if (n.includes("asrock"))                          return "ASRock";
  if (n.includes("corsair"))                         return "Corsair";
  if (n.includes("g.skill") || n.includes("gskill")) return "G.Skill";
  if (n.includes("kingston"))                        return "Kingston";
  if (n.includes("crucial"))                         return "Crucial";
  if (n.includes("samsung"))                         return "Samsung";
  if (n.includes("seagate"))                         return "Seagate";
  if (n.includes("wd ") || n.includes("western digital")) return "Western Digital";
  if (n.includes("be quiet"))                        return "be quiet!";
  if (n.includes("cooler master"))                   return "Cooler Master";
  if (n.includes("nzxt"))                            return "NZXT";
  if (n.includes("fractal"))                         return "Fractal Design";
  if (n.includes("noctua"))                          return "Noctua";
  if (n.includes("arctic"))                          return "Arctic";
  if (n.includes("deepcool"))                        return "DeepCool";
  if (n.includes("thermaltake"))                     return "Thermaltake";
  if (n.includes("evga"))                            return "EVGA";
  if (n.includes("seasonic"))                        return "Seasonic";
  if (n.includes("lian li"))                         return "Lian Li";

  return null;
}

/**
 * Heuristically detect the CPU socket from the product name.
 * The raw cpu.json dataset has no socket field, so we infer it.
 * Returns null if the socket cannot be determined.
 */
function detectCpuSocket(name) {
  if (!name) return null;
  const n = String(name).toLowerCase().trim();

  // AMD Ryzen
  if (n.includes("ryzen")) {
    const match = n.match(/ryzen\s+\d\s+(\d{4})/);
    if (match) {
      const model = parseInt(match[1], 10);
      if (model >= 7000) return "AM5";
      if (model >= 1000) return "AM4";
    }
    if (n.includes("threadripper")) {
      if (n.match(/79\d{2}/) || n.includes("7000")) return "sTR5";
      return "sTRX4";
    }
  }

  // Older AMD families
  if (n.includes("fx-"))    return "AM3+";
  if (n.includes("phenom")) return "AM3";
  if (n.includes("athlon")) return "AM4";

  // Intel Core i-series (model number heuristic)
  const intelMatch = n.match(/i[3579]-?(\d{4,5})/);
  if (intelMatch) {
    const model = parseInt(intelMatch[1], 10);
    if (model >= 12000) return "LGA1700";
    if (model >= 10000) return "LGA1200";
    if (model >= 8000)  return "LGA1151";
    if (model >= 6000)  return "LGA1151";
    if (model >= 4000)  return "LGA1150";
    if (model >= 2000)  return "LGA1155";
  }

  if (n.includes("xeon"))   return "LGA2011";
  if (n.includes("core 2")) return "LGA775";

  return null;
}

/** URL/filesystem-safe slug from a string. */
function slugify(str, maxLen = 200) {
  if (!str) return "";
  return String(str)
    .normalize("NFKD")
    .replace(/[\u0300-\u036f]/g, "")
    .toLowerCase()
    .trim()
    .replace(/&/g, " and ")
    .replace(/[^a-z0-9]+/g, "_")
    .replace(/^_+|_+$/g, "")
    .slice(0, maxLen);
}

/** Stable Firestore document ID derived from name + brand. */
function makeDocId(name, brand) {
  const nameSlug  = slugify(name  || "noname");
  const brandSlug = slugify(brand || "");
  const base = brandSlug ? `${nameSlug}__${brandSlug}` : nameSlug;
  return base.slice(0, 300);
}

/** Parse a JSON file that is either an array or { data: [...] }. */
function loadJsonArray(filePath) {
  const txt  = fs.readFileSync(filePath, "utf8");
  const data = JSON.parse(txt);
  if (Array.isArray(data))                return data;
  if (data && Array.isArray(data.data))   return data.data;
  throw new Error("Unrecognized JSON format in " + filePath);
}

// ── NORMALISATION ─────────────────────────────────────────────────────────────

/**
 * Convert one raw dataset record into a Firestore document.
 *
 * Strategy: copy ALL raw fields as-is, then add computed fields on top.
 * No 'spec' nesting — every attribute is a top-level field so it's easy
 * to query and display.
 */
function normalizeRaw(datasetType, raw) {
  if (!raw.name) return null; // skip records without a name

  const doc = {};

  // 1. Copy every raw field (skip undefined / empty string)
  for (const [k, v] of Object.entries(raw)) {
    if (v !== undefined && v !== "") doc[k] = v;
  }

  // 2. Add guessed brand (skip if already present in raw data)
  if (!doc.brand) {
    const guessed = guessBrand(raw.name);
    if (guessed) doc.brand = guessed;
  }

  // 3. Detect CPU socket (raw cpu.json has no socket field)
  if (datasetType === "cpu" && !doc.socket) {
    const s = detectCpuSocket(raw.name);
    if (s) doc.socket = s;
  }

  return doc;
}

// ── FIRESTORE UPLOAD ──────────────────────────────────────────────────────────

/**
 * Upload an array of normalized documents to the given Firestore collection.
 * Writes are batched to stay within Firestore limits.
 */
async function uploadCollection(collectionName, docs) {
  if (!db) throw new Error("Firestore not initialized.");

  const col = db.collection(collectionName);
  let batch      = db.batch();
  let batchCount = 0;
  let uploaded   = 0;

  for (const doc of docs) {
    const docId  = makeDocId(doc.name, doc.brand);
    const docRef = col.doc(docId);
    batch.set(docRef, doc, { merge: false });
    batchCount++;
    uploaded++;

    if (batchCount >= BATCH_LIMIT) {
      await batch.commit();
      console.log(`    batch committed (${uploaded} so far)`);
      batch      = db.batch();
      batchCount = 0;
    }
  }

  if (batchCount > 0) {
    await batch.commit();
    console.log(`    final batch committed`);
  }

  return uploaded;
}

// ── MAIN ──────────────────────────────────────────────────────────────────────

async function main() {
  if (!DRY_RUN) initFirebase();

  if (!fs.existsSync(INPUT_DIR)) {
    console.error("Parts directory not found: " + INPUT_DIR);
    process.exit(1);
  }

  const files = fs.readdirSync(INPUT_DIR).filter((f) => f.endsWith(".json"));
  if (files.length === 0) {
    console.error("No .json files found in " + INPUT_DIR);
    process.exit(1);
  }

  console.log(`Dry run   : ${DRY_RUN ? "YES (no writes)" : "NO"}`);
  console.log(`Limit     : ${LIMIT_PER_FILE ?? "none (all records)"}`);
  console.log(`Input dir : ${INPUT_DIR}`);
  console.log(`Files     : ${files.length}\n`);

  let grandTotal = 0;

  for (const f of files.sort()) {
    const datasetType = path.basename(f, ".json"); // e.g. "cpu", "video-card"
    const filePath    = path.join(INPUT_DIR, f);

    const rawArr    = loadJsonArray(filePath);
    const limited   = LIMIT_PER_FILE ? rawArr.slice(0, LIMIT_PER_FILE) : rawArr;
    const normalized = limited
      .map((r) => normalizeRaw(datasetType, r))
      .filter(Boolean);

    console.log(
      `${String(datasetType).padEnd(24)} ` +
      `${String(rawArr.length).padStart(6)} raw → ` +
      `${String(normalized.length).padStart(6)} docs → ` +
      `collection "${datasetType}"`
    );

    if (DRY_RUN) {
      if (normalized.length > 0) {
        console.log("  Sample:", JSON.stringify(normalized[0], null, 2));
      }
      continue;
    }

    const count = await uploadCollection(datasetType, normalized);
    grandTotal += count;
    console.log(`  ✓ ${count} documents written\n`);
  }

  if (DRY_RUN) {
    console.log("\nDone ✅  (dry run — nothing written to Firestore)");
  } else {
    console.log(`\nDone ✅  Total documents uploaded: ${grandTotal}`);
  }
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
