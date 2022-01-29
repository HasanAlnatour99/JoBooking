import 'package:bookingme/services/firestore_user.dart';
import 'package:bookingme/services/utilits.dart';
import 'package:bookingme/ui/pages/profile.dart';
import 'package:bookingme/ui/widgets/snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_controller.dart';

class ProfileController extends GetxController {
  late TextEditingController emailController,
      passwordController,
      newPasswordController=TextEditingController(),
      phoneController,
      nameController;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var email = '';
  var isLoading = true;
  var pic = '';

  var name = '';
  int myHalls = 0;
  int booked = 0;
  var phone = '';

  var password = '';

  var newPassword='';


  @override
  onInit() {
    getInfo();
    super.onInit();
    newPasswordController = TextEditingController();
    phoneController = TextEditingController();
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();

  }

  @override
  void onReady() {
    super.onReady();
  }

  // @override
  // void onClose() {
  //   newPasswordController.dispose();
  //   phoneController.dispose();
  //   nameController.dispose();
  //   emailController.dispose();
  //   passwordController.dispose();
  //   // passwordController.clear();
  // }
  clearController(){
    newPasswordController.clear();
    phoneController.clear();
    nameController.clear();
    emailController.clear();
    passwordController.clear();
  }
  getInfo() async {
    try {
      isLoading = true;
      Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
      final SharedPreferences prefs = await _prefs;
      name = prefs.getString('name')!;
      email = prefs.getString('email')!;
      phone = prefs.getString('phone')!;
      pic = prefs.getString('pic')!;
      myHalls = prefs.getInt('myHalls')!;
      booked = prefs.getInt('booked')!;
      update();
    } finally {
      isLoading = false;
      update();
    }
  }
  updateProfileImage() async{
    pic = await imagePicker();
    update();
    await _auth.currentUser!.updatePhotoURL(pic).then((value) async {
     await  FireStoreUser().updateUserInfo(type:'pic',updateItem: pic);
     await updateSharedPrefs('photo',pic);
     await getInfo();
    });
  }


  Future<void> updateName(String displayName, GlobalKey<FormState> key,type) async {
    if (!key.currentState!.validate()) {
      return;
    } else {
      key.currentState!.save();
      await FireStoreUser()
          .updateUserInfo(type: "name", updateItem: displayName);
      await _auth.currentUser!.updateDisplayName(displayName);
      await updateSharedPrefs(type,displayName);

      Get.off(() => ProfilePage());
      update();
    }
  }

  Future updateEmail(String email, GlobalKey<FormState> key,type) async {
    if (!key.currentState!.validate()) {
      return;
    }
    final s = await FirebaseFirestore.instance.collection("users").where("email", isEqualTo: email).get().then((value) => value.docs.length);
    if(s!=0) {
        return xSnackBar(title: 'The account already exists for that email.');
    }
    try {
      key.currentState!.save();
      await _auth.currentUser!.updateEmail(
        GetUtils.removeAllWhitespace(email.toLowerCase()),
      ).then((value) async {
        await FireStoreUser().updateUserInfo(
          type: "email",
          updateItem: GetUtils.removeAllWhitespace(email.toLowerCase()),
        );
      });
      await updateSharedPrefs(type,GetUtils.removeAllWhitespace(email.toLowerCase()));
      Get.off(() => ProfilePage());
    } catch (e) {
      xSnackBar(title: e.toString().split(']')[1]);
    }
  }

  Future<void> updatePhone(String phone, GlobalKey<FormState> key,type) async {
    if (!key.currentState!.validate()) {
      return;
    } else {
      key.currentState!.save();
      await FireStoreUser().updateUserInfo(type: "phone", updateItem: phone);
      // await _auth.currentUser!.updatePhoneNumber(phone);
      await updateSharedPrefs(type,phone);
      update();
      Get.off(() => ProfilePage());
    }
  }

  Future<void> updateSharedPrefs(type,data) async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    type == 'N' ? prefs.setString("name", data) : null;
    type == 'E' ? prefs.setString("email", data) : null;
    type == 'P' ? prefs.setString("phone", data) : null;
    type == 'photo'? prefs.setString("pic", data) : null;
    print(type);
    update();
    return;
  }

  Future<bool> validatePassword(String password1) async {
    var firebaseUser =  _auth.currentUser;

    var authCredentials = EmailAuthProvider.credential(
        email: firebaseUser!.email!, password: password1);
    try {
      var authResult = await firebaseUser
          .reauthenticateWithCredential(authCredentials);
      return authResult.user != null;
    } catch (e) {
      print(e);
      return false;
    }
  }

   updatePassword(String password,GlobalKey<FormState> formkey,GlobalKey<FormState> txt1Key)  {
    var firebaseUser =  _auth.currentUser!;
    firebaseUser.updatePassword(password);
    Get.off(() => ProfilePage());
    getXSnackBar(
        titleAndMessage: false,
        title: 'Password has been updated successfully',
        onButton: false,
        icon: FontAwesomeIcons.exclamationCircle);
  }

  xSnackBar({title}) {
    getXSnackBar(
        titleAndMessage: false,
        title: title,
        onButton: false,
        icon: FontAwesomeIcons.exclamationCircle);
  }
}
