import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseServices {
  FirebaseServices({FirebaseAuth? auth, GoogleSignIn? googleSignIn})
    : _auth = auth ?? FirebaseAuth.instance,
      _googleSignIn = googleSignIn ?? GoogleSignIn();

  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential> signup({
    required String email,
    required String password,
    required String username,
  }) async {
    final credential = await _runAuthOperation(
      () => _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      ),
    );
    await credential.user?.updateDisplayName(username.trim());
    await credential.user?.reload();
    return credential;
  }

  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    return _runAuthOperation(
      () => _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      ),
    );
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (error) {
      throw AuthServiceException(_messageFor(error), code: error.code);
    } on PlatformException catch (error) {
      throw AuthServiceException(
        _messageForGoogleError(error),
        code: error.code,
      );
    } on Exception catch (error) {
      throw AuthServiceException(
        'Unable to sign in with Google. Check that Google sign-in is enabled '
        'in Firebase and try again.',
        code: error.toString(),
      );
    }
  }

  Future<void> logout() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } on FirebaseAuthException catch (error) {
      throw AuthServiceException(_messageFor(error), code: error.code);
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (error) {
      throw AuthServiceException(_messageFor(error), code: error.code);
    }
  }

  Future<T> _runAuthOperation<T>(Future<T> Function() operation) async {
    try {
      return await operation();
    } on FirebaseAuthException catch (error) {
      throw AuthServiceException(_messageFor(error), code: error.code);
    }
  }

  String _messageFor(FirebaseAuthException error) {
    switch (error.code) {
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'The email or password is incorrect.';
      case 'email-already-in-use':
        return 'An account already exists for that email.';
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled in Firebase.';
      case 'account-exists-with-different-credential':
        return 'An account already exists with a different sign-in method.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'A network error occurred. Check your connection and try again.';
      default:
        return error.message ?? 'Authentication failed. Please try again.';
    }
  }

  String _messageForGoogleError(PlatformException error) {
    switch (error.code) {
      case 'sign_in_failed':
      case '10':
        return 'Google sign-in is not configured for this app. Add the '
            'Android SHA-1/SHA-256 fingerprints and enable Google in Firebase.';
      case 'network_error':
        return 'A network error occurred. Check your connection and try again.';
      case 'sign_in_canceled':
        return 'Google sign-in was canceled.';
      default:
        return error.message ??
            'Unable to sign in with Google. Check your Firebase configuration.';
    }
  }
}

class AuthServiceException implements Exception {
  const AuthServiceException(this.message, {this.code});

  final String message;
  final String? code;

  @override
  String toString() => message;
}
