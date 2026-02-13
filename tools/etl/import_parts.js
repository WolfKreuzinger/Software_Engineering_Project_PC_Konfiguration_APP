/* import_parts.js
 *
 * PCPartDataset (PCPartPicker Snapshot) -> Firestore "parts" Collection
 *
 * Expected input:
 *   tools/etl/input/*.json
 * where each file is an array of raw objects and the filename matches the dataset type, e.g.:
 *   cpu.json
 *   motherboard.json
 *   video-card.json
 *   internal-hard-drive.json
 *   power-supply.json
 *   memory.json
 *   case.json
 *   cpu-cooler.json
 *
 * Setup:
 *   tools/etl/serviceAccountKey.json   (DO NOT COMMIT)
 *
 * Run:
 *   cd tools/etl
 *   node import_parts.js
 *
 * Optional env:
 *   LIMIT_PER_FILE=500        (imports only first N records per file)
 *   DRY_RUN=1                 (no Firestore writes, only logs)
 *   CURRENCY=USD              (default USD; keep snapshot currency)
 */

const admin = require("firebase-admin");
const fs = require("fs");
const path = require("path");

// ---------------- CONFIG ----------------
const SERVICE_ACCOUNT_PATH = path.join(__dirname, "serviceAccountKey.json");
const INPUT_DIR = path.join(__dirname, "input");

const SOURCE = "pcpartpicker_snapshot";
const SNAPSHOT_DATE = new Date().toISOString().slice(0, 10); // YYYY-MM-DD
const CURRENCY = process.env.CURRENCY || "USD";

const LIMIT_PER_FILE = process.env.LIMIT_PER_FILE
  ? parseInt(process.env.LIMIT_PER_FILE, 10)
  : null;

const DRY_RUN = process.env.DRY_RUN === "1";

// Firestore batch limit is 500; keep buffer
const BATCH_LIMIT = 400;

// ---------------- FIREBASE INIT (only if not DRY_RUN) ----------------
let db = null;

function initFirebaseIfNeeded() {
  if (DRY_RUN) return;

  if (!fs.existsSync(SERVICE_ACCOUNT_PATH)) {
    console.error("Missing serviceAccountKey.json at: " + SERVICE_ACCOUNT_PATH);
    console.error(
      "Download it from Firebase Console -> Project settings -> Service accounts -> Generate new private key"
    );
    process.exit(1);
  }

  admin.initializeApp({
    credential: admin.credential.cert(require(SERVICE_ACCOUNT_PATH)),
  });

  db = admin.firestore();
}

// ---------------- HELPERS ----------------
function guessBrand(name) {
  if (!name) return null;
  const n = String(name).toLowerCase();

  // CPUs
  if (n.includes("intel")) return "Intel";
  if (n.includes("amd") || n.includes("ryzen") || n.includes("threadripper"))
    return "AMD";

  // GPUs
  if (
    n.includes("nvidia") ||
    n.includes("geforce") ||
    n.includes("rtx") ||
    n.includes("gtx")
  )
    return "NVIDIA";
  if (n.includes("radeon") || n.includes("rx ")) return "AMD"; // GPU brand

  // Common vendors
  if (n.includes("asus")) return "ASUS";
  if (n.includes("msi")) return "MSI";
  if (n.includes("gigabyte")) return "Gigabyte";
  if (n.includes("asrock")) return "ASRock";
  if (n.includes("corsair")) return "Corsair";
  if (n.includes("g.skill") || n.includes("gskill")) return "G.Skill";
  if (n.includes("kingston")) return "Kingston";
  if (n.includes("crucial")) return "Crucial";
  if (n.includes("samsung")) return "Samsung";
  if (n.includes("seagate")) return "Seagate";
  if (n.includes("wd ") || n.includes("western digital"))
    return "Western Digital";
  if (n.includes("be quiet")) return "be quiet!";
  if (n.includes("cooler master")) return "Cooler Master";
  if (n.includes("nzxt")) return "NZXT";
  if (n.includes("fractal")) return "Fractal Design";
  if (n.includes("noctua")) return "Noctua";

  return null;
}

function mapType(datasetType) {
  const map = {
    cpu: "cpu",
    "cpu-cooler": "cooler",
    motherboard: "motherboard",
    memory: "memory",
    "internal-hard-drive": "storage",
    "video-card": "gpu",
    case: "case",
    "power-supply": "psu",
    "case-fan": "caseFan",
    "case-accessory": "caseAccessory",
    "fan-controller": "fanController",
    "wired-network-card": "wiredNic",
    "wireless-network-card": "wirelessNic",
    "sound-card": "soundCard",
    "optical-drive": "opticalDrive",
    os: "os",
    "thermal-paste": "thermalPaste",
    ups: "ups",
    "external-hard-drive": "externalStorage",
  };
  return map[datasetType] || null;
}

function safe(value) {
  return value === undefined ? null : value;
}

function safeArrayValue(arr, idx) {
  if (!Array.isArray(arr)) return null;
  const v = arr[idx];
  return v === undefined ? null : v;
}

/**
 * CPU socket detection (heuristic) to make CPU<->Motherboard compatibility possible
 * even though cpu.json has no socket field.
 *
 * NOTE: We import ALL CPUs (even legacy). If we can't detect socket -> null.
 * That's OK; we mark it via metadata.socketKnown=false.
 */
function detectCpuSocket(name) {
  if (!name) return null;
  const n = String(name).toLowerCase().trim();

  // AMD Ryzen (model extraction: "Ryzen 7 9800X3D" => 9800)
  if (n.includes("ryzen")) {
    const match = n.match(/ryzen\s+\d\s+(\d{4})/);
    if (match) {
      const model = parseInt(match[1], 10);

      // Ryzen 7000/8000/9000 => AM5
      if (model >= 7000) return "AM5";

      // Ryzen 1000..5999 => AM4 (covers 1000/2000/3000/5000 series)
      if (model >= 1000) return "AM4";
    }

    // Threadripper (very simplified)
    if (n.includes("threadripper")) {
      if (n.match(/79\d{2}/) || n.includes("7000")) return "sTR5";
      return "sTRX4";
    }
  }

  // Older AMD families (very simplified)
  if (n.includes("fx-")) return "AM3+";
  if (n.includes("phenom")) return "AM3";
  if (n.includes("athlon")) return "AM4";

  // Intel Core i-series, extract 4-5 digits from i7-9700K / i5-12400F etc.
  const intelMatch = n.match(/i[3579]-?(\d{4,5})/);
  if (intelMatch) {
    const model = parseInt(intelMatch[1], 10);

    if (model >= 12000) return "LGA1700";
    if (model >= 10000) return "LGA1200";
    if (model >= 8000) return "LGA1151";
    if (model >= 6000) return "LGA1151";
    if (model >= 4000) return "LGA1150";
  }

  if (n.includes("xeon")) return "LGA2011";
  if (n.includes("core 2")) return "LGA775";

  return null;
}

function loadJsonArray(filePath) {
  const txt = fs.readFileSync(filePath, "utf8");
  const data = JSON.parse(txt);
  if (Array.isArray(data)) return data;
  if (data && Array.isArray(data.data)) return data.data;
  throw new Error("JSON format not recognized in " + filePath);
}

/**
 * FINAL normalized schema (what we store in Firestore).
 * We import ALL parts we can normalize; legacy is allowed.
 *
 * Important: We do NOT filter out old CPUs. We set metadata flags instead.
 */
// 2) normalizeRaw() erweitern: neue Typen
function normalizeRaw(datasetType, raw) {
  const type = mapType(datasetType);
  if (!type) return null;

  const name = raw.name ?? null;
  const price = raw.price ?? null;
  if (!name) return null;

  let spec = {};

  // ... eure bestehenden Blöcke (cpu, motherboard, gpu, memory, storage, psu, case, cooler) bleiben unverändert ...

  // ---- added: case fan ----
  if (type === "caseFan") {
    spec = {
      sizeMm: raw.size ?? null,
      rpm: raw.rpm ?? null,
      airflowCfm: raw.airflow ?? null,
      noiseLevelDb: raw.noise_level ?? null,
      pwm: raw.pwm ?? null,
      led: raw.led ?? null,
      color: raw.color ?? null,
    };
  }

  // ---- added: case accessory ----
  if (type === "caseAccessory") {
    spec = {
      accessoryType: raw.type ?? null,
      color: raw.color ?? null,
    };
  }

  // ---- added: fan controller ----
  if (type === "fanController") {
    spec = {
      channels: raw.channels ?? null,
      pwm: raw.pwm ?? null,
      formFactor: raw.form_factor ?? null,
      color: raw.color ?? null,
    };
  }

  // ---- added: wired NIC ----
  if (type === "wiredNic") {
    spec = {
      interface: raw.interface ?? null,     // e.g. PCIe x1
      speedMbps: raw.speed ?? null,         // dataset dependent
      ports: raw.ports ?? null,
    };
  }

  // ---- added: wireless NIC ----
  if (type === "wirelessNic") {
    spec = {
      interface: raw.interface ?? null,
      protocol: raw.protocol ?? null,       // e.g. 802.11ax
      speedMbps: raw.speed ?? null,
      bluetooth: raw.bluetooth ?? null,
    };
  }

  // ---- added: sound card ----
  if (type === "soundCard") {
    spec = {
      interface: raw.interface ?? null,
      channels: raw.channels ?? null,
      snrDb: raw.snr ?? null,
      sampleRateKHz: raw.sample_rate ?? null,
    };
  }

  // ---- added: optical drive ----
  if (type === "opticalDrive") {
    spec = {
      driveType: raw.type ?? null,          // BD/DVD etc.
      interface: raw.interface ?? null,     // SATA/USB
      bufferMB: raw.buffer ?? null,
      color: raw.color ?? null,
    };
  }

  // ---- added: OS ----
  if (type === "os") {
    spec = {
      family: raw.family ?? null,           // Windows/Linux etc. (dataset dependent)
      version: raw.version ?? null,
      architecture: raw.architecture ?? null, // 64-bit etc.
      license: raw.license ?? null,
    };
  }

  // ---- added: thermal paste ----
  if (type === "thermalPaste") {
    spec = {
      thermalConductivityWmk: raw.thermal_conductivity ?? null,
      amountG: raw.amount ?? null,
    };
  }

  // ---- added: UPS ----
  if (type === "ups") {
    spec = {
      capacityVA: raw.capacity_va ?? null,
      capacityW: raw.capacity_w ?? null,
      outlets: raw.outlets ?? null,
    };
  }

  // ---- added: external storage ----
  if (type === "externalStorage") {
    spec = {
      capacityGB: raw.capacity ?? null,
      driveType: raw.type ?? null,
      interface: raw.interface ?? null,      // USB etc.
      color: raw.color ?? null,
    };
  }

  // ---- metadata flags (wie bei euch) ----
  const socket =
    type === "cpu" || type === "motherboard" ? (spec.socket ?? null) : null;

  const socketKnown =
    type === "cpu" || type === "motherboard" ? socket !== null : true;

  const priceKnown = price !== null && price !== undefined;

  const recommendationEligible =
    priceKnown && (type === "cpu" || type === "motherboard" ? socketKnown : true);

  return {
    type: type,
    name: name,
    brand: raw.brand ?? guessBrand(name),
    price: priceKnown ? price : null,
    currency: CURRENCY,
    source: SOURCE,
    snapshotDate: SNAPSHOT_DATE,
    spec: spec,
    metadata: {
      socketKnown: socketKnown,
      priceKnown: priceKnown,
      recommendationEligible: recommendationEligible,
      datasetType: datasetType,
    },
  };
}

async function uploadParts(parts) {
  if (!db) throw new Error("Firestore not initialized. DRY_RUN should not call uploadParts().");

  const col = db.collection("parts");

  let batch = db.batch();
  let batchCount = 0;
  let uploaded = 0;

  for (const part of parts) {
    const docRef = col.doc(); // auto id
    batch.set(docRef, part, { merge: false });
    batchCount++;
    uploaded++;

    if (batchCount >= BATCH_LIMIT) {
      await batch.commit();
      console.log("Committed batch, uploaded so far: " + uploaded);
      batch = db.batch();
      batchCount = 0;
    }
  }

  if (batchCount > 0) {
    await batch.commit();
    console.log("Committed final batch, total uploaded: " + uploaded);
  }
}

async function main() {
  initFirebaseIfNeeded();

  if (!fs.existsSync(INPUT_DIR)) {
    console.error("Missing input dir: " + INPUT_DIR);
    process.exit(1);
  }

  const files = fs.readdirSync(INPUT_DIR).filter((f) => f.endsWith(".json"));
  if (files.length === 0) {
    console.error("No .json files found in " + INPUT_DIR);
    process.exit(1);
  }

  console.log("Snapshot date: " + SNAPSHOT_DATE);
  console.log("Currency stored: " + CURRENCY);
  console.log("Dry run: " + (DRY_RUN ? "YES" : "NO"));
  if (LIMIT_PER_FILE) console.log("Limit per file: " + LIMIT_PER_FILE);

  let all = [];
  const skippedTypes = new Set();

  for (const f of files) {
    const datasetType = path.basename(f, ".json"); // e.g. "video-card"
    const mapped = mapType(datasetType);

    // We only import the core PC configurator categories
    if (!mapped) {
      skippedTypes.add(datasetType);
      continue;
    }

    const filePath = path.join(INPUT_DIR, f);
    console.log(
      "Loading " +
        f +
        ' (datasetType="' +
        datasetType +
        '", type="' +
        mapped +
        '")...'
    );

    const rawArr = loadJsonArray(filePath);
    const rawLimited = LIMIT_PER_FILE ? rawArr.slice(0, LIMIT_PER_FILE) : rawArr;

    const normalized = rawLimited
      .map((r) => normalizeRaw(datasetType, r))
      .filter((p) => p !== null);

    let line = "  raw: " + rawArr.length;
    if (LIMIT_PER_FILE) line += " (using " + rawLimited.length + ")";
    line += " -> normalized: " + normalized.length;
    console.log(line);

    all = all.concat(normalized);
  }

  if (skippedTypes.size > 0) {
    console.log(
      "Skipped dataset types (not needed for MVP): " +
        Array.from(skippedTypes).join(", ")
    );
  }

  console.log("Total normalized parts to upload: " + all.length);

  if (DRY_RUN) {
    console.log("DRY_RUN sample:", all.slice(0, 3));
    console.log("Done ✅ (dry run)");
    return;
  }

  console.log('Uploading to Firestore collection "parts"...');
  await uploadParts(all);
  console.log("Done ✅");
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});