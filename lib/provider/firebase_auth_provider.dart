import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../consts/auth_constans.dart';
import '../screens/btm_bar.dart';
import '../widgets/alert_message.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  bool get isAuthenticate => _user != null;

  bool get isLoading => _isLoading;

  Future<UserCredential?> signUp(
      {required String email,
      required String password,
      required String name,
      required String shippingAddress,
      required List userCart,
      required List userWish,
      required int createdAt,
      required BuildContext context}) async {
    try {
      _isLoading = true;
      notifyListeners();
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = user!.uid;
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'id': uid,
        'name': name,
        'email': email,
        'shipping address': shippingAddress,
        'userWish': userWish,
        'userCart': userCart,
        'createdAt': createdAt,
      });
      _user = userCredential.user;
      notifyListeners();
      _isLoading = false;
      notifyListeners();
      return userCredential;
    } on FirebaseAuthException catch (e) {
      alertMessage(e.toString());
      _isLoading = false;
      notifyListeners();
      return null;
    } catch (e) {
      alertMessage(e.toString());
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<UserCredential?> signIn(
      String email, String password, BuildContext context) async {
    try {
      notifyListeners();
      _isLoading = true;
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _isLoading = false;
      notifyListeners();
      return userCredential;
    } on FirebaseAuthException catch (error) {
      _isLoading = false;
      notifyListeners();
      alertMessage(
        error.toString(),
      );
      _isLoading = false;
      notifyListeners();

      return null;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      alertMessage(e.toString());
      _isLoading = false;
      notifyListeners();

      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }

  Future<UserCredential?> signInWithGoogle(BuildContext context) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Get the sign in instance
      final GoogleSignIn googleSignIn = GoogleSignIn();

      // start the Google sign in process
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      // If the user succesfully signs in with Google
      if (googleUser != null) {
        // Get the Google authentication tokens
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        // Create a firebase creditials using the Google authentication tokens
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        // Navigate to the login screen
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => const LoginScreen()),
        // );

        // Sign in to Firebase using the Firebase credtials
        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        _isLoading = false;
        notifyListeners();
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: ((context) => const BottomBarScreen()),
          ),
        );
        return userCredential;
      } else {
        // If the user cancels the sign in process
        _isLoading = false;
        notifyListeners();
        return null;
      }
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      alertMessage(e.message.toString());
      return null;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      alertMessage(e.toString());
      return null;
    }
  }

  void checkAuthentication() {
    auth.authStateChanges().listen((user) {
      if (user == null) {
        _user = null;
      } else {
        _user = user;
      }
      notifyListeners();
    });
  }

  Future<void> resetUserPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      alertMessage(
          'To reset your password, link has been sent to you succesfully check your inbox ');
    } on FirebaseAuthException catch (e) {
      alertMessage(e.message.toString());
    } catch (e) {
      alertMessage(e.toString());
    }
    notifyListeners();
  }

  //
}
