import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../utils/data.dart';
import '../utils/showSnackBar.dart';

class FirebaseAuthMethods {
  final FirebaseAuth _auth;
  FirebaseAuthMethods(this._auth);

  //Google Sign in
  Future<String> signInWithGoogle(BuildContext context) async {
    String output = '';
    try{
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      final User? user = _auth.currentUser;
      if(googleAuth?.accessToken != null && googleAuth?.idToken != null) {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        var asd = await user?.getIdToken();
        //log(asd.toString());
        output = asd.toString();
        UserCredential userCredential = await _auth.signInWithCredential(credential);
        if (userCredential.user != null) {
          if (userCredential.additionalUserInfo!.isNewUser) {}
        }
      }
      else {
        var asd = await user?.getIdToken();
        //log(asd.toString());
        output = asd.toString();
      }

    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
      output = 'error';
    }
    return output;
  }

  //Facebook sign in
  Future<String> signInWithFacebook(BuildContext context) async {
    String output = '';
    try{
      final LoginResult loginResult = await FacebookAuth.instance.login();
      final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);

      await _auth.signInWithCredential(facebookAuthCredential);

      final User? user = _auth.currentUser;

      var asd = await user?.getIdToken();
      //log(asd.toString());
      output = asd.toString();
    } on FirebaseAuthException catch(e) {
      showSnackBar(context, e.message!);
      output = 'error';
    }
    return output;
  }

}