import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServiceException implements Exception {
  const AuthServiceException({required this.code, required this.message});

  final String code;
  final String message;

  @override
  String toString() => message;
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // -----------------------
  // Email/Passwort
  // -----------------------
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
      throw AuthServiceException(code: e.code, message: _mapAuthError(e));
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
      throw AuthServiceException(code: e.code, message: _mapAuthError(e));
    }
  }

  Future<void> sendPasswordResetEmail({
    required String email,
    ActionCodeSettings? actionCodeSettings,
  }) async {
    try {
      await _auth.sendPasswordResetEmail(
        email: email.trim(),
        actionCodeSettings: actionCodeSettings,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthServiceException(code: e.code, message: _mapAuthError(e));
    }
  }

  Future<void> confirmPasswordReset({
    required String oobCode,
    required String newPassword,
  }) async {
    try {
      await _auth.confirmPasswordReset(code: oobCode, newPassword: newPassword);
    } on FirebaseAuthException catch (e) {
      throw AuthServiceException(code: e.code, message: _mapAuthError(e));
    }
  }

  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = _auth.currentUser;
    if (user == null || user.email == null) {
      throw AuthServiceException(
        code: 'no-user',
        message: 'Kein eingeloggter Nutzer.',
      );
    }
    try {
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw AuthServiceException(code: e.code, message: _mapAuthError(e));
    }
  }

  Future<UserCredential> signInAnonymously() async {
    try {
      return await _auth.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      throw AuthServiceException(code: e.code, message: _mapAuthError(e));
    }
  }

  // -----------------------
  // Google Sign-In
  // -----------------------
  Future<UserCredential> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        // ✅ WEB: Firebase Popup Flow
        final provider = GoogleAuthProvider();
        return await _auth.signInWithPopup(provider);
      }

      // ✅ MOBILE: google_sign_in Flow
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Google Sign-In abgebrochen.');
      }

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw AuthServiceException(code: e.code, message: _mapAuthError(e));
    } catch (e) {
      throw Exception('Google Login fehlgeschlagen: $e');
    }
  }

  // -----------------------
  // Sign Out
  // -----------------------
  Future<void> signOut() async {
    await _auth.signOut();

    // Mobile: zusätzlich Google Session trennen
    if (!kIsWeb) {
      await _googleSignIn.signOut();
    }
  }

  // -----------------------
  // Error Mapping
  // -----------------------
  String _mapAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Bitte gib eine gültige E-Mail-Adresse ein.';
      case 'user-disabled':
        return 'Dieser Account wurde deaktiviert.';
      case 'user-not-found':
        return 'Kein Account mit dieser E-Mail gefunden.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'E-Mail oder Passwort ist falsch.';
      case 'email-already-in-use':
        return 'Diese E-Mail wird bereits verwendet.';
      case 'weak-password':
        return 'Passwort zu schwach (mindestens 8 Zeichen, ein Sonderzeichen, ein Großbuchstabe und eine Zahl).';
      case 'network-request-failed':
        return 'Keine Internetverbindung.';
      case 'too-many-requests':
        return 'Zu viele Versuche. Bitte später erneut probieren.';

      // Web-spezifisch
      case 'popup-closed-by-user':
        return 'Popup geschlossen.';
      case 'unauthorized-domain':
        return 'Domain nicht autorisiert (Firebase → Auth → Settings → Authorized domains).';
      case 'operation-not-allowed':
        return 'Google Login ist in Firebase Auth nicht aktiviert.';
      default:
        return 'Auth-Fehler: ${e.message ?? e.code}';
    }
  }
}
