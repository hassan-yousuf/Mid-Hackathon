import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:midhackathon/app/auth_gate.dart';
import 'package:midhackathon/services/firebase_services.dart';

class AuthServices {
  AuthServices({FirebaseServices? firebaseServices})
    : _firebaseServices = firebaseServices ?? FirebaseServices();

  final FirebaseServices _firebaseServices;

  User? get currentUser => _firebaseServices.currentUser;

  Stream<User?> get authStateChanges => _firebaseServices.authStateChanges;

  Future<void> sendPasswordResetEmail(String email) {
    return _firebaseServices.sendPasswordResetEmail(email);
  }

  Future<UserCredential> signup(
    BuildContext context, {
    required String username,
    required String email,
    required String password,
  }) {
    return _firebaseServices
        .signup(username: username, email: email, password: password)
        .then((credential) async {
          await _firebaseServices.currentUser?.updateDisplayName(username);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const AuthGate()),
          );
          return credential;
        });
  }

  Future<UserCredential> login(
    BuildContext context, {
    required String email,
    required String password,
  }) {
    return _firebaseServices.login(email: email, password: password).then((
      credential,
    ) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AuthGate()),
      );
      return credential;
    });
  }

  Future<UserCredential?> signInWithGoogle(BuildContext context) {
    return _firebaseServices.signInWithGoogle().then((credential) {
      if (credential == null || !context.mounted) {
        return null;
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AuthGate()),
      );
      return credential;
    });
  }

  Future<void> logout(BuildContext context) {
    return _firebaseServices.logout().then((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AuthGate()),
      );
    });
  }
}
