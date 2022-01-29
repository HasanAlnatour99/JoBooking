import 'package:bookingme/models/hall.dart';
import 'package:bookingme/services/firestore_hall.dart';
import 'package:bookingme/services/firestore_user.dart';
import 'package:bookingme/services/utilits.dart';
import 'package:bookingme/ui/pages/my_halls.dart';
import 'package:bookingme/ui/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class HallController extends GetxController {
  var uuid = Uuid();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<XFile> images =[];
  List<XFile> selectedImage=[];
  bool edited = false;
  var dropdownValue ='Amman';
  var dropdownType = 'Bowling';
  bool showPlace=false;
  int groupValue=1;
  bool isPerHour = true;
  bool isPerDay = true;
  bool isPerWeek = true;
  List<String> hallImageUploaded=[];
  TextEditingController titleController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController conditionController = TextEditingController();
  TextEditingController priceHourController = TextEditingController(text: '0');
  TextEditingController priceDayController = TextEditingController(text: '0');
  TextEditingController priceWeekController = TextEditingController(text: '0');
  var currentIndex = 0.obs;
  var index = 0.obs;
  String promoImg='';
  bool switchPromos = false;
  @override
  onInit() {
    super.onInit();
    phoneController = TextEditingController();
    areaController = TextEditingController();
    conditionController = TextEditingController();
    titleController=TextEditingController();
    descController=TextEditingController();
    priceHourController = TextEditingController();
    priceDayController = TextEditingController();
    priceWeekController = TextEditingController();
  }

  @override
  void onReady() {
    super.onReady();
  }
  Future<void> _showMyDialog(context,hallID) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Hall'),
          content: SingleChildScrollView(
            child: Text("Are you sure you want to delete this room",style: Themes.mTitleStyle,),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel',style: TextStyle(color:Colors.green),),
              onPressed: ()  {
                Navigator.of(context).pop();

              },
            ),
            TextButton(
              child: Text('Delete',style: TextStyle(color:Colors.red),),
              onPressed: () async {
                Navigator.of(context).pop();
                Get.back();
                await FirebaseFirestore.instance.collection("halls").doc(hallID).delete();
               var order=  await FirebaseFirestore.instance.collection("orders").where('hall_id',isEqualTo: hallID).get();
               order.docs.forEach((element) {
                 element.reference.delete();
               });
                var fav=  await FirebaseFirestore.instance.collection("favorites").where('hallID',isEqualTo: hallID).get();
                fav.docs.forEach((element) {
                  element.reference.delete();
                });
                GFToast.showToast(
                    'The hall has been deleted..',
                    context,
                    toastPosition: GFToastPosition.BOTTOM,
                    textStyle: const TextStyle(fontSize: 16, color: GFColors.LIGHT),
                    backgroundColor: GFColors.DARK,
                    trailing: const Icon(
                      FontAwesomeIcons.exclamation,
                      color: GFColors.WARNING,
                    ));
              },
            ),

          ],
        );
      },
    );
  }
  removeHall(hallID,context) async {
    _showMyDialog(context,hallID);

  }
  switchPromosFn(val,hallID,promoImageDB,context) async {
    if(promoImg=='' && promoImageDB==''){
      GFToast.showToast(
          'You must enter an image first.',
          context,
          toastPosition: GFToastPosition.BOTTOM,
          textStyle: const TextStyle(fontSize: 16, color: GFColors.LIGHT),
          backgroundColor: GFColors.DARK,
          trailing: const Icon(
            FontAwesomeIcons.exclamation,
            color: GFColors.WARNING,
          ));
    }else{
      switchPromos = val;
      update();
      await FirebaseFirestore.instance.collection("halls").doc(hallID).update({
        'promotion':val,
      });
    }

  }

 editToggle(){
   edited = !edited;
   update();
 }
  bool onChange(v){
    currentIndex = v;
    return false;
  }

  postStoreImages() async {
    hallImageUploaded = await FirestoreHall().uploadMultiImages(images);
  }
  PromotionImage(hallID,context) async{
    promoImg = await  imagePickerPromos(context);
    update();
    await FirebaseFirestore.instance.collection("halls").doc(hallID).update({
      'promotionImage':promoImg,
    });
  }
  updateHall(context,{name,area,description,conditions,pricePerDay,pricePerHour,phone,hallID})  async {
    if(phone.isNotEmpty  && name.isNotEmpty  && description.isNotEmpty  &&( conditions!=''?conditions.isNotEmpty :true)
        && area.isNotEmpty  && (pricePerHour.isNotEmpty  || pricePerDay.isNotEmpty   ) )
    {
      Get.back();
      await FirebaseFirestore.instance.collection("halls").doc(hallID).update({
        'name': name,
        'type':dropdownType ,
        'address': area + ", " + dropdownValue,
        'description': description,
        'conditions': conditions != '' ? conditions : "No Conditions",
        'price': {
          'pricePerHour': pricePerHour,
          'pricePerDay': pricePerDay,
          'pricePerWeek': '',
        },
        'phone': phone,
      });
      await FireStoreUser().getUserInfo();
      editToggle();

    }else{
      GFToast.showToast(
          'Please make sure to fill in all fields.',
          context,
          toastPosition: GFToastPosition.BOTTOM,
          textStyle: const TextStyle(fontSize: 16, color: GFColors.LIGHT),
          backgroundColor: GFColors.DARK,
          trailing: const Icon(
            FontAwesomeIcons.exclamation,
            color: GFColors.WARNING,
          ));
    }
  }
   postHall(context)  async {
      if(phoneController.text.removeAllWhitespace.isNotEmpty  && titleController.text.removeAllWhitespace.isNotEmpty  && descController.text.removeAllWhitespace.isNotEmpty  &&( groupValue==1?conditionController.text.removeAllWhitespace.isNotEmpty :true)
          && areaController.text.removeAllWhitespace.isNotEmpty  && images.isNotEmpty && (priceHourController.text.removeAllWhitespace.isNotEmpty  || priceDayController.text.removeAllWhitespace.isNotEmpty  || priceWeekController.text.removeAllWhitespace.isNotEmpty ) )
      {
        print("Sirst:");

        Get.off(()=>MyHalls());
        await postStoreImages();
        await FirestoreHall().addHallToFirestore(HallModel(
          name: titleController.text,
          type:dropdownType ,
          address: areaController.text + ", " + dropdownValue,
          description: descController.text,
          conditions: groupValue == 1 ? conditionController.text : "No",
          hallID: '${_auth.currentUser!.uid.hashCode}' '${uuid.v1()}',
          images: [...hallImageUploaded],
          ownID: _auth.currentUser!.uid,
          price: {
            'pricePerHour': priceHourController.text,
            'pricePerDay': priceDayController.text,
            'pricePerWeek': priceWeekController.text,
          },
          rated: '0.0',
          promotion:false,
          promotionImage:'',
          visitors: 0,
          phone: phoneController.text,
        ));
        await FireStoreUser().getUserInfo();

      }else{
        GFToast.showToast(
            'Please make sure to fill in all fields.',
            context,
            toastPosition: GFToastPosition.BOTTOM,
            textStyle: const TextStyle(fontSize: 16, color: GFColors.LIGHT),
            backgroundColor: GFColors.DARK,
            trailing: const Icon(
              FontAwesomeIcons.exclamation,
              color: GFColors.WARNING,
            ));
      }
    }
  // for conditions
  radioButton(value){
    groupValue = value;
    update();
  }
  showPlaceF(){
    showPlace=true;
    update();
  }
   pickMultiImages() async {
      selectedImage =await  multiImagePicker();
      images.addAll(selectedImage);
      update();
  }
  removePhoto(index){
    images.removeAt(index);
    update();
  }
  checkerBox(value,type){
     type==1?
   isPerHour = value:type==2?isPerDay = value:isPerWeek = value;
   update();
  }
  addressDropDown(v){
    dropdownValue = v;
    update();
  }
  typeDropDown(v){
    dropdownType = v;
    update();
  }


}