import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../utils/showSnackBar.dart';

class FirebaseAuthMethods {
  final FirebaseAuth _auth;
  FirebaseAuthMethods(this._auth);

  //Google Sign in
  Future<String> signInWithGoogle(BuildContext context) async {
    String output = 'null';
    try{
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      final User? user = _auth.currentUser;
      print("당첨이냐");
      var asd = await user?.getIdToken();
      log(asd.toString());
      print('-----------------------------------------');
      if(googleAuth?.accessToken != null && googleAuth?.idToken != null) {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        //output = credential;
        UserCredential userCredential = await _auth.signInWithCredential(credential);
        if (userCredential.user != null) {
          if (userCredential.additionalUserInfo!.isNewUser) {}
        }
      }
      else {
        print(googleAuth?.accessToken);
      }

    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }

    return output;
  }

  //Facebook sign in
  Future<void> signInWithFacebook(BuildContext context) async {
    try{
      final LoginResult loginResult = await FacebookAuth.instance.login();
      final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);

      await _auth.signInWithCredential(facebookAuthCredential);

      final User? user = _auth.currentUser;
      print("당첨이냐");
      var asd = await user?.getIdToken();
      log(asd.toString());

    } on FirebaseAuthException catch(e) {
      showSnackBar(context, e.message!);
    }
  }

}