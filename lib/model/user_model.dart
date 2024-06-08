import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class UserModel {
 final String name;
 final String phone;
 final String email;
 final String profile;
 final String loginType;


  // Constructor
  UserModel({this.name = '', this.phone = '', this.email = '', this.profile = '',this.loginType=''});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      profile: json['profile'],
      loginType: json['loginType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'profile': profile,
      'loginType': loginType,
    };
  }
}

// Save user model data
void saveUserData(UserModel user) async {
  final storage = FlutterSecureStorage();
  await storage.write(key: 'user', value: jsonEncode(user.toJson()));
}

// Retrieve user model data
Future<UserModel?> getUserData() async {
  final storage = new FlutterSecureStorage();
  String? userDataString = await storage.read(key: 'user');
  if (userDataString != null) {
    Map<String, dynamic> userDataJson = jsonDecode(userDataString);
    return UserModel.fromJson(userDataJson);
  }
  return null;
}
