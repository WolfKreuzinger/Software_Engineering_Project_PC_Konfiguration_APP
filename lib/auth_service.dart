import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapAuthError(e));
    }
  }

  Future<UserCredential> registerWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapAuthError(e));
    }
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapAuthError(e));
    }
  }

  Future<UserCredential> signInAnonymously() async {
    try {
      return await _auth.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapAuthError(e));
    }
  }

  Future<void> signOut() => _auth.signOut();

  String _mapAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Bitte gib eine gültige E-Mail-Adresse ein.';
      case 'user-disabled':
        return 'Dieser Account wurde deaktiviert.';
      case 'user-not-found':
        return 'Kein Account mit dieser E-Mail gefunden.';
      case 'wrong-password':
      case 'invalid-credential': // kommt bei neueren SDKs oft statt wrong-password
        return 'E-Mail oder Passwort ist falsch.';
      case 'email-already-in-use':
        return 'Diese E-Mail wird bereits verwendet.';
      case 'weak-password':
        return 'Passwort zu schwach (mindestens 6 Zeichen).';
      case 'network-request-failed':
        return 'Keine Internetverbindung.';
      case 'too-many-requests':
        return 'Zu viele Versuche. Bitte später erneut probieren.';
      default:
        return 'Auth-Fehler: ${e.message ?? e.code}';
    }
  }
}