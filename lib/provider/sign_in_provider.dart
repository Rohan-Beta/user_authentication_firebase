// ignore_for_file: prefer_final_fields, avoid_web_libraries_in_flutter, avoid_print, await_only_futures

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInProvider extends ChangeNotifier {
  // instance for FirebaseAuth , google , facebook

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FacebookAuth facebookAuth = FacebookAuth.instance;

  // sign in or not

  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;

  // has error , error code , provider , Uid , email , name , imageUrl

  bool _hasError = false;
  bool get hasError => _hasError;

  String? _errorCode;
  String? get errorCode => _errorCode;

  String? _provider;
  String? get provider => _provider;

  String? _uid;
  String? get uid => _uid;

  String? _name;
  String? get name => _name;

  String? _email;
  String? get email => _email;

  String? _imageUrl;
  String? get imageUrl => _imageUrl;

  SignInProvider() {
    checkSignInUser();
  }

  Future checkSignInUser() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _isSignedIn = s.getBool("signed_in") ?? false;
    notifyListeners();
  }

  // user successfully sign in

  Future setSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.setBool("signed_in", true);
    _isSignedIn = true;
    notifyListeners();
  }

  // sign in with google

  Future signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      // execute authentication
      try {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        // signin to firebase user instance
        final User userDetails =
            (await firebaseAuth.signInWithCredential(credential)).user!;

        // save all details

        _name = userDetails.displayName;
        _email = userDetails.email;
        _imageUrl = userDetails.photoURL;
        _provider = "GOOGLE";
        _uid = userDetails.uid;

        notifyListeners();
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case "account-exists-with-different-credential":
            _errorCode =
                "You already have an account with us. Please use correct provider";
            _hasError = true;

            notifyListeners();
            break;

          case "null":
            _errorCode =
                "Some unexpected error occured while trying to sign in";
            _hasError = true;
            notifyListeners();
            break;

          default:
            _errorCode = e.toString();
            _hasError = true;
            notifyListeners();
        }
      }
    } else {
      _hasError = true;
      notifyListeners();
    }
  }

  // entry for CloudFirestore
  // if the user already exists

  Future getUserDataFromFireStore(uid) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get()
        .then((DocumentSnapshot snapshot) => {
              _uid = snapshot["uid"],
              _name = snapshot["name"],
              _email = snapshot["email"],
              _imageUrl = snapshot["imageUrl"],
              _provider = snapshot["provoder"],
            });
  }

  // entry for CloudFirestore
  // if the user does not exists

  Future saveDataToFireStore() async {
    final DocumentReference reference =
        FirebaseFirestore.instance.collection("users").doc(uid);

    await reference.set({
      "uid": _uid,
      "name": _name,
      "email": _email,
      "imageUrl": _imageUrl,
      "privider": _provider,
    });
    notifyListeners();
  }

  // Save Data To Shared Preferences

  Future saveDataToSharedPreferences() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    await s.setString("uid", _uid!);
    await s.setString("name", _name!);
    await s.setString("email", _email!);
    await s.setString("imageUrl", _imageUrl!);
    await s.setString("provider", _provider!);

    notifyListeners();
  }

  // get data from Shared Preferences

  Future getDataFromSharedPreferences() async {
    final SharedPreferences s = await SharedPreferences.getInstance();

    _uid = s.getString("uid");
    _name = s.getString("name");
    _email = s.getString("email");
    _imageUrl = s.getString("imageUrl");
    _provider = s.getString("provider");

    notifyListeners();
  }

  // check user exists or not in CloudFirestore

  Future<bool> checkUserExists() async {
    DocumentSnapshot snap =
        await FirebaseFirestore.instance.collection("user").doc(_uid).get();

    if (snap.exists) {
      print("User Exists");
      return true;
    } else {
      print("New User");
      return false;
    }
  }

  // sign out

  Future userSignOut() async {
    await firebaseAuth.signOut;
    await googleSignIn.signOut();

    _isSignedIn = false;
    notifyListeners();

    // clear all data of the user
    clearStorageData();
  }

// clear all data of the user

  Future clearStorageData() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.clear();
  }
}
