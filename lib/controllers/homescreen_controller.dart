import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class HomeScreenController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var currentIndex = 0.obs;
  int groupValue=1;
  var index = 0.obs;
  bool isReadmore = false;
  List carousels = [];
  var  dropdownValue ='12:00 PM';
  var dropdownEndTime = 'one hour';
  var isLike = false.obs;
  var indexDetailsImages = 0.obs;
  List<String> favorites = [];

  @override
  onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  dropDown(v){
    dropdownValue = v;
    update();
  }
  dropDownEndTime(v){

    dropdownEndTime = v;
    update();
  }
  radioButton(value){
    groupValue = value;
    update();
  }
  slider(index){
    indexDetailsImages.value=index;
  }
  read() {
    isReadmore = !isReadmore;
    update();
  }

  final ref = FirebaseFirestore.instance.collection('favorites');

  // checkFavorite(hallId) async {
  //   await ref
  //       .where(
  //         'hallID',
  //         isEqualTo: hallId,
  //       ).get().then((event) {
  //     event.docs.any((element) {
  //       bool exist = element.data()['likerID'] == _auth.currentUser!.uid;
  //       if (exist) {
  //         like = element.data()['favorite'];
  //         update();
  //       } else {
  //         like = false;
  //         update();
  //       }
  //       return like;
  //     });
  //
  //   });
  // }

  favorite(hallId) async {
    isLike.value = !isLike.value;

    if (isLike.value == true) {
      await ref.doc(hallId+_auth.currentUser!.uid).set({
        'likerID': _auth.currentUser!.uid,
        'hallID': hallId,
        'favorite': isLike.value,
      });
    }else{
     ref.doc(hallId+_auth.currentUser!.uid).delete();

     // .then((value) {
     //   for (var element in value.docs) {
     //    if( element.data()['likerID'] == _auth.currentUser!.uid){
     //      element.data()['favorite'];
     //    }
     //   }
     // });

    }

    // await f.data()['favorites'].add(_auth.currentUser!.uid);
  }

  // ["favorites"].add(_auth.currentUser!.uid)
  setLengthCarousel(List a) {
    carousels.clear();
    carousels.add(a);
    update();
  }

  onChange(x) {
    currentIndex.value = x;
  }
}
