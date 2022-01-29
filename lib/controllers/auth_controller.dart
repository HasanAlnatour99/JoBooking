import 'package:bookingme/models/user.dart';
import 'package:bookingme/services/firestore_user.dart';
import 'package:bookingme/ui/pages/homescreen.dart';
import 'package:bookingme/ui/pages/login_page.dart';
import 'package:bookingme/ui/pages/sign_up_page.dart';
import 'package:bookingme/ui/widgets/bottom_navigation.dart';
import 'package:bookingme/ui/widgets/snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  late TextEditingController emailController,
      passwordController,
      confirmPasswordController,
      phoneController,
      nameController;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var email = '';
  var password = '';
  var name = '';
  var phone = '';
  var confirmPassword = '';
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  bool hidePassword = true;

  @override
  void onInit() {
    super.onInit();
    confirmPasswordController = TextEditingController();
    phoneController = TextEditingController();
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    confirmPasswordController.clear();
    phoneController.clear();
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    passwordController.clear();
  }

  String? validateName(String value) {
    if (value.isEmpty) {
      return '';
    }
    if (!GetUtils.hasMatch(value, r'^[a-zA-z].*[\s].*[a-zA-Z]+([a-zA-Z]+)*$')) {
      return "Full Name is invalid";
    }
    return null;
  }

  String? validatePhone(String value) {
    if (value.isEmpty) {
      return '';
    }
    if (!GetUtils.isLengthBetween(value, 6, 10)) {
      return "Phone number is invalid";
    }
    return null;
  }

  String? validateEmail(String value) {
    if (value.isEmpty) {
      return '';
    }
    if (!GetUtils.isEmail(value)) {
      return "Email address is invalid";
    }
    return null;
  }

  String? validatePassword(String value) {
    if (value.isEmpty) {
      return '';
    }
    else if(value.length<6) {
      return "Password is too short!";
    }
    return null;
  }

  String? validateConfirmPassword(String value) {
    if (value.isEmpty) {
      return '';
    }
    if (passwordController.text != value) {
      return "Passwords do not match";
    }
    return null;
  }

  toggleEyePassword() {
    hidePassword = !hidePassword;
    update();
  }

  void checkLogin(GlobalKey<FormState> loginFormKey) async {
    final isValid = loginFormKey.currentState!.validate();
    if (!isValid) {
      return ;
    }
    loginFormKey.currentState!.save();

     await loginWithEmailAndPassword();
  }

  Future sendPasswordResetEmail(String email, formkey) async {
    final isValid = formkey.currentState!.validate();
    if (!isValid) return;
    return _auth.sendPasswordResetEmail(email: email);
  }

  void googleSignInMethod() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    print(googleUser);
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleUser!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken,
    );

    await _auth.signInWithCredential(credential).then((user) {
      saveUser(user, 'empty');
    });
    Get.off(()=>BottomNavigation(index: 0,));
  }

  void facebookSignInMethod() async {
    final LoginResult result = await FacebookAuth.instance.login();
    print(result.message);
    AccessToken? accessToken = result.accessToken;
    bool isLoggedIn = accessToken != null && !accessToken.isExpired;
    if (isLoggedIn) {
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(result.accessToken!.token);
      await _auth.signInWithCredential(facebookAuthCredential).then((user) {
        saveUser(user, 'empty');
      });
      Get.off(()=>BottomNavigation(index: 0,));
    }
  }

  Future<void> loginWithEmailAndPassword() async {
    try {
      await _auth
          .signInWithEmailAndPassword(
              email: GetUtils.removeAllWhitespace(email.toLowerCase()),
              password: password)
          .then((value) async {
        final ss = await value.user!.getIdTokenResult();
        UserSecureStorage.setUserToken(ss.token!);
        await FireStoreUser().getUserInfo();
        Get.off(()=>BottomNavigation(index:0));
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        getXSnackBar(
            titleAndMessage: true,
            duration: const Duration(seconds: 4),
            title: "No user found for that email.",
            messageText: "Please try Sign Up",
            onButton: true,
            onPressed: () => Get.off(() => SignUpPage()),
            icon: FontAwesomeIcons.exclamationCircle);
      } else if (e.code == 'wrong-password') {
        xSnackBar(title: 'Wrong password provided for that user.');
      }
    }
  }

  void signUp(GlobalKey<FormState> signUpFormKey) async {
    final isValid = signUpFormKey.currentState!.validate();
    if (!isValid) return;
    signUpFormKey.currentState!.save();
    try {
      await _auth
          .createUserWithEmailAndPassword(
        email: GetUtils.removeAllWhitespace(email.toLowerCase()),
        password: password,
      )
          .then((userCred) async {
        saveUser(userCred, phone);
        Get.off(() => LoginPage());
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        xSnackBar(title: 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        xSnackBar(title: 'The account already exists for that email.');
      }
    } catch (e) {
      xSnackBar(title: e.toString());
    }
  }

  Future<void> saveUser(UserCredential userCred, phone) async {
    return await FireStoreUser().addUserToFirestore(UserModel(
      email: userCred.user!.email,
      userId: userCred.user!.uid,
      name: name == "" ? userCred.user!.displayName : name,
      pic: userCred.user!.photoURL ?? "",
      phone: userCred.user!.phoneNumber ?? phone,
    ));
  }

  xSnackBar({title}) {
    getXSnackBar(
        titleAndMessage: false,
        title: title,
        onButton: false,
        icon: FontAwesomeIcons.exclamationCircle);
  }
}
