import 'package:bookingme/controllers/auth_controller.dart';
import 'package:bookingme/controllers/profile_controller.dart';
import 'package:bookingme/ui/pages/profile.dart';
import 'package:bookingme/ui/widgets/button.dart';
import 'package:bookingme/ui/widgets/input_field.dart';
import 'package:bookingme/ui/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme.dart';

class EditProfile extends StatelessWidget {
  EditProfile({Key? key, this.title, this.type}) : super(key: key);
  final String? title;
  final String? type;

  ProfileController controller = Get.put(ProfileController());
  AuthController authController = Get.put(AuthController());
  GlobalKey<FormState> editProfileFormKey =
      GlobalKey<FormState>(debugLabel: "editProfileFormKey");
  GlobalKey<FormState> txt1Key =
  GlobalKey<FormState>(debugLabel: "txt1Key");


  @override
  Widget build(BuildContext context) {
    print(controller.name);
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        title: Text(
          title!,
          style: Themes.header2,
        ),
        centerTitle: true,
        backgroundColor: blueClr,
        leading: MyIconButton(
          onPressed: () => Get.back(),
          icon: Icons.arrow_back,
          iconSize: 25,
          color: Colors.white,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(20),
            child: GetBuilder(
              init: ProfileController(),
              builder: (_) => Column(
                children: [
                  const SizedBox(height: 40),
                  Form(
                    key:txt1Key,
                    child: TextFormField(
                      cursorColor: blueClr,
                      onChanged: (C) {},
                      obscureText:type == "Pass" ? true : false ,
                      controller: type == "Pass" ?controller.passwordController:null,
                      readOnly: type == "Pass" ? false : true,
                      initialValue: type == "N"
                          ? controller.name
                          : type == "E"
                              ? controller.email
                              : type == "P"
                                  ? controller.phone
                                  : null,
                      onSaved: (d) {},
                      validator: (value) {
                        return type == "N"
                            ? AuthController().validateName(value!)
                            : type == "E"
                                ? AuthController().validateEmail(value!)
                                : type == "P"
                                    ? AuthController().validatePhone(value!)
                                    : AuthController().validatePassword(value!);
                      },
                      decoration: InputDecoration(
                          filled: type == "Pass" ? false : true,
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          labelText: type == "N"
                              ? "Name"
                              : type == "E"
                                  ? 'Email Address'
                                  : type == "P"
                                      ? 'Phone Number'
                                      : 'Current Password',
                          enabled: type == "Pass" ? true : false,
                          labelStyle: Themes.inputStyle,
                          prefixIcon: Icon(
                            type == "N"
                                ? FontAwesomeIcons.userAlt
                                : type == "E"
                                    ? FontAwesomeIcons.solidEnvelope
                                    : type == "P"
                                        ? FontAwesomeIcons.mobileAlt
                                        : FontAwesomeIcons.userLock,
                            color: Colors.blueGrey,
                            size: 18,
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(color: blueClr)),
                          floatingLabelStyle: Themes.inputStyle.copyWith(
                            fontSize: 18,
                          )),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Form(
                    key: editProfileFormKey,
                    child: GetBuilder(
                      init: AuthController(),
                      builder:(_)=> TextFormField(
                        obscureText:type != "Pass" ? false : authController.hidePassword ,
                        inputFormatters: [
                          if (type == "P") LengthLimitingTextInputFormatter(10)
                        ],
                        controller: type == "N"
                            ? controller.nameController
                            : type == "E"
                                ? controller.emailController
                                : type == "P"
                                    ? controller.phoneController
                                    : controller.newPasswordController,
                        cursorColor: blueClr,
                        onChanged: (C) {},
                        autofocus: true,
                        onSaved: (value) {
                          type == "N"
                              ? controller.name = value!
                              : type == "E"
                                  ? controller.email = value!
                                  : type == "P"
                                      ? controller.phone = value!
                                      : controller.password = value!;
                        },
                        validator: (value) {
                          return type == "N"
                              ? AuthController().validateName(value!)
                              : type == "E"
                                  ? AuthController().validateEmail(value!)
                                  : type == "P"
                                      ? AuthController().validatePhone(value!)
                                      : AuthController().validatePassword(value!);
                        },
                        decoration: InputDecoration(
                            suffixIcon: type=='Pass'
                                ? GetBuilder(
                                  init: AuthController(),
                                  builder:(_)=> MyIconButton(
                              icon: authController.hidePassword
                                    ? FontAwesomeIcons.eyeSlash
                                    : FontAwesomeIcons.eye,
                              color: Colors.blueGrey,
                              onPressed: () => authController.toggleEyePassword(),
                            ),
                                )
                                : null,
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            labelText:
                                "New ${type == "N" ? "Name" : type == "E" ? 'Email Address' : type == "P" ? 'Phone Number' : 'Password'}",
                            labelStyle: Themes.inputStyle,
                            // hintText: 'example@domain.com',

                            prefixIcon: Icon(
                              type == "N"
                                  ? FontAwesomeIcons.userAlt
                                  : type == "E"
                                      ? FontAwesomeIcons.solidEnvelope
                                      : type == "P"
                                          ? FontAwesomeIcons.mobileAlt
                                          : FontAwesomeIcons.userLock,
                              color: Colors.blueGrey,
                              size: 18,
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(color: blueClr)),
                            floatingLabelStyle: Themes.inputStyle.copyWith(
                              fontSize: 18,
                            )),
                        keyboardType: type == "N"
                            ? TextInputType.text
                            : type == "E"
                                ? TextInputType.emailAddress
                                : type == "P"
                                    ? TextInputType.phone
                                    : TextInputType.text,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  MyButton(
                    text: 'Save',
                    onPressed: () async {
                      if (type == "N") {
                        ProfileController().updateName(
                            controller.nameController.text,
                            editProfileFormKey,
                            type);
                      } else if (type == "E") {
                        ProfileController().updateEmail(
                            controller.emailController.text,
                            editProfileFormKey,
                            type);
                      } else if (type == "P") {
                        ProfileController().updatePhone(
                            controller.phoneController.text,
                            editProfileFormKey,
                            type);
                      } else {
                        // current password
                         if(!txt1Key.currentState!.validate())return ;
                         if(!editProfileFormKey.currentState!.validate())return;
                       var vp= await ProfileController().validatePassword(
                            controller.passwordController.text);
                       vp?
                         ProfileController().updatePassword(controller.newPasswordController.text,editProfileFormKey,txt1Key):
                       getXSnackBar(
                           titleAndMessage: false,
                           title: 'Current Password is incorrect',
                           onButton: false,
                           icon: FontAwesomeIcons.exclamationCircle);

                      }
                      await ProfileController().getInfo();
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
