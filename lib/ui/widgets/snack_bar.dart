
 import 'package:bookingme/ui/pages/sign_up_page.dart';
import 'package:bookingme/ui/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../theme.dart';

getXSnackBar({required String title,Duration? duration, String messageText="",bool titleAndMessage=false,bool onButton=false,IconData? icon,VoidCallback? onPressed}){
  Get.snackbar('','',
      duration:duration ?? Duration(seconds: 3),
      mainButton:onButton? TextButton(onPressed: (){},child:MyIconButton(onPressed: onPressed, icon: FontAwesomeIcons.arrowAltCircleRight)):null,
      isDismissible: true,
      titleText: Text(title,style: Themes.header3,),
      messageText: Text(messageText,style: Themes.header3,),
      borderRadius: 30,
      icon:icon==null?null: Icon(icon,color:whiteClr ,),
      backgroundColor: blueClr,
      userInputForm:titleAndMessage?null: Form(child:ListTile(
        dense: true,
        title: Text(title,style: Themes.header3,),
        leading: Icon(icon,color:whiteClr ,),
      ),
      ),
      colorText: whiteClr, snackPosition: SnackPosition.TOP);
}