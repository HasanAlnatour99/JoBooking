import 'package:bookingme/controllers/auth_controller.dart';
import 'package:bookingme/ui/widgets/button.dart';
import 'package:bookingme/ui/widgets/input_field.dart';
import 'package:bookingme/ui/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'login_page.dart';

class ForgetPassword extends StatelessWidget {
  GlobalKey<FormState> fgFormKey = GlobalKey<FormState>(debugLabel: "resetPassword");
   ForgetPassword({Key? key}) : super(key: key);
  final controller = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 6,
        centerTitle: true,
        title: Text('Reset Password',style: TextStyle(color:Colors.black),),
        backgroundColor: Colors.white,
        leading: MyIconButton(onPressed:() => Get.off(()=>LoginPage()),icon: Icons.arrow_back,iconSize: 25,color: Colors.black,),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height:30),
            Center(
              child: Form(
                key: fgFormKey,
                child: InputField(
                  onValidator: (val)=>controller.validateEmail(val!),
                  onChanged: (String value) {  },
                  labelText: 'Email Address',
                  icon: FontAwesomeIcons.solidEnvelope,
                  controller: controller.emailController,
                ),
              ),
            ),
            const SizedBox(height:30),
            MyButton(
              onPressed: (){
                AuthController().sendPasswordResetEmail(controller.emailController.text,fgFormKey).then((value) {
                  getXSnackBar(title: 'Check Your Email',icon: FontAwesomeIcons.exclamationCircle,titleAndMessage:true,messageText:  'A message has been sent to your mail' );
                }).onError((error, stackTrace) {
                  print(error);
                  var x = error.toString().split(']')[1];
                  getXSnackBar(title: 'Email is incorrect',messageText:x ,icon: FontAwesomeIcons.exclamationCircle ,titleAndMessage: true,duration: Duration(seconds: 7));
                });
              },
              text: 'Submit',
            )
          ],
        ),
      ),
    );

  }
}
