import 'package:bookingme/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../theme.dart';
import 'button.dart';

class InputField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final String labelText;
  final IconData icon;
  bool obscure;
  Color iconColor;
  bool hidePassword;
  FormFieldValidator<String>? onValidator;
  FormFieldSetter<String>? onSaved;
  TextEditingController? controller;
  VoidCallback? toggleEyePassword;
  TextInputType keyboardType;
  bool isDense;
  bool withBorder;
  int maxlines;
  var intialValue;
  TextInputAction textInputAction;
  InputField(
      {Key? key,
      this.onSaved,
        this.isDense=false,
        this.intialValue,
      this.toggleEyePassword,
      this.hidePassword = true,
      this.keyboardType = TextInputType.text,
      this.onValidator,
      this.obscure = false,
      required this.icon,
       this.controller,
      required this.labelText,
      this.hintText = "Input",
        this.withBorder=true,
        this.maxlines=1,
        this.iconColor=blueClr,
        this.textInputAction=TextInputAction.next,
      required this.onChanged})
      : super(key: key);
  String hintText;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 20),
      width: size.width * 0.75,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: const Border(top: BorderSide.none),
        color: Colors.white,
      ),
      child: TextFormField(
        initialValue: intialValue,
        inputFormatters: [
          if(labelText=='Mobile Number')
            LengthLimitingTextInputFormatter(10)
        ],
        maxLines: maxlines,
        controller: controller,
        textInputAction: textInputAction,
        obscureText: obscure ? hidePassword : false,
        cursorColor: blueClr,
        onChanged: onChanged,
        onSaved: onSaved,
        validator: onValidator,
        minLines: 1,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(5),
          isDense: isDense,
            border: withBorder?OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius:withBorder? BorderRadius.circular(15):BorderRadius.zero,
            ):null,
            labelText: labelText,
            labelStyle: Themes.inputStyle,
            hintText: hintText,
            hintStyle:Themes.inputStyle ,
            suffixIcon: obscure
                ? MyIconButton(
                    icon: hidePassword
                        ? FontAwesomeIcons.eyeSlash
                        : FontAwesomeIcons.eye,
                    color: blueClr,
                    onPressed: () => toggleEyePassword!(),
                  )
                : null,
            prefixIcon: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            focusedBorder:OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: blueClr)),
            floatingLabelStyle: Themes.inputStyle.copyWith(
              fontSize: 18,
            )),
        keyboardType: keyboardType,
      ),
    );
  }
}
class InputFieldRead extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final String labelText;
  final IconData icon;
  bool obscure;
  Color iconColor;
  bool hidePassword;
  FormFieldValidator<String>? onValidator;
  FormFieldSetter<String>? onSaved;
  TextEditingController? controller;
  VoidCallback? toggleEyePassword;
  TextInputType keyboardType;
  bool isDense;
  bool withBorder;
  int maxlines;
  var intialValue;
  bool readOnly;
  TextInputAction textInputAction;
  InputFieldRead(
      {Key? key,
        this.readOnly=false,
        this.onSaved,
        this.isDense=false,
        this.intialValue,
        this.toggleEyePassword,
        this.hidePassword = true,
        this.keyboardType = TextInputType.text,
        this.onValidator,
        this.obscure = false,
        required this.icon,
        this.controller,
        required this.labelText,
        this.hintText = "Input",
        this.withBorder=true,
        this.maxlines=1,
        this.iconColor=blueClr,
        this.textInputAction=TextInputAction.next,
        required this.onChanged})
      : super(key: key);
  String hintText;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 20),
      width: size.width * 0.75,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: const Border(top: BorderSide.none),
        color: Colors.white,
      ),
      child: TextFormField(
        initialValue: intialValue,
        readOnly: readOnly,
        enabled: readOnly,
        inputFormatters: [
          if(TextInputType.phone==keyboardType)LengthLimitingTextInputFormatter(10)
        ],
        maxLines: maxlines,
        controller: controller,
        textInputAction: textInputAction,
        obscureText: obscure ? hidePassword : false,
        cursorColor: blueClr,
        onChanged: onChanged,
        onSaved: onSaved,
        validator: onValidator,
        minLines: 1,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(5),
            enabled: readOnly,
            filled: readOnly,
            isDense: isDense,
            border: withBorder?OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius:withBorder? BorderRadius.circular(15):BorderRadius.zero,
            ):null,
            labelText: labelText,
            labelStyle: Themes.inputStyle,
            hintText: hintText,
            hintStyle:Themes.inputStyle ,
            suffixIcon: obscure
                ? MyIconButton(
              icon: hidePassword
                  ? FontAwesomeIcons.eyeSlash
                  : FontAwesomeIcons.eye,
              color: blueClr,
              onPressed: () => toggleEyePassword!(),
            )
                : null,
            prefixIcon: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
            floatingLabelBehavior: readOnly?FloatingLabelBehavior.always :FloatingLabelBehavior.auto,
            focusedBorder:readOnly? null:OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: blueClr)),
            floatingLabelStyle: Themes.inputStyle.copyWith(
              fontSize: 18,
            )),
        keyboardType: keyboardType,
      ),
    );
  }
}
