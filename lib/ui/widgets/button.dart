import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../theme.dart';

class MyButton extends StatelessWidget {
  VoidCallback? onPressed;
  final String text;
  double width;
  double height;
  Color color;
  MyButton({Key? key,this.height =50,this.width=100, required this.text, required this.onPressed,this.color = blueClr}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        boxShadow: const [
          BoxShadow(color: Colors.blue,blurRadius: 3,),
        ],
        borderRadius: BorderRadius.circular(30),
      ),
      child: MaterialButton(
        padding: EdgeInsets.all(15),
        splashColor: blueClr.withOpacity(0.5),
        elevation: 0.5,
        shape: const StadiumBorder(),
        onPressed: onPressed,
        child: Text(
          text,
          style: Themes.buttonStyle,
        ),
      ),
    );
  }
}
class MyIconButton extends StatelessWidget {
  VoidCallback? onPressed;
  final IconData icon;
  double iconSize;
  double width;
  double height;
  Color color;
  Color splashColor;
  MyIconButton({Key? key,this.splashColor=Colors.transparent,this.color=Colors.white,this.height =30,this.width=30,this.iconSize=18, required this.icon, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      child: IconButton(
        splashColor: splashColor,
        highlightColor:  Colors.transparent,
        onPressed: onPressed,
        icon: Icon(
            icon,
          size:iconSize,
          color: color,
        )
      ),
    );
  }
}
class MyTextButton extends StatelessWidget {
  Color color;
  String text;
  double textSize;
  VoidCallback? onPressed;
  TextAlign txtAlign;
   MyTextButton({Key? key,this.textSize=12,this.color=Colors.grey,required this.text, required this.onPressed,this.txtAlign = TextAlign.left }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right:20),
        child: TextButton(onPressed: onPressed,child: Text(text,style: TextStyle(color: color,fontWeight: FontWeight.bold,letterSpacing: 0.2,fontSize: textSize,),textAlign: txtAlign,),));
  }
}


