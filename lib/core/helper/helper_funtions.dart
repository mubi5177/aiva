import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:uuid/uuid.dart';

Future<dynamic> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  } on FirebaseAuthException catch (e) {
    Fluttertoast.showToast(
      msg: e.toString(),
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.SNACKBAR,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }
}

/// Generates a cryptographically secure random nonce, to be included in a
/// credential request.
String generateNonce([int length = 32]) {
  const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
  final random = Random.secure();
  return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
}

/// Returns the sha256 hash of [input] in hex notation.
String sha256ofString(String input) {
  final bytes = utf8.encode(input);
  final digest = sha256.convert(bytes);
  return digest.toString();
}

Future<UserCredential> signInWithApple() async {
  // To prevent replay attacks with the credential returned from Apple, we
  // include a nonce in the credential request. When signing in with
  // Firebase, the nonce in the id token returned by Apple, is expected to
  // match the sha256 hash of `rawNonce`.
  final rawNonce = generateNonce();
  final nonce = sha256ofString(rawNonce);

  // Request credential for the currently signed in Apple account.
  final appleCredential = await SignInWithApple.getAppleIDCredential(
    scopes: [
      AppleIDAuthorizationScopes.email,
      AppleIDAuthorizationScopes.fullName,
    ],
    nonce: nonce,
  );

  // Create an `OAuthCredential` from the credential returned by Apple.
  final oauthCredential = OAuthProvider("apple.com").credential(
    idToken: appleCredential.identityToken,
    rawNonce: rawNonce,
  );

  // Sign in the user with Firebase. If the nonce we generated earlier does
  // not match the nonce in `appleCredential.identityToken`, sign in will fail.

  return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
}

// Get the current user's display name
String getCurrentUserName() {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    return user.displayName ?? "No Display Name";
  } else {
    return "No User Logged In";
  }
}

Future<void> uploadUserData(
    {required String name, required String profileUrl, String? phoneNumber, required String email, required String loginType}) async {
  try {
    String userId = getCurrentUserId();
    // Access Firestore instance
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return users
        .add({
          'userId': userId,
          'name': name,
          'profileUrl': profileUrl,
          'phoneNumber': phoneNumber,
          'email': email,
          "loginType": loginType,
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  } catch (error) {
    print('Error uploading data: $error');
  }
}
//

String generateUserId() {
  // Create a new UUID
  var uuid = const Uuid();

  // Generate a random user ID
  return uuid.v4();
}

// Function to upload image to Firebase Storage
Future<String> uploadImage(File imageFile) async {
  try {
    // Upload image to Firebase Storage
    final firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref().child('images').child('${DateTime.now().millisecondsSinceEpoch}.jpg');
    await ref.putFile(imageFile!);

    // Get download URL of the uploaded image
    final String downloadURL = await ref.getDownloadURL();
    print('Image uploaded successfully. Download URL: $downloadURL');

    return downloadURL;
  } catch (e) {
    print('Error uploading image: $e');
    return '';
  }
}

Future<void> uploadDataToFirestore(String collectionName, Map<String, dynamic> data) async {
  try {
    // Reference to the Firestore collection
    CollectionReference collectionReference = FirebaseFirestore.instance.collection(collectionName);

    // Add the data to Firestore
    await collectionReference.add(data);

    print('Data uploaded to Firestore successfully!');
  } catch (e) {
    print('Error uploading data to Firestore: $e');
  }
}
Future<void> updateDataOnFirestore(String collectionName, Map<String, dynamic> data, String id) async {
  try {
    // Update the data to Firestore
    await FirebaseFirestore.instance.collection(collectionName).doc(id).update(data);

    print('Data updated on Firestore successfully!');
  } catch (e) {
    print('Error uploading data to Firestore: $e');
  }
}

// Get the current user ID
String getCurrentUserId() {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    return user.uid;
  } else {
    // User is not signed in
    return '';
  }
}


Future<bool> checkEmailExistence(String email) async {
  try {
    // Query the user collection for documents with the provided email
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    // If any document matches the email, return true
    return querySnapshot.docs.isNotEmpty;
  } catch (e) {
    print('Error checking email existence: $e');
    return false; // Return false in case of any error
  }
}