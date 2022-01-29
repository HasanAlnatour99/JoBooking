import 'package:bookingme/controllers/auth_controller.dart';
import 'package:bookingme/ui/widgets/button.dart';
import 'package:bookingme/ui/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../theme.dart';
import 'login_page.dart';

class SignUpPage extends StatelessWidget {
  final controller = Get.put(AuthController());
  GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>(debugLabel: "Signup");
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: MyIconButton(onPressed:() => Get.off(()=>LoginPage()),icon: Icons.arrow_back,iconSize: 25,color: Colors.black,),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: signUpFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height:15),
                   Text("Let's Get Started!",style: Themes.header2.copyWith(
                     color: Colors.black,
                   ),),
                  const SizedBox(height:5),
                  Text("Create an account to JoBooking it's free",style: Themes.header4,),
                  const SizedBox(height:15),
                  InputField(
                    controller:controller.nameController ,
                    labelText: "Full Name",
                    icon: FontAwesomeIcons.solidUser,
                    isDense:true,
                    onChanged: (val) {
                    },
                    onSaved: (value) {
                      controller.name = value!;
                    },
                    onValidator: (value) {
                      return controller.validateName(value!);
                    },
                  ),
                  InputField(
                    controller:controller.emailController ,
                    labelText: "Email",
                    keyboardType: TextInputType.emailAddress,
                    icon: FontAwesomeIcons.solidEnvelope,
                    isDense:true,
                    onChanged: (val) {
                    },
                    onSaved: (value) {
                      controller.email = value!;
                    },
                    onValidator: (value) {
                      return controller.validateEmail(value!);
                    },
                  ),
                  InputField(
                    controller:controller.phoneController ,
                    labelText: "Phone",
                    keyboardType: TextInputType.phone,
                    icon: FontAwesomeIcons.mobileAlt,
                    isDense:true,
                    onChanged: (val) {
                    },
                    onSaved: (value) {
                      controller.phone = value!;
                    },
                    onValidator: (value) {
                      return controller.validatePhone(value!);
                    },
                  ),
                  GetBuilder(
                    init:AuthController() ,
                    builder:(_)=> InputField(
                      isDense:true,
                      keyboardType: TextInputType.visiblePassword,
                      hidePassword: controller.hidePassword,
                      toggleEyePassword: ()=>controller.toggleEyePassword(),
                      controller: controller.passwordController,
                      labelText: "Password",
                      icon: FontAwesomeIcons.userLock,
                      obscure: true,
                      onChanged: (val) {},
                      onSaved: (value) {
                        controller.password = value!;
                      },
                      onValidator: (value) {
                        return controller.validatePassword(value!);
                      },
                    ),
                  ),
                  GetBuilder(
                    init:AuthController() ,
                    builder:(_)=> InputField(
                      isDense:true,
                      keyboardType: TextInputType.visiblePassword,
                      hidePassword: controller.hidePassword,
                      toggleEyePassword: ()=>controller.toggleEyePassword(),
                      controller: controller.confirmPasswordController,
                      labelText: "Confirm Password",
                      icon: FontAwesomeIcons.userLock,
                      obscure: true,
                      onChanged: (val) {
                      },
                      onSaved: (value) {
                        controller.confirmPassword = value!;
                      },
                      onValidator: (value) {
                        return controller.validateConfirmPassword(value!);
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  MyButton(
                    text: "CREATE",
                    onPressed:()=>controller.signUp(signUpFormKey),
                    width: size.width * 0.5,
                  ),
                  const SizedBox(height: 20),
                  // Text("-OR-",style: Themes.header3.copyWith(color: Colors.black),),
                  // const SizedBox(height: 10),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //   children: [
                  //     GestureDetector(
                  //       onTap: (){
                  //         controller.facebookSignInMethod();
                  //       },
                  //       child: Container(
                  //         height: size.height * 0.15,
                  //         width: size.width * 0.15,
                  //         decoration: BoxDecoration(
                  //             image: DecorationImage(image: Image.asset("assets/facebook.png").image)
                  //         ),
                  //       ),
                  //     ),
                  //   Container(height: 30,width: 1,color: Colors.grey,alignment: Alignment.center,),
                  //   GestureDetector(
                  //     onTap: (){
                  //       controller.googleSignInMethod();
                  //     },
                  //     child: Container(
                  //       height: size.height * 0.1,
                  //       width: size.width * 0.1,
                  //       decoration: BoxDecoration(
                  //         image: DecorationImage(image: Image.asset("assets/google.png").image)
                  //       ),
                  //     ),
                  //   ),
                  // ],),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
