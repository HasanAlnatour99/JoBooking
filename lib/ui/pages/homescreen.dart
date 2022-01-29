import 'package:bookingme/controllers/hall_controller.dart';
import 'package:bookingme/controllers/homescreen_controller.dart';
import 'package:bookingme/controllers/profile_controller.dart';
import 'package:bookingme/models/hall.dart';
import 'package:bookingme/services/firestore_user.dart';
import 'package:bookingme/ui/pages/profile.dart';
import 'package:bookingme/ui/widgets/bottom_navigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme.dart';
import 'add_hall.dart';
import 'hall_booking.dart';
import 'hall_booking_section.dart';
import 'hall_details.dart';
import 'home_lets_booking.dart';
import 'login_page.dart';
import 'mainpage.dart';
import 'my_halls.dart';
import 'mybooking.dart';

class homescreen extends StatefulWidget {
  @override
  _homescreenState createState() => _homescreenState();
}

class _homescreenState extends State<homescreen> {
  int _currentIndex = 0;
  List<Widget> _widgetoption = <Widget>[home(), mybokoing()];
  ProfileController pController = Get.put(ProfileController());
  HallController hController = Get.put(HallController());
  HomeScreenController homeController = Get.put(HomeScreenController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pController = Get.put(ProfileController());
    pController.getInfo();
  }

  @override
  Widget build(BuildContext context) {
    int _current = 0;

    List<T> map<T>(List list, Function handler) {
      List<T> result = [];
      for (var i = 0; i < list.length; i++) {
        result.add(handler(i, list[i]));
      }
      return result;
    }

    // ProfileController controller = Get.put(ProfileController());
    return  SafeArea(
        child: ListView(
          physics: const ClampingScrollPhysics(),
          children: <Widget>[
            // Promos Section
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 24),
              child: Text(
                'Hi, ${pController.name.split(' ')[0]} 👋 This Promos for You!',
                style: Themes.mTitleStyle,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(left: 16, right: 16),
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 190,
                    child: Swiper(
                      onIndexChanged: (index) {
                        homeController.onChange(index);
                      },
                      autoplay: true,

                      layout: SwiperLayout.DEFAULT,
                      itemCount: 3,
                      duration: 5,
                      outer: true,
                      autoplayDisableOnInteraction: true,
                      curve: Curves.fastLinearToSlowEaseIn,
                      itemBuilder: (BuildContext context, index) {
                        return StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("halls")
                              .where('promotion',isEqualTo: true).limit(3)
                              .snapshots(),
                          builder: (context,AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return const Text('Something went wrong');
                            }

                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Text("Loading");
                            }
                            // homeController.setLengthCarousel(snapshot.data!.docs);
                            Map<String, dynamic> data = snapshot.data!.docs[index]
                                .data() as Map<String, dynamic>;
                            return Column(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: (){
                                      final HallModel s = HallModel.fromJson(data);
                                      Get.to(HallBookingPage(hallModel: s));
                                    },
                                    child: Container(
                                      height: 200,
                                      width:double.maxFinite,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                            image: NetworkImage(
                                              data['promotionImage'],
                                            ),
                                            fit: BoxFit.cover,

                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height:10,),
                                Row(
                                  children: map<Widget>(
                                    snapshot.data!.docs,
                                        (index, image) {
                                      return Container(
                                        alignment: Alignment.centerLeft,
                                        height: 6,
                                        width: 6,
                                        margin: const EdgeInsets.only(right: 8),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: homeController.currentIndex.value == index
                                                ? mBlueColor
                                                : mGreyColor),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          }
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  GetBuilder(
                    init: HomeScreenController(),
                    builder:(context)=> Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        // More
                        TextButton(
                          onPressed: (){
                            Get.off(()=>LetsBooking(title: 'promos',));
                          },
                          child: Text( 'More...',
                            style: Themes.mMoreDiscountStyle,)
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Service Section
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 24, bottom: 12),
              child: Text(
                'Let\'s Booking!',
                style: Themes.mTitleStyle,
              ),
            ),
            Container(
              height: 144,
              margin: const EdgeInsets.only(left: 16, right: 16),
              child: Column(
                children: <Widget>[
                  Row(
                      children: <Widget>[
                        Expanded(
                          child: InkWell(
                            onTap:()=>Get.off(()=>LetsBooking(title: 'Bowling',)) ,
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.only(left: 16),
                              height: 64,
                              decoration: BoxDecoration(
                                color: mFillColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: mBorderColor, width: 1),
                              ),
                              child: Row(
                                children: <Widget>[
                                  CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    radius: 23,
                                    child: Image.asset(
                                      'assets/bowling.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          'Bowling \nalleys',
                                          style: Themes.mServiceTitleStyle,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap:()=>Get.off(()=>LetsBooking(title: 'Gymnasium',)) ,
                            child: Container(
                              margin: const EdgeInsets.only(left: 8),
                              padding: const EdgeInsets.only(left: 16),
                              height: 64,
                              decoration: BoxDecoration(
                                color: mFillColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: mBorderColor, width: 1),
                              ),
                              child: Row(
                                children: <Widget>[
                                  CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    radius: 23,
                                    child: Image.asset(
                                      'assets/sports.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          'Gymnasium',
                                          style: Themes.mServiceTitleStyle,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),

                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: InkWell(
                          onTap:()=>Get.off(()=>LetsBooking(title: 'Classroom',)) ,
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.only(left: 16),
                            height: 64,
                            decoration: BoxDecoration(
                              color: mFillColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: mBorderColor, width: 1),
                            ),
                            child: Row(
                              children: <Widget>[
                                CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  radius: 23,
                                  child: Image.asset(
                                    'assets/classroom.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        'Classroom',
                                        style: Themes.mServiceTitleStyle,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap:()=>Get.off(()=>LetsBooking(title: 'Studio',)) ,
                          child: Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.only(left: 16),
                            height: 64,
                            decoration: BoxDecoration(
                              color: mFillColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: mBorderColor, width: 1),
                            ),
                            child: Row(
                              children: <Widget>[
                                CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  radius: 23,
                                  child: Image.asset(
                                    'assets/studio2.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        'Studio',
                                        style: Themes.mServiceTitleStyle,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),

            // Popular Destination Section
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 24, bottom: 12),
              child: Text(
                'Popular Destinations!',
                style: Themes.mTitleStyle,
              ),
            ),
            SizedBox(
              height: 140,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("halls")
                    .orderBy('visitors', descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Loading");
                  }


                  return ListView.builder(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> data = snapshot.data!.docs[index]
                          .data() as Map<String, dynamic>;
                      print(data['name']);
                      return InkWell(
                        onTap: () {
                        final HallModel s = HallModel.fromJson(data);
                          Get.to(HallBookingPage(hallModel: s));
                        },
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Container(
                            height: 140,
                            width: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: mBorderColor, width: 1),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 8.0, bottom: 16, left: 3, right: 3),
                              child: Column(
                                children: <Widget>[
                                  CircleAvatar(
                                    backgroundColor: Colors.black12,
                                    radius: 30,
                                    backgroundImage: NetworkImage(
                                      data['images'][0],
                                    ),
                                  ),
                                  const SizedBox(height: 7),
                                  Center(
                                    child: Text(
                                      data['name'],
                                      maxLines: 1,
                                      softWrap: false,
                                      style: Themes.mPopularDestinationTitleStyle,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    data['address'].split(',')[1],
                                    style:
                                        Themes.mPopularDestinationSubtitleStyle,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // Travlog Section
            Padding(
              padding: EdgeInsets.only(left: 16, top: 24, bottom: 12),
              child: Text(
                'Top Rated!',
                style: Themes.mTitleStyle,
              ),
            ),
            SizedBox(
              height: 181,
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("halls")
                      .orderBy('rated', descending: true)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text("Loading");
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.only(left: 16),
                      itemCount: snapshot.data!.docs.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> data = snapshot.data!.docs[index]
                            .data() as Map<String, dynamic>;
                        return InkWell(
                          onTap:(){
                            final HallModel s = HallModel.fromJson(data);
                            Get.to(HallBookingPage(hallModel: s));
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 16),
                            width: 220,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Stack(
                                  children: <Widget>[
                                    Container(
                                      height: 104,
                                      foregroundDecoration: const BoxDecoration(
                                        color: Colors.black26,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                data['images'][0]),
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                    // Positioned(
                                    //   child: Image.network(
                                    //       'https://image.shutterstock.com/image-vector/global-network-icon-vector-illustration-600w-165320162.jpg'),
                                    //   right: 0,
                                    // ),
                                    // Positioned(
                                    //   top: 8,
                                    //   right: 8,
                                    //   child: Image.network(
                                    //       'https://image.shutterstock.com/image-vector/global-network-icon-vector-illustration-600w-165320162.jpg'),
                                    // ),
                                    Positioned(
                                      top: 5,
                                      right:5,
                                      child: Container(
                                        alignment: Alignment.topRight,
                                        child: Row(
                                          children: [
                                            Text(
                                              double.parse(data['rated']) !=
                                                          0.0 ||
                                                      double.parse(
                                                              data['rated']) >=
                                                          1
                                                  ? double.parse(data['rated'])
                                                      .toStringAsFixed(1)
                                                  : "New", style: Themes.mTravlogTitleStyle.copyWith(color: lightOrange)),
                                            const Icon(FontAwesomeIcons.solidStar,color: lightOrange,size: 11,),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 8,
                                      left: 5,
                                      child: Text(
                                        data['name'],
                                        overflow: TextOverflow.ellipsis,
                                        style: Themes.mTravlogTitleStyle,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  data['description'].toString().trimLeft(),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,

                                  style: Themes.mTravlogContentStyle
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  data['address'],
                                  overflow: TextOverflow.ellipsis,
                                  style: Themes.mTravlogPlaceStyle,
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),
            )
          ],
        ),
      );
  }
}

