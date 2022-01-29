import 'dart:io';

import 'package:bookingme/models/hall.dart';
import 'package:bookingme/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirestoreHall{
  final CollectionReference<Map<String, dynamic>> _hallCollection =
  FirebaseFirestore.instance.collection("halls");
  final FirebaseAuth _auth =  FirebaseAuth.instance;

  Future<void> addHallToFirestore(HallModel hallModel) async {
    return await _hallCollection.doc(hallModel.hallID).set(hallModel.toJson());
  }

   Future<List<String>> uploadMultiImages(List<XFile> image) async {
    List<String> uploadedListURL=[];
    firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
    for (var e in image) {
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref('/HallImage/${e.name}');
      firebase_storage.UploadTask uploadTask = ref.putFile(File(e.path));
      await uploadTask;
      print('File Uploaded');
      await ref.getDownloadURL().then((fileURL) {
        uploadedListURL.add(fileURL);
        print("uploadedFileURL: ${uploadedListURL.last}");
      });
    }

    return uploadedListURL;
  }
  getHalls()  {
     _hallCollection.where('ownID',isEqualTo:_auth.currentUser!.uid ).snapshots();
  }

}