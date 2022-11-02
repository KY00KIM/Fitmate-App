import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitmate/domain/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer';

class FirebaseAuthMethods {
  final FirebaseAuth _auth;
  FirebaseAuthMethods(this._auth);
  final GoogleSignIn _googleSignIn = new GoogleSignIn();

  void showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  Future<void> signOut() async {
    await Firebase.initializeApp();

    await FirebaseAuth.instance.signOut();
    await _googleSignIn.signOut();

    await _auth.signOut();
    //await _googleSignIn.signOut();
  }

  Future<String> signInWithApple() async {
    await Firebase.initializeApp();
    String output = '';
    try {
      final User? user = _auth.currentUser;
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      var userIdToken = await user?.getIdToken();
      //log(userIdToken.toString());
      output = userIdToken.toString();
      print("output : ${output}");

      final authResult =
          await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      print("auth : ${authResult}");
    } catch (error) {
      print("error 떠붔다 : ${error}");
      output = 'error';
    }
    return output;
  }

  //Google Sign in
  Future<String> signInWithGoogle(BuildContext context) async {
    await Firebase.initializeApp();
    String output = '';
    try {
      //final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      print("gogole user : $googleUser");
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      print("googleAuth : $googleAuth");
      final User? user = _auth.currentUser;
      print("user : $user");
      print("auth : ${_auth.currentUser}");
      if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        var userIdToken = await user?.getIdToken();
        log(userIdToken.toString());
        output = userIdToken.toString();
        //UserCredential userCredential = await _auth.signInWithCredential(credential);
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        if (userCredential.user != null) {
          if (userCredential.additionalUserInfo!.isNewUser) {}
        }
      } else {
        var userIdToken = await user?.getIdToken();
        //log(userIdToken.toString());
        output = userIdToken.toString();
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
      output = 'error';
    }
    return output;
  }

  Future<String> createCustomToken(Map<String, dynamic> user) async {
    final customTokenResponse =
        await http.post(Uri.parse('${baseUrlV1}users/oauth/kakao'), body: user);
    var resBody = jsonDecode(utf8.decode(customTokenResponse.bodyBytes));
    String custom_token = resBody["data"]["custom_token"];
    return custom_token;
  }

  Future<String> signInWithCustomToken(
      BuildContext context, String token) async {
    try {
      print("zz");
      await FirebaseAuth.instance.signInWithCustomToken(token);
      print("FirebaseAuth instance : ${FirebaseAuth.instance.toString()}");
      print("CustomToken : ${token}");
      String AdditionalToken =
          (await FirebaseAuth.instance.currentUser?.getIdTokenResult(true))!
              .token
              .toString();
      log("Additional Token : ${AdditionalToken}");
      return AdditionalToken;
    } catch (error) {
      print("Error in signInWithCustomToken : $error");
      return "error";
    }
  }

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  void createUserInFirestore() {
    users
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .limit(1)
        .get()
        .then(
      (QuerySnapshot querySnapshot) {
        if (querySnapshot.docs.isEmpty) {
          users.add({
            'name': UserData['user_name'],
            'uid': FirebaseAuth.instance.currentUser?.uid
          });
        }
      },
    ).catchError((error) {});
  }
}
