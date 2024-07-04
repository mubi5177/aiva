import 'dart:async';
import 'dart:io';
import 'package:aivi/model/user_model.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:uuid/uuid.dart';
import 'package:rxdart/rxdart.dart';

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

    return users.add({
      'userId': userId,
      'name': name,
      'profileUrl': profileUrl,
      'phoneNumber': phoneNumber,
      'email': email,
      "loginType": loginType,
      "joinedSince": DateTime.now(),
    }).then((value) {
      saveUserJoinedDate();
    }).catchError((error) => print("Failed to add user: $error"));
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
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: email).get();

    // If any document matches the email, return true
    return querySnapshot.docs.isNotEmpty;
  } catch (e) {
    print('Error checking email existence: $e');
    return false; // Return false in case of any error
  }
}

Future<bool> checkAndAddNotificationSettings() async {
  try {
    // Reference to the user's document in 'notificationSetting' collection
    String userId = getCurrentUserId();
    print('checkAndAddNotificationSettings: $userId');
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('notificationsSettings').where('userId', isEqualTo: userId).get();

    // Check if the document exists
    if (querySnapshot.docs.isNotEmpty) {
      // Document already exists, settings are already added
      return true;
    } else {
      // Document does not exist, add a new document for this user
      return false;
    }
  } catch (e) {
    print('Error checking/notification settings: $e');
    return false; // Return false if there's any error
  }
}

// Function to get data from Firestore collection based on a field and its value
Future<Map<String, dynamic>> getDataByField() async {
  List<Map<String, dynamic>> dataList = [];
  String userId = getCurrentUserId();
  try {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection("notificationsSettings").where("userId", isEqualTo: userId).get();

    for (var doc in querySnapshot.docs) {
      dataList.add(doc.data());
    }

    return dataList[0];
  } catch (e) {
    if (kDebugMode) {
      print('Error getting data: $e');
    }
    return {};
  }
}

Future<String> getNotificationDocumentId() async {
  String userId = getCurrentUserId(); // Assuming you have a function to get current user ID

  try {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection("notificationsSettings").where("userId", isEqualTo: userId).get();

    if (querySnapshot.docs.isNotEmpty) {
      // Return the first document found (assuming userId is unique)
      var doc = querySnapshot.docs[0];
      return doc.id.toString();
    } else {
      return ""; // Return empty map if no documents found
    }
  } catch (e) {
    print('Error getting data: $e');
    return ""; // Return empty map on error
  }
}

Future<void> deleteDocument(String docId, String collection) async {
  try {
    // Get the Firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Delete the document from the collection
    await firestore.collection(collection).doc(docId).delete();

    // Document successfully deleted
    print('Document $docId successfully deleted.');
  } catch (e) {
    // Error deleting document
    print('Error deleting document: $e');
  }
}

Stream<List<Map<String, dynamic>>> fetchDataFromFirestore() {
  // Get today's date in "MM/dd/yyyy" format
  String formattedDate = DateFormat("MM/dd/yyyy").format(DateTime.now());
  print('fetchDataFromFirestore: $formattedDate');
  // Reference to Firestore collections
  final collection1Ref = FirebaseFirestore.instance.collection('appointments');
  final collection2Ref = FirebaseFirestore.instance.collection('tasks');
  String userId = getCurrentUserId();
  // Function to fetch snapshots from Firestore
  // Stream<QuerySnapshot<Map<String, dynamic>>> snapshots1 = collection1Ref.where('userId', isEqualTo: userId,).snapshots();
  Stream<QuerySnapshot<Map<String, dynamic>>> snapshots1 = collection1Ref
      .where('userId', isEqualTo: userId) // Up to end of today
      .where("date", isEqualTo: formattedDate.trim())
      .snapshots();
  Stream<QuerySnapshot<Map<String, dynamic>>> snapshots2 = collection2Ref
      .where(
        'userId',
        isEqualTo: userId,
      )
      .where("date", isEqualTo: formattedDate.trim())
      .snapshots();

  // Combine snapshots from both collections
  Stream<List<Map<String, dynamic>>> combinedStream =
      Rx.combineLatest2(snapshots1, snapshots2, (QuerySnapshot<Map<String, dynamic>> snapshot1, QuerySnapshot<Map<String, dynamic>> snapshot2) {
    List<Map<String, dynamic>> mergedData = [];

    // Add documents from collection1
    mergedData.addAll(snapshot1.docs.map((doc) => {
          'id': doc.id,
          ...doc.data(),
        }));

    // Add documents from collection2
    mergedData.addAll(snapshot2.docs.map((doc) => {
          'id': doc.id,
          ...doc.data(),
        }));

    return mergedData;
  });

  return combinedStream;
}

Future<List<Map<String, dynamic>>> fetchDataFromTwoCollections() async {
  // Reference to Firestore collections
  final collection1Ref = FirebaseFirestore.instance.collection('appointments');
  final collection2Ref = FirebaseFirestore.instance.collection('tasks');
  String userId = getCurrentUserId();
  // Fetch data from both collections concurrently
  final List<Future<QuerySnapshot>> futures = [
    collection1Ref.where('userId', isEqualTo: userId).get(),
    collection2Ref.where('userId', isEqualTo: userId).get(),
  ];

  // Wait for both requests to complete
  final results = await Future.wait(futures);

  // Merge the results into a single list
  List<Map<String, dynamic>> mergedData = [];
  for (var result in results) {
    mergedData.addAll(result.docs.map((doc) => {
          'id': doc.id, // Include the document ID
          ...doc.data()! as Map<String, dynamic>, // Include all other document data
        }));
  }

  return mergedData;
}

Future<void> updateUserData({
  required String name,
  required String profileUrl,
  String? phoneNumber,
  required String email,
}) async {
  try {
    String userId = getCurrentUserId();
    // Access Firestore instance
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').where("userId", isEqualTo: userId).get();

    // Check if there are any documents that match the query
    if (querySnapshot.docs.isNotEmpty) {
      // Update the document
      DocumentSnapshot docSnapshot = querySnapshot.docs.first;
      await docSnapshot.reference.update({
        'userId': userId,
        'name': name,
        'profileUrl': profileUrl,
        'phoneNumber': phoneNumber,
        'email': email,
      });
      print('Document updated successfully');
    } else {
      print('No matching documents');
    }
  } catch (error) {
    print('Error uploading data: $error');
  }
}

///----------------------------------------------------------\

Future<Map<String, List<Map<String, dynamic>>>> fetchData(String searchText) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String userId = getCurrentUserId();
  Map<String, List<Map<String, dynamic>>> fetchedData = {
    'users': [],
    'products': [],
    // Add more collections as needed
  };

  try {
    // Define your collection references
    CollectionReference usersCollection = firestore.collection('tasks');
    CollectionReference productsCollection = firestore.collection('appointments');
    CollectionReference notesCollection = firestore.collection('notes');
    CollectionReference habitsCollection = firestore.collection('habits');

    // Fetch data from users collection
    QuerySnapshot usersSnapshot = await usersCollection.where('userId', isEqualTo: userId).where("field", isEqualTo: searchText).get();

    // Process users collection documents
    fetchedData['users'] = usersSnapshot.docs.map((doc) {
      return {
        'id': doc.id,
        'data': doc.data(),
      };
    }).toList();

    // Fetch data from products collection
    QuerySnapshot productsSnapshot = await productsCollection.where('userId', isEqualTo: userId).where("field", isEqualTo: searchText).get();

    // Process products collection documents
    fetchedData['products'] = productsSnapshot.docs.map((doc) {
      return {
        'id': doc.id,
        'data': doc.data(),
      };
    }).toList();
  } catch (e) {
    // Error handling
    print('Error fetching data: $e');
  }

  return fetchedData;
}

Future<Map<String, dynamic>> searchDataFromCollections(String searchData) async {
  Map<String, dynamic> result = {
    'tasks': [],
    'notes': [],
    'appointments': [],
    'userHabits': [],
  };
  String userId = getCurrentUserId();
  try {
    // Query tasks collection
    var taskSnapshot =
        await FirebaseFirestore.instance.collection('tasks').where("userId", isEqualTo: userId).where('type_desc', isEqualTo: searchData).get();

    result['tasks'] = taskSnapshot.docs.map((doc) => doc.data()).toList();

    // Query notes collection
    var notesSnapshot =
        await FirebaseFirestore.instance.collection('notes').where("userId", isEqualTo: userId).where('title', isEqualTo: searchData).get();

    result['notes'] = notesSnapshot.docs.map((doc) => doc.data()).toList();

    // Query appointments collection
    var appointmentsSnapshot = await FirebaseFirestore.instance
        .collection('appointments')
        .where("userId", isEqualTo: userId)
        .where('type_desc', isEqualTo: searchData)
        .get();

    result['appointments'] = appointmentsSnapshot.docs.map((doc) => doc.data()).toList();

    // Query userHabits collection
    var userHabitsSnapshot =
        await FirebaseFirestore.instance.collection('userHabits').where("userId", isEqualTo: userId).where('title', isEqualTo: searchData).get();

    result['userHabits'] = userHabitsSnapshot.docs.map((doc) => doc.data()).toList();
    print('the data is $result');
    return result;
  } catch (e) {
    print('Error retrieving data: $e');
    return result; // Return the partially filled result in case of error
  }
}

///API

class ApiResponse {
  final String action;
  final Map<String, String> entities;

  ApiResponse({
    required this.action,
    required this.entities,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      action: json['action'],
      entities: Map<String, String>.from(json['entities']),
    );
  }

  @override
  String toString() {
    return 'Action: $action\nEntities: $entities';
  }
}

Future<ApiResponse?> callApi(String text) async {
  var headers = {
    'Content-Type': 'application/json',
    'Cookie':
        'ARRAffinity=cafe441b5f83725edc9bf516b4ea569e812ab6508c389d9aafdccfebe722c0ef; ARRAffinitySameSite=cafe441b5f83725edc9bf516b4ea569e812ab6508c389d9aafdccfebe722c0ef'
  };

  var data = json.encode({"input_text": text});

  var dio = Dio();

  try {
    var response = await dio.post(
      'https://mobi-ai-app-stage.azurewebsites.net/identify-aiva-action',
      options: Options(
        headers: headers,
      ),
      data: data,
    );

    if (response.statusCode == 200) {
      // Parse the JSON response into Task object
      print('callApi: ${response.data}');

      ApiResponse task = ApiResponse.fromJson(response.data);

      // Return the Task object
      return task;
    } else {
      print('Request failed with status: ${response.statusCode}');
      print('Response: ${response.data}');
      // Handle error scenario
      return null; // or throw an exception
    }
  } catch (e) {
    print('Exception caught: $e');
    // Handle Dio errors such as DioError
    return null; // or throw an exception
  }
}
