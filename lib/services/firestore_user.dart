import 'dart:io';

import 'package:bookingme/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
class FireStoreUser {
  final CollectionReference<Map<String, dynamic>> _userCollection =
      FirebaseFirestore.instance.collection("users");
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addUserToFirestore(UserModel userModel) async {
    return await _userCollection.doc(userModel.userId).set(userModel.toJson());
  }
  Future<void> updateUserInfo({type,updateItem}) async {
  return  await _userCollection.doc(_auth.currentUser!.uid).update({type:updateItem});

  }
   getUserInfo({type}) async {
    int myHalls = 0;
    int booked = 0 ;
    await _userCollection.doc(_auth.currentUser!.uid).get().then((value) async{
     await FirebaseFirestore.instance.collection("halls").where('ownID', isEqualTo: _auth.currentUser!.uid).get().then((value) {
      myHalls =  value.docs.length;
     });
     await FirebaseFirestore.instance.collection("orders").where('visitorID', isEqualTo: _auth.currentUser!.uid).get().then((value) {
       booked =  value.docs.length;
     });
      Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
      final SharedPreferences prefs = await _prefs;
      prefs.setString("name", value.data()!['name']);
      prefs.setString("email", value.data()!['email']);
      prefs.setString("phone", value.data()!['phone']??"empty");
      prefs.setString("pic", value.data()!['pic']??"");
      prefs.setInt("myHalls", myHalls);
     prefs.setInt("booked", booked);
      return value.data()!['name'].toString();
    });

  }

   Future<String> uploadFile(image) async {
    String uploadedFileURL='';
     firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
     firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref('/profileImage/${_auth.currentUser!.uid}');
     firebase_storage.UploadTask uploadTask = ref.putFile(image);
      await uploadTask;
      print('File Uploaded');
      await ref.getDownloadURL().then((fileURL) {
        uploadedFileURL = fileURL;
      });
      print("uploadedFileURL: $uploadedFileURL");
      return uploadedFileURL;
  }
  Future<String> uploadFilePromos(File image) async {
    String uploadedFileURL='';
    firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref('/promos/${image.path.toString()}');
    firebase_storage.UploadTask uploadTask = ref.putFile(image);
    await uploadTask;
    print('File Uploaded');
    await ref.getDownloadURL().then((fileURL) {
      uploadedFileURL = fileURL;
    });
    print("uploadedFileURL: $uploadedFileURL");
    return uploadedFileURL;
  }
}
class UserSecureStorage {
  static const _storage = FlutterSecureStorage();

  static const _keyUserToken = 'Token';

  static Future setUserToken(String token) async {
    await _storage.write(key: _keyUserToken, value: token);
  }
  static Future<String?> getUserToken() async {
    final String? s = await _storage.read(key: _keyUserToken) ;
    print("get user token");
    print(s);
    return s;
  }
  static Future<void> deleteUserToken() async =>
      await _storage.delete(key: _keyUserToken);
}
