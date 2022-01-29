import 'package:bookingme/controllers/homescreen_controller.dart';
import 'package:bookingme/models/hall.dart';
import 'package:bookingme/ui/widgets/bottom_navigation.dart';
import 'package:bookingme/ui/widgets/button.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_beautiful_popup/main.dart';
import '../theme.dart';
import 'hall_booking.dart';

class HallBookingSection extends StatefulWidget {
  HallBookingSection({Key? key}) : super(key: key);

  @override
  State<HallBookingSection> createState() => _HallBookingSectionState();
}

class _HallBookingSectionState extends State<HallBookingSection> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  HomeScreenController controller = Get.put(HomeScreenController());

  final ref = FirebaseFirestore.instance.collection('favorites');

  var dateBooked = DateTime.now().toString().split(' ')[0];

  @override
  Widget build(BuildContext context) {
    final popup = BeautifulPopup(
      context: context,
      template: TemplateTerm,
    );
    return SafeArea(
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("orders")
              .where('visitorID', isEqualTo: _auth.currentUser!.uid)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }
            final data = snapshot.data!.docs;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (
                context,
                index,
              ) =>
                  Container(
                child: GFCard(
                  elevation: 4,
                  margin: const EdgeInsets.all(3),
                  content: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("halls")
                          .where('hallID', isEqualTo: data[index]['hall_id'])
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Something went wrong');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text("Loading");
                        }
                        final Map<String, dynamic> hallData =
                            snapshot.data!.docs.first.data()!
                                as Map<String, dynamic>;
                        final HallModel hall = HallModel.fromJson(hallData);
                        var startTime='';
                        if(int.parse(data[index]['StartTime'].split(':')[0])>12){
                          startTime = "${int.parse(data[index]['StartTime'].split(':')[0]) -12 }:00 PM";
                        }else if(int.parse(data[index]['StartTime'].split(':')[0])==12){
                           startTime = "${int.parse(data[index]['StartTime'].split(':')[0]) }:00 PM";
                        }else{
                           startTime = "${int.parse(data[index]['StartTime'].split(':')[0]) }:00 AM";
                        }
                        return InkWell(
                          onTap: () {
                            Get.to(HallBookingPage(hallModel: hall));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Image.network(
                                  hall.images![0],
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        hall.name!,
                                        style: Themes.header2.copyWith(
                                            color: Colors.black, fontSize: 12),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        'Date: ' + data[index]['date'],
                                        style: Themes.header3.copyWith(
                                            color: Colors.black, fontSize: 12),
                                      ),
                                      Text(

                                        'Start time: ' +
                                            startTime,
                                        style: Themes.header3.copyWith(
                                            color: Colors.black, fontSize: 12),
                                      ),
                                      Text(
                                        'Price: ${data[index]['price']}JD',
                                        style: Themes.header3.copyWith(
                                            color: Colors.black, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child:  Container(
                                        alignment: Alignment.topRight,
                                        margin: EdgeInsets.only(left: 60),
                                        child: PopupMenuButton(
                                          icon: const Icon(
                                              FontAwesomeIcons.ellipsisV,
                                              color: Colors.grey,
                                              size: 20),
                                          itemBuilder: (BuildContext context) => [
                                            const PopupMenuItem<int>(
                                              value: 0,
                                              child: Text(
                                                "Edit the booking",
                                                style:
                                                    TextStyle(color: Colors.black),
                                              ),
                                            ),
                                            PopupMenuItem<int>(
                                              value: 1,
                                              child: const Text(
                                                "Cancel your booking",
                                                style:
                                                    TextStyle(color: Colors.black),
                                              ),
                                              onTap: () async {
                                                await FirebaseFirestore.instance
                                                    .collection('orders')
                                                    .doc(data[index]['orderID'])
                                                    .delete()
                                                    .then((value) => GFToast.showToast(
                                                        'Your reservation has been cancelled.',
                                                        context,
                                                        toastPosition:
                                                            GFToastPosition.BOTTOM,
                                                        toastDuration: 6,
                                                        textStyle: const TextStyle(
                                                            fontSize: 16,
                                                            color: GFColors.LIGHT),
                                                        backgroundColor:
                                                            GFColors.DARK,
                                                        trailing: const Icon(
                                                          FontAwesomeIcons
                                                              .exclamation,
                                                          color: GFColors.WARNING,
                                                          size: 18,
                                                        )));
                                              },
                                            ),
                                            PopupMenuItem<int>(
                                              value: 2,
                                              child: const Text(
                                                "Booking is over",
                                                style:
                                                    TextStyle(color: Colors.black),
                                              ),
                                              onTap: () {}

                                            )
                                          ],
                                          onSelected: (item) => {
                                            if (item == 0)
                                              {
                                                showModalBottomSheet(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      // controller.groupValue = hall.price!['pricePerHour'] != ''? 0: 1;
                                                      return SingleChildScrollView(
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets.all(
                                                                  0.0),
                                                          child: GetBuilder(
                                                            init:
                                                                HomeScreenController(),
                                                            builder: (_) => Column(
                                                              children: [
                                                                GFCard(
                                                                  margin:
                                                                      const EdgeInsets
                                                                          .all(0),
                                                                  content:
                                                                      Container(
                                                                    height: 45,
                                                                    padding:
                                                                        const EdgeInsets
                                                                                .all(
                                                                            8.0),
                                                                    child: Row(
                                                                      children: [
                                                                        Text(
                                                                            "Edit your Booking!",
                                                                            style: Themes
                                                                                .mTitleStyle),
                                                                        const SizedBox(
                                                                            width:
                                                                                10),
                                                                        CircleAvatar(
                                                                          backgroundColor:
                                                                              Colors
                                                                                  .transparent,
                                                                          radius:
                                                                              16,
                                                                          child: Image
                                                                              .asset(
                                                                            'assets/letsbooking.png',
                                                                            fit: BoxFit
                                                                                .contain,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                GFCard(
                                                                  margin:
                                                                      const EdgeInsets
                                                                          .all(0),
                                                                  content: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceAround,
                                                                    children: <
                                                                        Widget>[
                                                                      Container(
                                                                          alignment:
                                                                              Alignment
                                                                                  .topLeft,
                                                                          child: Text(
                                                                              "Booking",
                                                                              style:
                                                                                  Themes.mTitleStyle)),
                                                                      Row(
                                                                        children: [
                                                                          GFRadio(
                                                                            type: GFRadioType
                                                                                .custom,
                                                                            size:
                                                                                20,
                                                                            value:
                                                                                0,
                                                                            groupValue:
                                                                                controller.groupValue,
                                                                            onChanged: hall.price!['pricePerHour'] !=
                                                                                    ''
                                                                                ? (value) =>
                                                                                    controller.radioButton(value)
                                                                                : (value) => GFToast.showToast('Sorry, This option is not available from the owner.', context,
                                                                                    toastPosition: GFToastPosition.BOTTOM,
                                                                                    textStyle: const TextStyle(fontSize: 16, color: GFColors.LIGHT),
                                                                                    backgroundColor: GFColors.DARK,
                                                                                    toastDuration: 4,
                                                                                    trailing: const Icon(
                                                                                      FontAwesomeIcons.exclamation,
                                                                                      color: GFColors.WARNING,
                                                                                      size: 18,
                                                                                    )),
                                                                            inactiveIcon:
                                                                                null,
                                                                            activeIcon: const Icon(
                                                                                FontAwesomeIcons
                                                                                    .check,
                                                                                color:
                                                                                    GFColors.SUCCESS,
                                                                                size: 14),
                                                                            activeBorderColor:
                                                                                GFColors.SUCCESS,
                                                                            customBgColor:
                                                                                GFColors.SUCCESS,
                                                                          ),
                                                                          Text(
                                                                              "  by hour",
                                                                              style: Themes
                                                                                  .mServiceTitleStyle
                                                                                  .copyWith(fontSize: 16)),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          GFRadio(
                                                                            type: GFRadioType
                                                                                .custom,
                                                                            size:
                                                                                20,
                                                                            value:
                                                                                1,
                                                                            groupValue:
                                                                                controller.groupValue,
                                                                            onChanged: hall.price!['pricePerDay'] !=
                                                                                    ''
                                                                                ? (value) =>
                                                                                    controller.radioButton(value)
                                                                                : (value) => GFToast.showToast('Sorry, This option is not available from the owner.', context,
                                                                                    toastPosition: GFToastPosition.BOTTOM,
                                                                                    textStyle: const TextStyle(fontSize: 16, color: GFColors.LIGHT),
                                                                                    backgroundColor: GFColors.DARK,
                                                                                    toastDuration: 4,
                                                                                    trailing: const Icon(
                                                                                      FontAwesomeIcons.exclamation,
                                                                                      color: GFColors.WARNING,
                                                                                      size: 18,
                                                                                    )),
                                                                            inactiveIcon:
                                                                                null,
                                                                            activeBorderColor:
                                                                                GFColors.SUCCESS,
                                                                            customBgColor:
                                                                                GFColors.SUCCESS,
                                                                            activeIcon: const Icon(
                                                                                FontAwesomeIcons
                                                                                    .check,
                                                                                color:
                                                                                    GFColors.SUCCESS,
                                                                                size: 14),
                                                                          ),
                                                                          Text(
                                                                              "  by day",
                                                                              style: Themes
                                                                                  .mServiceTitleStyle
                                                                                  .copyWith(fontSize: 16)),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                GFCard(
                                                                  margin:
                                                                      const EdgeInsets
                                                                          .all(0),
                                                                  content:
                                                                      CalendarTimeline(
                                                                    initialDate:
                                                                        DateTime
                                                                            .now(),
                                                                    firstDate:
                                                                        DateTime
                                                                            .now(),
                                                                    lastDate:
                                                                        DateTime(
                                                                            2022,
                                                                            12,
                                                                            31),
                                                                    onDateSelected:
                                                                        (date) {
                                                                       dateBooked = date
                                                                          .toString()
                                                                          .split(
                                                                              ' ')[0];
                                                                      print(
                                                                          dateBooked);
                                                                    },
                                                                    leftMargin: 20,
                                                                    monthColor: Colors
                                                                        .blueGrey,
                                                                    dayColor: Colors
                                                                        .teal[200],
                                                                    activeDayColor:
                                                                        Colors
                                                                            .white,
                                                                    activeBackgroundDayColor:
                                                                        Colors.green[
                                                                            100],
                                                                    dotsColor:
                                                                        const Color(
                                                                            0xFF333A47),
                                                                    selectableDayPredicate:
                                                                        (date) =>
                                                                            date.day !=
                                                                            23,
                                                                    locale:
                                                                        'en_ISO',
                                                                  ),
                                                                ),
                                                                controller.groupValue ==
                                                                        0
                                                                    ? GFCard(
                                                                        margin: const EdgeInsets
                                                                            .all(0),
                                                                        padding: const EdgeInsets
                                                                                .symmetric(
                                                                            horizontal:
                                                                                22,
                                                                            vertical:
                                                                                8),
                                                                        content:
                                                                            Column(
                                                                          children: [
                                                                            Row(
                                                                              mainAxisAlignment:
                                                                                  MainAxisAlignment.spaceEvenly,
                                                                              children: [
                                                                                Expanded(
                                                                                    child: Text(
                                                                                  "Start Time",
                                                                                  style: Themes.mTitleStyle,
                                                                                )),
                                                                                const SizedBox(
                                                                                  height: 10,
                                                                                ),
                                                                                Expanded(
                                                                                  flex: 2,
                                                                                  child: Container(
                                                                                    height: 50,
                                                                                    width: MediaQuery.of(context).size.width * 0.7,
                                                                                    margin: EdgeInsets.only(top: 10),
                                                                                    child: DropdownButtonHideUnderline(
                                                                                      child: GFDropdown(
                                                                                        padding: const EdgeInsets.all(15),
                                                                                        borderRadius: BorderRadius.circular(10),
                                                                                        border: const BorderSide(color: Colors.black12, width: 1),
                                                                                        dropdownButtonColor: Colors.white,
                                                                                        value: controller.dropdownValue,
                                                                                        onChanged: (newValue) {
                                                                                          controller.dropDown(newValue);
                                                                                        },
                                                                                        items: [
                                                                                          '8:00 AM',
                                                                                          '9:00 AM',
                                                                                          '10:00 AM',
                                                                                          '11:00 AM',
                                                                                          '12:00 PM',
                                                                                          '1:00 PM',
                                                                                          '2:00 PM',
                                                                                          '3:00 PM',
                                                                                          '4:00 PM',
                                                                                          '5:00 PM',
                                                                                          '6:00 PM',
                                                                                          '7:00 PM',
                                                                                          '8:00 PM',
                                                                                          '9:00 PM',
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
                                                                              mainAxisAlignment:
                                                                                  MainAxisAlignment.spaceEvenly,
                                                                              children: [
                                                                                Expanded(
                                                                                    child: Text(
                                                                                  "For ",
                                                                                  style: Themes.mTitleStyle,
                                                                                )),
                                                                                const SizedBox(
                                                                                  height: 10,
                                                                                ),
                                                                                Expanded(
                                                                                  flex: 2,
                                                                                  child: Container(
                                                                                    height: 50,
                                                                                    width: MediaQuery.of(context).size.width * 0.7,
                                                                                    margin: EdgeInsets.only(top: 10),
                                                                                    child: DropdownButtonHideUnderline(
                                                                                      child: GFDropdown(
                                                                                        padding: const EdgeInsets.all(15),
                                                                                        borderRadius: BorderRadius.circular(10),
                                                                                        border: const BorderSide(color: Colors.black12, width: 1),
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
                                                                    margin:
                                                                        const EdgeInsets
                                                                            .all(0),
                                                                    content:
                                                                        MyButton(
                                                                            text:
                                                                                'Book',
                                                                            onPressed:
                                                                                () async {
                                                                              if (_auth.currentUser!.uid !=
                                                                                  hall.ownID) {
                                                                                return GFToast.showToast('Sorry, You can not book your hall.',
                                                                                    context,
                                                                                    toastPosition: GFToastPosition.BOTTOM,
                                                                                    textStyle: const TextStyle(fontSize: 16, color: GFColors.LIGHT),
                                                                                    backgroundColor: GFColors.DARK,
                                                                                    trailing: const Icon(
                                                                                      FontAwesomeIcons.exclamation,
                                                                                      color: GFColors.WARNING,
                                                                                      size: 18,
                                                                                    ));
                                                                              } else {
                                                                                var uuid = Uuid();
                                                                                int startTime = int.parse(controller.dropdownValue.split(':')[0]);
                                                                                bool pmTime =controller.dropdownValue.split(' ')[1] == "PM";
                                                                                int startF= pmTime? (startTime==12?startTime:startTime + 12): startTime;
                                                                                int endTimeFinal =controller.dropdownEndTime == 'one hour'?
                                                                                startF+1:controller.dropdownEndTime == 'two hours'?
                                                                                startF+2:controller.dropdownEndTime == 'three hours'?
                                                                                startF+3:startF+4;
                                                                                print('End Time : $endTimeFinal');
                                                                                final firebase = await FirebaseFirestore.instance.collection("orders").where('hall_id',isEqualTo:hall.hallID).get();
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
                                                                                if (exist) {
                                                                                  GFToast.showToast('Sorry, this time is not available, please choose another time.', context,
                                                                                      toastPosition: GFToastPosition.BOTTOM,
                                                                                      toastDuration: 6,
                                                                                      textStyle: const TextStyle(fontSize: 16, color: GFColors.LIGHT),
                                                                                      backgroundColor: GFColors.DARK,
                                                                                      trailing: const Icon(
                                                                                        FontAwesomeIcons.exclamation,
                                                                                        color: GFColors.WARNING,
                                                                                        size: 18,
                                                                                      ));
                                                                                } else {
                                                                                  await FirebaseFirestore.instance.collection("orders").doc('${data[index]['orderID']}').set({
                                                                                    'StartTime':'$startF:00',
                                                                                    'orderID':'${data[index]['orderID']}',
                                                                                    'EndTime': controller.dropdownEndTime == 'one hour'?
                                                                                    '${startF+1}:00':controller.dropdownEndTime == 'two hours'?
                                                                                    '${startF+2}:00':controller.dropdownEndTime == 'three hours'?
                                                                                    '${startF+3}:00':'${startF+4}:00',
                                                                                    'date':dateBooked,
                                                                                    'hall_id':hall.hallID!,
                                                                                    'ownID':hall.ownID!,
                                                                                    'approve':false,
                                                                                    'price':controller.groupValue==0?
                                                                                    (controller.dropdownEndTime == 'one hour'?
                                                                                    int.parse(hall.price!['pricePerHour']) * 1:controller.dropdownEndTime == 'two hours'?
                                                                                    int.parse(hall.price!['pricePerHour']) * 2:controller.dropdownEndTime == 'three hours'?
                                                                                    int.parse(hall.price!['pricePerHour']) * 3:int.parse(hall.price!['pricePerHour']) * 4)
                                                                                        :hall.price!['pricePerDay'],
                                                                                    'visitorID':_auth.currentUser!.uid,
                                                                                    'isFinish':false,
                                                                                    'type':controller.groupValue==0?'hour':'day',
                                                                                    'rate':0,
                                                                                    'review':[],
                                                                                  });
                                                                                  // await FirebaseFirestore.instance.collection("halls").where('requests',isEqualTo: _auth.currentUser!.uid+hallModel.hallID!+uuid.v1());
                                                                                  print(
                                                                                      "DONE");
                                                                                  Get.offAll(() =>
                                                                                      BottomNavigation(index: 1));
                                                                                  GFToast.showToast(
                                                                                      'Edited successfully, Have Fun.',
                                                                                      context,
                                                                                      toastPosition: GFToastPosition.BOTTOM,
                                                                                      toastDuration: 6,
                                                                                      textStyle: const TextStyle(fontSize: 13, color: GFColors.LIGHT),
                                                                                      backgroundColor: GFColors.DARK,
                                                                                      trailing: const Icon(
                                                                                        FontAwesomeIcons.exclamation,
                                                                                        color: GFColors.WARNING,
                                                                                        size: 16,
                                                                                      ));
                                                                                }
                                                                              }

                                                                            },
                                                                            color:
                                                                                orangeClr,
                                                                            width:
                                                                                140,
                                                                            height:
                                                                                50)),
                                                                const SizedBox(
                                                                    height: 15),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                              }
                                            else if(item==2){
                                              popup.show(
                                                title: 'Review',
                                                content: Center(
                                                  child: RatingBar(
                                                    initialRating: 0,
                                                    direction: Axis.horizontal,
                                                    allowHalfRating: true,
                                                    itemCount: 5,
                                                    ratingWidget: RatingWidget(
                                                      full: const Icon(FontAwesomeIcons.solidStar,color: orangeClr,),
                                                      half: const Icon(FontAwesomeIcons.starHalfAlt,color: orangeClr,),
                                                      empty: const Icon(FontAwesomeIcons.star,color: orangeClr,),
                                                    ),
                                                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                                                    onRatingUpdate: (rating) async {
                                                      Get.back();
                                                      print(rating);
                                                      await FirebaseFirestore.instance
                                                          .collection('halls')
                                                          .doc(hall.hallID)
                                                          .update({'rated':((double.parse(hall.rated!) + rating)/2).toStringAsFixed(1),'visitors':hall.visitors! + 1});
                                                      await FirebaseFirestore.instance
                                                          .collection('orders')
                                                          .doc(data[index]['orderID'])
                                                          .delete();
                                                    },
                                                  ),
                                                ),
                                                // bool barrierDismissible = false,
                                                // Widget close,

                                              ),
                                            }
                                          },
                                        )),

                              )
                            ],
                          ),
                        );
                      }),
                ),
              ),
            );
          }),
    );
  }
}
