import 'package:bookingme/models/hall.dart';
import 'package:bookingme/ui/widgets/bottom_navigation.dart';
import 'package:bookingme/ui/widgets/button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';

import '../theme.dart';
import 'hall_booking.dart';

class LetsBooking extends StatelessWidget {
   LetsBooking({Key? key, required this.title}) : super(key: key);
  final String title;
  //promos
 @override
  Widget build(BuildContext context) {
   Stream<QuerySnapshot<Map<String, dynamic>>> promotionStream =FirebaseFirestore.instance.collection("halls").where('promotion', isEqualTo: true).orderBy('visitors', descending: true).snapshots();
   Stream<QuerySnapshot<Map<String, dynamic>>> letsBookingStream =FirebaseFirestore.instance.collection("halls").where('type', isEqualTo: title).orderBy('visitors', descending: true).snapshots();

   return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          title,
          style: Themes.header2.copyWith(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: MyIconButton(
          onPressed: () => Get.off(() => BottomNavigation(index: 0)),
          icon: Icons.arrow_back,
          iconSize: 25,
          color: Colors.black,
        ),
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: title=='promos'? promotionStream:letsBookingStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.none) {
              return Text("Check your internet ,PLease");
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: Text("Loading"));
            }
            if (snapshot.hasData == false) {
              return const Center(child: Text("Try Again."));
            }
            final data = snapshot.data!.docs;

            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                Map<String,dynamic> hall = snapshot.data!.docs[index].data() as Map<String,dynamic>;
                return InkWell(
                  onTap: (){
                    final HallModel s = HallModel.fromJson(hall);
                    Get.to(HallBookingPage(hallModel: s));},
                  child: GFCard(
                    margin: const EdgeInsets.all(8),
                    boxFit: BoxFit.cover,
                    elevation: 3,
                    borderRadius: BorderRadius.circular(30),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Stack(
                            children: [
                              Container(
                                foregroundDecoration: const BoxDecoration(
                                  color: Colors.black26,
                                ),
                                height: 100,
                                child: Image.network(
                                  title=='promos'?data[index]['promotionImage'] : data[index]['images'][0],
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 5,
                                left: 5,
                                child: Row(
                                  children: [
                                    Text( double.parse(data[index]['rated']) != 0.0 ||
                                        double.parse(data[index]['rated']) >= 1 ? double.parse(data[index]['rated']).toStringAsFixed(1) : "New",
                                        style: Themes.mTravlogTitleStyle
                                            .copyWith(color: lightOrange)),
                                    const Icon(
                                      FontAwesomeIcons.solidStar,
                                      color: lightOrange,
                                      size: 11,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(data[index]['name'],style: Themes.header2.copyWith(color:Colors.black,fontSize: 12,fontWeight: FontWeight.w900),),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 3.0,
                                  horizontal: 5.0,
                                ),
                                decoration: BoxDecoration(
                                    color: orangeClr,
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: Text(
                                  "${data[index]['visitors']} Visited",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 12.0,fontWeight: FontWeight.w700,),
                                ),
                              ),
                              price(data[index]['price']),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(data[index]['address'],style: Themes.mTravlogPlaceStyle,),
                      )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
  Widget price(price) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        children: [
          price!['pricePerHour'] != ''
              ? Expanded(
            child: Row(
                children: <Widget>[
                  Text(
                    "${price!['pricePerHour']} JD",
                    style: const TextStyle(
                        color: orangeClr,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.0),
                  ),
                  const Text(
                    " /per hour",
                    style: TextStyle(fontSize: 12.0, color: Colors.grey),
                  )
                ],
            ),
          )
              : Container(),
          price!['pricePerDay'] != ''
              ? Expanded(
            child: Row(
                children: <Widget>[
                  Text(
                    "${price!['pricePerDay']} JD",
                    style: const TextStyle(
                        color: orangeClr,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.0),
                  ),
                  const Text(
                    " /per day",
                    style: TextStyle(fontSize: 12.0, color: Colors.grey),
                  )
                ],
              ),
          )
              : Container(),
        ],
      ),
    );
  }
}
