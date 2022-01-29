import 'package:bookingme/controllers/homescreen_controller.dart';
import 'package:bookingme/models/hall.dart';
import 'package:bookingme/services/firestore_user.dart';
import 'package:bookingme/ui/widgets/bottom_navigation.dart';
import 'package:bookingme/ui/widgets/button.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import '../theme.dart';

class HallBookingPage extends StatelessWidget {
  HallBookingPage({Key? key, required this.hallModel}) : super(key: key);
  final HallModel hallModel;
  HomeScreenController controller = Get.put(HomeScreenController());
  final ref = FirebaseFirestore.instance.collection('favorites');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var dateBooked = DateTime.now().toString().split(' ')[0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "DETAIL",
          style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.normal,
              color: Colors.black),
        ),
        leading: MyIconButton(
          onPressed: () {
            Get.back();
            controller.isLike.value = false;
            controller.indexDetailsImages.value = 0;
          },
          icon: Icons.arrow_back,
          iconSize: 25,
          color: Colors.black,
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              controller.groupValue = hallModel.price!['pricePerHour'] != ''? 0: 1;
              return SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(0.0),
                  child: GetBuilder(
                    init: HomeScreenController(),
                    builder: (_) => Column(
                      children: [
                        GFCard(
                          margin:const EdgeInsets.all(0),
                          content: Container(
                            height: 45,
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text("Let\'s Booking!", style: Themes.mTitleStyle),
                                const SizedBox(width:10),
                                CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  radius: 16,
                                  child: Image.asset(
                                    'assets/letsbooking.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GFCard(
                          margin: const EdgeInsets.all(0),
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Container(
                                  alignment: Alignment.topLeft,
                                  child: Text("Booking",
                                      style: Themes.mTitleStyle)),
                              Row(
                                children: [
                                  GFRadio(
                                    type: GFRadioType.custom,
                                    size: 20,
                                    value: 0,
                                    groupValue: controller.groupValue,
                                    onChanged: hallModel.price!['pricePerHour'] != ''? (value)=>controller.radioButton(value): (value)=>GFToast.showToast(
                                        'Sorry, This option is not available from the owner.',
                                        context,
                                        toastPosition: GFToastPosition.BOTTOM,
                                        textStyle: const TextStyle(fontSize: 16, color: GFColors.LIGHT),
                                        backgroundColor: GFColors.DARK,
                                        toastDuration:4,
                                        trailing: const Icon(
                                          FontAwesomeIcons.exclamation,
                                          color: GFColors.WARNING,
                                          size:18,
                                        )),
                                    inactiveIcon: null,
                                    activeIcon: const Icon(
                                        FontAwesomeIcons.check,
                                        color: GFColors.SUCCESS,
                                        size: 14),
                                    activeBorderColor: GFColors.SUCCESS,
                                    customBgColor: GFColors.SUCCESS,
                                  ),
                                  Text("  by hour",
                                      style: Themes.mServiceTitleStyle
                                          .copyWith(fontSize: 16)),
                                ],
                              ),
                              Row(
                                children: [
                                  GFRadio(
                                    type: GFRadioType.custom,
                                    size: 20,
                                    value: 1,
                                    groupValue: controller.groupValue,
                                    onChanged:hallModel.price!['pricePerDay'] != ''? (value)=>controller.radioButton(value): (value)=>GFToast.showToast(
                                        'Sorry, This option is not available from the owner.',
                                        context,
                                        toastPosition: GFToastPosition.BOTTOM,
                                        textStyle: const TextStyle(fontSize: 16, color: GFColors.LIGHT),
                                        backgroundColor: GFColors.DARK,
                                        toastDuration: 4,
                                        trailing: const Icon(
                                          FontAwesomeIcons.exclamation,
                                          color: GFColors.WARNING,
                                          size:18,
                                        )),
                                    inactiveIcon: null,
                                    activeBorderColor: GFColors.SUCCESS,
                                    customBgColor: GFColors.SUCCESS,
                                    activeIcon: const Icon(
                                        FontAwesomeIcons.check,
                                        color: GFColors.SUCCESS,
                                        size: 14),
                                  ),
                                  Text("  by day",
                                      style: Themes.mServiceTitleStyle
                                          .copyWith(fontSize: 16)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        GFCard(
                          margin: const EdgeInsets.all(0),
                          content:  CalendarTimeline(
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2022, 12, 31),
                              onDateSelected: (date) {
                                dateBooked = date.toString().split(' ')[0];
                                print(dateBooked);
                              },
                              leftMargin: 20,
                              monthColor: Colors.blueGrey,
                              dayColor: Colors.teal[200],
                              activeDayColor: Colors.white,
                              activeBackgroundDayColor: Colors.green[100],
                              dotsColor: const Color(0xFF333A47),
                              selectableDayPredicate: (date) => date.day != 23,
                              locale: 'en_ISO',
                          ),
                        ),
                        controller.groupValue == 0
                            ? GFCard(
                                margin: const EdgeInsets.all(0),
                                padding: const EdgeInsets.symmetric(horizontal:22,vertical: 8),
                                content: Column(
                                  children: [
                                   Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children:  [
                                          Expanded(child:  Text("Start Time",style: Themes.mTitleStyle,)),
                                          const SizedBox(height:10,),
                                          Expanded(
                                            flex:2,
                                            child: Container(
                                              height: 50,
                                              width: MediaQuery.of(context).size.width * 0.7 ,
                                              margin: EdgeInsets.only(top: 10),
                                              child: DropdownButtonHideUnderline(
                                                child: GFDropdown(
                                                  padding: const EdgeInsets.all(15),
                                                  borderRadius: BorderRadius.circular(10),
                                                  border: const BorderSide(
                                                      color: Colors.black12, width: 1),
                                                  dropdownButtonColor: Colors.white,
                                                  value: controller.dropdownValue,
                                                  onChanged: (newValue) {
                                                    controller.dropDown(newValue);
                                                  },
                                                  items: [
                                                   '8:00 AM','9:00 AM', '10:00 AM', '11:00 AM', '12:00 PM',
                                                    '1:00 PM', '2:00 PM', '3:00 PM', '4:00 PM','5:00 PM',
                                                    '6:00 PM', '7:00 PM', '8:00 PM','9:00 PM',

                                                  ]
                                                      .map((value) => DropdownMenuItem(
                                                    alignment: Alignment.center,
                                                    value: value,
                                                    child: Text(value),
                                                  ))
                                                      .toList(),
                                                ),
                                              ),
                                            ),
                                          ),

                                        ],
                                      ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children:  [
                                        Expanded(child:  Text("For ",style: Themes.mTitleStyle,)),
                                        const SizedBox(height:10,),
                                        Expanded(
                                          flex:2,
                                          child: Container(
                                            height: 50,
                                            width: MediaQuery.of(context).size.width * 0.7 ,
                                            margin: EdgeInsets.only(top: 10),
                                            child: DropdownButtonHideUnderline(
                                              child: GFDropdown(
                                                padding: const EdgeInsets.all(15),
                                                borderRadius: BorderRadius.circular(10),
                                                border: const BorderSide(
                                                    color: Colors.black12, width: 1),
                                                dropdownButtonColor: Colors.white,
                                                value: controller.dropdownEndTime,
                                                onChanged: (newValue) {
                                                  controller.dropDownEndTime(newValue);
                                                },
                                                items: [
                                               'one hour',
                                               'two hours',
                                               'three hours',
                                                  'four hours',

                                                ]
                                                    .map((value) => DropdownMenuItem(
                                                  alignment: Alignment.center,
                                                  value: value,
                                                  child: Text(value),
                                                ))
                                                    .toList(),
                                              ),
                                            ),
                                          ),
                                        ),

                                      ],
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                        GFCard(
                          margin:const EdgeInsets.all(0),
                            content: MyButton(text: 'Book', onPressed: () async {
                              if(_auth.currentUser!.uid != hallModel.ownID){
                               return GFToast.showToast(
                                    'Sorry, You can not book your hall.',
                                    context,
                                    toastPosition: GFToastPosition.BOTTOM,
                                    textStyle: const TextStyle(fontSize: 16, color: GFColors.LIGHT),
                                    backgroundColor: GFColors.DARK,
                                    trailing: const Icon(
                                      FontAwesomeIcons.exclamation,
                                      color: GFColors.WARNING,
                                      size:18,
                                    ));
                              }else{
                                var uuid = Uuid();
                                int startTime = int.parse(controller.dropdownValue.split(':')[0]);
                                bool pmTime =controller.dropdownValue.split(' ')[1] == "PM";
                                int startF= pmTime? (startTime==12?startTime:startTime + 12): startTime;
                                int endTimeFinal =controller.dropdownEndTime == 'one hour'?
                                startF+1:controller.dropdownEndTime == 'two hours'?
                                startF+2:controller.dropdownEndTime == 'three hours'?
                                startF+3:startF+4;
                                print('End Time : $endTimeFinal');
                                final firebase = await FirebaseFirestore.instance.collection("orders").where('hall_id',isEqualTo:hallModel.hallID).get();
                                bool exist = firebase.docs.any((element) {
                                  int oldEndTime = int.parse(element.data()['EndTime'].split(':')[0]);
                                  int oldStartTime = int.parse(element.data()['StartTime'].split(':')[0]);

                                  print(oldStartTime < endTimeFinal );
                                  bool ss = false ;
                                   for(oldStartTime ; oldStartTime<oldEndTime;oldStartTime++){
                                    if(startF==oldStartTime && element.data()['date']==dateBooked ){
                                      ss =  true;
                                    }
                                    if(endTimeFinal==oldStartTime+1 && element.data()['date']==dateBooked ){
                                      ss=true;
                                    }
                                  }
                                  // bool ss = oldStartTime <= startF && startF < oldEndTime && element.data()['date']==dateBooked && (oldStartTime <= endTimeFinal && oldEndTime >= endTimeFinal ) ;
                                  return element.data()['type']=='hour'?
                                  ss  :
                                  element.data()['date']==dateBooked;
                                });
                                if(exist){
                                  GFToast.showToast(
                                      'Sorry, this time is not available, please choose another time.',
                                      context,
                                      toastPosition: GFToastPosition.BOTTOM,
                                      toastDuration: 6,
                                      textStyle: const TextStyle(fontSize: 16, color: GFColors.LIGHT),
                                      backgroundColor: GFColors.DARK,
                                      trailing: const Icon(
                                        FontAwesomeIcons.exclamation,
                                        color: GFColors.WARNING,
                                        size:18,
                                      ));
                                }else {
                                  final orderID = _auth.currentUser!.uid + hallModel.hallID!+uuid.v1();
                                  await FirebaseFirestore.instance.collection("orders").doc(orderID).set({
                                    'StartTime':'$startF:00',
                                    'orderID':orderID,
                                    'EndTime': controller.dropdownEndTime == 'one hour'?
                                    '${startF+1}:00':controller.dropdownEndTime == 'two hours'?
                                    '${startF+2}:00':controller.dropdownEndTime == 'three hours'?
                                    '${startF+3}:00':'${startF+4}:00',
                                    'date':dateBooked,
                                    'hall_id':hallModel.hallID!,
                                    'ownID':hallModel.ownID!,
                                    'approve':false,
                                    'price':controller.groupValue==0?
                                    (controller.dropdownEndTime == 'one hour'?
                                    int.parse(hallModel.price!['pricePerHour']) * 1:controller.dropdownEndTime == 'two hours'?
                                    int.parse(hallModel.price!['pricePerHour']) * 2:controller.dropdownEndTime == 'three hours'?
                                    int.parse(hallModel.price!['pricePerHour']) * 3:int.parse(hallModel.price!['pricePerHour']) * 4)
                                        :hallModel.price!['pricePerDay'],
                                    'visitorID':_auth.currentUser!.uid,
                                    'isFinish':false,
                                    'type':controller.groupValue==0?'hour':'day',
                                    'rate':0,
                                    'review':[],
                                  });
                                  // await FirebaseFirestore.instance.collection("halls").where('requests',isEqualTo: _auth.currentUser!.uid+hallModel.hallID!+uuid.v1());
                                  print("DONE");
                                  Get.offAll(()=>BottomNavigation(index:1)) ;
                                  GFToast.showToast(
                                      'Booked successfully,Have Fun.',
                                      context,
                                      toastPosition: GFToastPosition.BOTTOM,
                                      toastDuration: 6,
                                      textStyle: const TextStyle(fontSize: 13, color: GFColors.LIGHT),
                                      backgroundColor: GFColors.DARK,
                                      trailing: const Icon(
                                        FontAwesomeIcons.exclamation,
                                        color: GFColors.WARNING,
                                        size:16,
                                      ));
                                  await FireStoreUser().getUserInfo();


                                }
                              }

                            },
                                color: orangeClr,width: 140,height:50)),
                        const SizedBox(height:15),
                      ],
                    ),
                  ),
                ),
              );
            }),
        isExtended: true,
        backgroundColor: orangeClr,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        icon: const Icon(
          FontAwesomeIcons.plus,
          size: 18,
        ),
        label: const Text('Appointment Booking'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              // padding: const EdgeInsets.only(top: 16.0, bottom: 20.0),
              child: GFCard(
                margin: const EdgeInsets.only(top: 60),
                padding: const EdgeInsets.all(0),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 250),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        hallModel.name!,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 28.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        const SizedBox(width: 16.0),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 7),
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 16.0,
                          ),
                          decoration: BoxDecoration(
                              color: orangeClr,
                              borderRadius: BorderRadius.circular(20.0)),
                          child: Text(
                            "${hallModel.visitors} Visited",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 13.0),
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    RatingBarIndicator(
                                      rating: double.parse(hallModel.rated!),
                                      itemBuilder: (context, index) =>
                                          const Icon(
                                        Icons.star,
                                        color: orangeClr,
                                      ),
                                      itemCount: 5,
                                      itemSize: 22.0,
                                      direction: Axis.horizontal,
                                    ),
                                    const SizedBox(height: 5),
                                    Text.rich(
                                      TextSpan(children: [
                                        const WidgetSpan(
                                            child: Icon(
                                          Icons.location_on,
                                          size: 16.0,
                                          color: Colors.grey,
                                        )),
                                        TextSpan(text: hallModel.address)
                                      ]),
                                      style: const TextStyle(
                                          color: Colors.grey, fontSize: 12.0),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                  height: 38,
                                  width: 38,
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle),
                                  child: IconButton(
                                      onPressed: () =>
                                          launch('tel:${hallModel.phone}'),
                                      icon: const Icon(
                                        FontAwesomeIcons.phone,
                                        color: Colors.white,
                                        size: 20,
                                      ))),
                            ],
                          ),
                          const SizedBox(height: 30.0),
                          hallModel.price!['pricePerHour'] != '' &&
                                  hallModel.price!['pricePerDay'] == '' &&
                                  hallModel.price!['pricePerWeek'] == ''
                              ? priceOne('pricePerHour')
                              : hallModel.price!['pricePerHour'] == '' &&
                                      hallModel.price!['pricePerDay'] != '' &&
                                      hallModel.price!['pricePerWeek'] == ''
                                  ? priceOne('pricePerDay')
                                  : hallModel.price!['pricePerHour'] == '' &&
                                          hallModel.price!['pricePerDay'] !=
                                              '' &&
                                          hallModel.price!['pricePerWeek'] == ''
                                      ? priceOne('pricePerWeek')
                                      : price(),
                          const SizedBox(height: 10.0),
                          GFCard(
                            title: GFListTile(
                              margin: const EdgeInsets.all(0),
                              padding: const EdgeInsets.all(0),
                              title: Text(
                                "Description".toUpperCase(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.0),
                              ),
                            ),
                            margin: const EdgeInsets.all(3),
                            content: GetBuilder(
                              init: HomeScreenController(),
                              builder: (_) => Column(
                                children: [
                                  buildText(hallModel.description!.trimLeft()),
                                  hallModel.description!.length >= 160
                                      ? TextButton(
                                          child: GetBuilder(
                                              init: HomeScreenController(),
                                              builder: (_) => Text(
                                                  controller.isReadmore
                                                      ? 'Read Less'
                                                      : 'Read More')),
                                          onPressed: () => controller.read(),
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                          ),
                          hallModel.conditions != "No"
                              ? GFCard(
                                  title: GFListTile(
                                    margin: const EdgeInsets.all(0),
                                    padding: const EdgeInsets.all(0),
                                    title: Text(
                                      "Conditions".toUpperCase(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14.0),
                                    ),
                                  ),
                                  margin: const EdgeInsets.all(3),
                                  content: GetBuilder(
                                    init: HomeScreenController(),
                                    builder: (_) => Column(
                                      children: [
                                        buildText(
                                            hallModel.conditions!.trimLeft()),
                                        hallModel.conditions!.length >= 160
                                            ? TextButton(
                                                child: GetBuilder(
                                                    init:
                                                        HomeScreenController(),
                                                    builder: (_) => Text(
                                                        controller.isReadmore
                                                            ? 'Read Less'
                                                            : 'Read More')),
                                                onPressed: () =>
                                                    controller.read(),
                                              )
                                            : Container(),
                                      ],
                                    ),
                                  ),
                                )
                              : Container(),
                          const SizedBox(height: 45),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                Container(
                  color: Colors.white,
                  margin: const EdgeInsets.all(0),
                  padding: const EdgeInsets.all(0),
                  // foregroundDecoration: const BoxDecoration(color: Colors.black12,),
                  height: 250,
                  child: CarouselSlider(
                    options: CarouselOptions(
                      viewportFraction: 1.0,
                      // autoPlay: true,
                      // pauseAutoPlayOnTouch: true,
                      // pageSnapping: true,
                      enableInfiniteScroll: false,
                      //
                      // enlargeCenterPage: true,
                      onPageChanged: (index, reason) {
                        print(reason);
                        controller.slider(index);
                      },
                    ),
                    items: hallModel.images!
                        .map(
                          (item) => InkWell(
                            onTap: () => Get.to(() => LargePhoto(
                                  image: item,
                                )),
                            child: Image.network(
                              item,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                GFCard(
                  color: Colors.white,
                  margin: const EdgeInsets.all(0),
                  padding: const EdgeInsets.all(0),
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 40),
                      Expanded(
                        flex: 13,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: hallModel.images!.map((urlOfItem) {
                              int index = hallModel.images!.indexOf(urlOfItem);
                              return Obx(
                                () => Container(
                                  width: 6.0,
                                  height: 6.0,
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 2.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                        controller.indexDetailsImages.value ==
                                                index
                                            ? orangeClr
                                            : mGreyColor,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: StreamBuilder<QuerySnapshot>(
                            stream: ref
                                .where(
                                  'hallID',
                                  isEqualTo: hallModel.hallID,
                                )
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return const Icon(
                                  Icons.favorite_border,
                                  color: Colors.white,
                                );
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Icon(
                                  Icons.favorite_border,
                                  color: Colors.white,
                                );
                              }
                              if (snapshot.connectionState ==
                                      ConnectionState.active ||
                                  snapshot.connectionState ==
                                      ConnectionState.done) {
                                snapshot.data!.docs.any(
                                    (QueryDocumentSnapshot<dynamic> element) {
                                  bool exist = element.data()['likerID'] ==
                                      _auth.currentUser!.uid;
                                  if (exist) {
                                    controller.isLike.value =
                                        element.data()['favorite'];
                                  } else {
                                    controller.isLike.value = false;
                                  }
                                  print(controller.isLike.value);
                                  return controller.isLike.value;
                                });
                              }

                              return IconButton(
                                color: Colors.white,
                                icon: Obx(() => Icon(
                                      controller.isLike.value
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: controller.isLike.value
                                          ? Colors.red
                                          : Colors.black,
                                    )),
                                onPressed: () {
                                  controller.favorite(hallModel.hallID);
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                    ],
                  ),
                ),
              ],
            ),

            // Positioned(
            //   top: 0,
            //   left: 0,
            //   right: 0,
            //   child: AppBar(
            //     backgroundColor: Colors.transparent,
            //     elevation: 0,
            //     centerTitle: true,
            //     title: const Text(
            //       "DETAIL",
            //       style:
            //           TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
            //     ),
            //     leading: MyIconButton(
            //       onPressed: () {
            //         Get.back();
            //         controller.isLike.value = false;
            //       },
            //       icon: Icons.arrow_back,
            //       iconSize: 25,
            //       color: Colors.white,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget buildText(String text) {
    // if read more is false then show only 3 lines from text
    // else show full text
    final lines = controller.isReadmore ? null : 3;
    return GetBuilder(
      init: HomeScreenController(),
      builder: (_) => Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w300,
          fontSize: 14.0,
        ),
        textAlign: TextAlign.justify,
        maxLines: lines,
        // overflow properties is used to show 3 dot in text widget
        // so that user can understand there are few more line to read.
        overflow: controller.isReadmore
            ? TextOverflow.visible
            : TextOverflow.ellipsis,
      ),
    );
  }

  GFCard priceOne(type) {
    return GFCard(
      margin: const EdgeInsets.all(3),
      content: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              "${hallModel.price!['$type']} JD",
              style: const TextStyle(
                color: orangeClr,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ),
          Expanded(
            child: Text(
              type == 'pricePerHour'
                  ? '/per hour'
                  : type == 'pricePerDay'
                      ? '/per day'
                      : '/per week',
              style: const TextStyle(fontSize: 12.0, color: Colors.grey),
            ),
          )
        ],
      ),
    );
  }

  Row price() {
    return Row(
      children: [
        hallModel.price!['pricePerHour'] != ''
            ? Expanded(
                child: GFCard(
                  margin: const EdgeInsets.all(3),
                  content: Column(
                    children: <Widget>[
                      Text(
                        " ${hallModel.price!['pricePerHour']} JD",
                        style: const TextStyle(
                            color: orangeClr,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      ),
                      const Text(
                        "/per hour",
                        style: TextStyle(fontSize: 12.0, color: Colors.grey),
                      )
                    ],
                  ),
                ),
              )
            : Container(),
        hallModel.price!['pricePerDay'] != ''
            ? Expanded(
                child: GFCard(
                  margin: const EdgeInsets.all(3),
                  content: Column(
                    children: <Widget>[
                      Text(
                        " ${hallModel.price!['pricePerDay']} JD",
                        style: const TextStyle(
                            color: orangeClr,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      ),
                      const Text(
                        "/per day",
                        style: TextStyle(fontSize: 12.0, color: Colors.grey),
                      )
                    ],
                  ),
                ),
              )
            : Container(),
        hallModel.price!['pricePerWeek'] != ''
            ? Expanded(
                child: GFCard(
                  margin: const EdgeInsets.all(3),
                  content: Column(
                    children: <Widget>[
                      Text(
                        " ${hallModel.price!['pricePerWeek']} JD",
                        style: const TextStyle(
                            color: orangeClr,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0),
                      ),
                      const Text(
                        "/per week",
                        style: TextStyle(fontSize: 12.0, color: Colors.grey),
                      )
                    ],
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}

class LargePhoto extends StatefulWidget {
  LargePhoto({Key? key, required this.image}) : super(key: key);
  final image;

  @override
  State<LargePhoto> createState() => _LargePhotoState();
}

class _LargePhotoState extends State<LargePhoto> {
  TransformationController controller = TransformationController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "",
          style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.normal,
              color: Colors.white),
        ),
        leading: MyIconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icons.clear,
          iconSize: 25,
          color: Colors.white,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: InteractiveViewer(
            minScale: 1,
            maxScale: 4,
            clipBehavior: Clip.none,
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: NetworkImage(
                    widget.image,
                  ),
                  fit: BoxFit.cover,
                )),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
