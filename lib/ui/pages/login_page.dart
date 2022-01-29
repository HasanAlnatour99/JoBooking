import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bookingme/controllers/auth_controller.dart';
import 'package:bookingme/ui/widgets/button.dart';
import 'package:bookingme/ui/widgets/input_field.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme.dart';
import 'forget_password.dart';
import 'sign_up_page.dart';

class LoginPage extends StatelessWidget {
  final controller = Get.put(AuthController());
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>(debugLabel: "Login");

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body:  SafeArea(
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              buildDelayedDisplay(size),
               Expanded(
                 flex:18,
                 child: Container(
                      alignment: Alignment.topCenter,
                      padding: const EdgeInsets.only(
                          top: 20, left: 30, bottom: 20, right: 30),
                      margin: const EdgeInsets.only(
                          top: 10, left: 0, bottom: 0, right: 0),
                      child:SingleChildScrollView(physics:const BouncingScrollPhysics(),child: LoginForm(size,controller)),
                    ),
               ),
              Expanded(flex:4,child: Image.asset("assets/Login.gif",fit: BoxFit.fill,)),

            ],
          )),
    );
  }

  Row buildDelayedDisplay(Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children:[
      DelayedDisplay(
              slidingCurve: Curves.elasticIn,
              slidingBeginOffset:const Offset(0,0),
              fadeIn: true,
              child: Container(
                width: size.width * 0.55,
                height: size.height * 0.2,
                alignment: Alignment.topLeft,
                padding:const EdgeInsets.only(left: 15),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(200),
                      topRight: Radius.circular(200),
                    ),
                    color: blueClr,
                    shape: BoxShape.rectangle),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    AnimatedTextKit(
                      totalRepeatCount: 1,
                      animatedTexts: [
                        ColorizeAnimatedText(
                          'WELCOME BACK',
                          speed:const Duration(milliseconds: 400),
                          textStyle: Themes.header3.copyWith(fontFamily: GoogleFonts.lora().fontFamily,fontSize: 18),
                          colors: [
                            Colors.white,
                            orangeClr,
                            Colors.white,
                          ],
                        ),
                      ],
                      // isRepeatingAnimation: true,
                    ),
                    const SizedBox(height: 30),
                    TextButton(
                      child:const Text("Create a new account",style: TextStyle(color: Colors.white),) ,
                      onPressed: () {
                      Get.off(()=>SignUpPage());
                    },
                    )
                  ],
                ),
              ),
            ),
      // MyTextButton(onPressed: null,text: "Create new account",textSize: 14,color: blueClr,),

      ] );
  }

  Form LoginForm(Size size, AuthController controller) {
    return Form(
                key:loginFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InputField(
                      controller:controller.emailController ,
                      labelText: "Email",
                      keyboardType: TextInputType.emailAddress,
                      icon: FontAwesomeIcons.solidEnvelope,
                      onChanged: (val) {
                      },
                      onSaved: (value) {
                        controller.email = value!;
                      },
                      onValidator: (value) {
                        return controller.validateEmail(value!);
                      },
                    ),
                    GetBuilder(
                      init:AuthController() ,
                      builder:(_)=> InputField(
                        keyboardType: TextInputType.visiblePassword,
                        hidePassword: controller.hidePassword,
                        toggleEyePassword: ()=>controller.toggleEyePassword(),
                        controller: controller.passwordController,
                        labelText: "Password",
                        icon: FontAwesomeIcons.userLock,
                        obscure: true,
                        onChanged: (val) {
                        },
                        onSaved: (value) {
                          controller.password = value!;
                        },
                        onValidator: (value) {
                          return controller.validatePassword(value!);
                        },
                      ),
                    ),
                    MyTextButton(text: "Forget Your Password?",color: blueClr, onPressed: () {
                      Get.off(()=>ForgetPassword());
                    },),
                    const SizedBox(height: 20),
                    MyButton(
                      text: "LOGIN",
                      onPressed:()=>controller.checkLogin(loginFormKey),
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
                    //     Container(height: 30,width: 1,color: Colors.grey,alignment: Alignment.center,),
                    //     GestureDetector(
                    //       onTap: (){
                    //         controller.googleSignInMethod();
                    //       },
                    //       child: Container(
                    //         height: size.height * 0.1,
                    //         width: size.width * 0.1,
                    //         decoration: BoxDecoration(
                    //             image: DecorationImage(image: Image.asset("assets/google.png").image)
                    //         ),
                    //       ),
                    //     ),
                    //   ],),

                  ],
                ),
              );
  }
}
