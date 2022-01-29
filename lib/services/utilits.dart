
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/getwidget.dart';
import 'package:image_picker/image_picker.dart';

import 'firestore_user.dart';
MaterialColor buildMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}

 Future<String> imagePicker() async {
  final ImagePicker _picker = ImagePicker();
  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
   File _imageFile = File(image!.path);
   String url = await FireStoreUser().uploadFile(_imageFile);
   print("URL:$url");
   return url;
}
Future<String> imagePickerPromos(context) async {
  final ImagePicker _picker = ImagePicker();
  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  File _imageFile = File(image!.path);
  GFToast.showToast(
      'Please wait for the image to load.',
      context,
      toastPosition: GFToastPosition.BOTTOM,
      textStyle: const TextStyle(fontSize: 16, color: GFColors.LIGHT),
      backgroundColor: GFColors.DARK,
      trailing: const Icon(
        FontAwesomeIcons.exclamation,
        color: GFColors.WARNING,
      ));
  String url = await FireStoreUser().uploadFilePromos(_imageFile);
  print("URL:$url");
  return url;
}
  Future<List<XFile>> multiImagePicker() async {
  final ImagePicker _picker = ImagePicker();
  List<XFile>? imageFileList = [];
  final List<XFile>? selectedImages = await _picker.pickMultiImage();
  if (selectedImages!.isNotEmpty) {
    imageFileList.addAll(selectedImages);
  }
  return imageFileList;
  print("Image List Length:" + imageFileList.length.toString());
  // String url = await FireStoreUser().uploadFile(_imageFile);
  // print("URL:$url");
  // return url;
}