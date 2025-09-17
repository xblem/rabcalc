// lib/services/auth_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rabcalc/utils/logger.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign in with Email & Password
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      logger.i("Mencoba login dengan Email...");
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      logger.i("Login dengan Email berhasil untuk user: ${result.user?.uid}");
      return result.user;
    } on FirebaseAuthException catch (e, s) {
      logger.e("Error saat login dengan Email", error: e, stackTrace: s);
      return null;
    }
  }

  // Register with Email & Password
  Future<User?> createUserWithEmail(String email, String password) async {
    try {
      logger.i("Mencoba membuat user baru dengan Email...");
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );
      User? user = result.user;

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': email,
          'displayName': '',
          'photoURL': '',
          'createdAt': Timestamp.now(),
        });
        logger.i("User baru berhasil dibuat & data disimpan ke Firestore. UID: ${user.uid}");
      }
      return user;
    } on FirebaseAuthException catch (e, s) {
      logger.e("Error saat membuat user baru", error: e, stackTrace: s);
      return null;
    }
  }

  // Sign in with Google
  Future<User?> signInWithGoogle() async {
    try {
      logger.i("Mencoba login dengan Google...");
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        logger.w("Login Google dibatalkan oleh user.");
        return null;
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential result = await _auth.signInWithCredential(credential);
      User? user = result.user;

      // Jika ini adalah user baru, buatkan dokumen untuknya di Firestore
      if (user != null && result.additionalUserInfo?.isNewUser == true) {
        logger.i("User Google baru terdeteksi. Membuat dokumen Firestore...");
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': user.email,
          'displayName': user.displayName, 
          'photoURL': user.photoURL,       
          'createdAt': Timestamp.now(),
        });
      }
      // --- AKHIR PENAMBAHAN ---

      logger.i("Login dengan Google berhasil untuk user: ${user?.uid}");
      return user;
    } catch (e, s) {
      logger.e("Error saat login dengan Google", error: e, stackTrace: s);
      return null;
    }
  }

  // Sign in with Facebook
  Future<User?> signInWithFacebook() async {
    try {
      logger.i("Mencoba login dengan Facebook...");
      final LoginResult loginResult = await FacebookAuth.instance.login();
      if (loginResult.status == LoginStatus.success) {
        final AccessToken accessToken = loginResult.accessToken!;
        final OAuthCredential credential = FacebookAuthProvider.credential(accessToken.token);
        UserCredential result = await _auth.signInWithCredential(credential);
        logger.i("Login dengan Facebook berhasil untuk user: ${result.user?.uid}");
        return result.user;
      }
      logger.w("Login Facebook dibatalkan atau gagal. Status: ${loginResult.status}");
      return null;
    } catch (e, s) {
      logger.e("Error saat login dengan Facebook", error: e, stackTrace: s);
      return null;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    logger.i("User melakukan sign out...");
    await GoogleSignIn().signOut();
    await FacebookAuth.instance.logOut();
    await _auth.signOut();
  }

  // Auth State Changes Stream
  Stream<User?> get user => _auth.authStateChanges();
}