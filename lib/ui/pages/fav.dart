import 'package:bookingme/models/hall.dart';
import 'package:bookingme/ui/widgets/bottom_navigation.dart';
import 'package:bookingme/ui/widgets/button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';

import '../theme.dart';
import 'hall_booking.dart';

class Favscreen extends StatefulWidget {
  const Favscreen({Key? key}) : super(key: key);

  @override
  _FavscreenState createState() => _FavscreenState();
}

TextEditingController search = TextEditingController();

class _FavscreenState extends State<Favscreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    search = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    search.dispose();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
 String searchText = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        title: Text(
          "Favorites",
          style: Themes.header2,
        ),
        centerTitle: true,
        backgroundColor: blueClr,
        leading: MyIconButton(
          onPressed: () => Get.off(() => BottomNavigation(index: 0)),
          icon: Icons.arrow_back,
          iconSize: 25,
          color: Colors.white,
        ),
      ),
      body: SafeArea(
        child:  SingleChildScrollView(
          child: Container(
              margin: const EdgeInsets.all(10),
              child: Column(
                children: [
                  // searchBar(),
                  const SizedBox(
                    height: 50,
                  ),
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("favorites")
                          .where('likerID', isEqualTo: _auth.currentUser!.uid)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Something went wrong');
                        }
                        if (snapshot.connectionState == ConnectionState.none) {
                          return Text("Check your internet ,PLease");
                        }
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Text("Loading");
                        }
                        if (snapshot.hasData == false) {
                          return const Center(
                              child: Text("You don't have any favorite hall yet."));
                        }


                        return ListView(
                          shrinkWrap: true,
                          children:
                              snapshot.data!.docs.map((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data()! as Map<String, dynamic>;
                            return GFCard(
                              margin:const EdgeInsets.all(3),
                              padding:const EdgeInsets.only(bottom: 15,top: 2,left:0,right:0),
                              content: StreamBuilder(
                                  stream: FirebaseFirestore.instance.collection("halls").where('hallID', isEqualTo: data['hallID']).snapshots(),
                                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasError) {
                                      return Text('Something went wrong');
                                    }
                                    if (snapshot.connectionState == ConnectionState.none) {
                                      return Text("Check your internet ,PLease");
                                    }
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return Text("Loading");
                                    }
                                    if (snapshot.hasData == false) {
                                      return const Center(
                                          child: Text("You don't have any favorite hall yet."));
                                    }
                                    final Map<String,dynamic>  hallData = snapshot.data!.docs.first.data()! as Map<String,dynamic>;
                                    final HallModel hall = HallModel.fromJson(hallData);
                                    return InkWell(
                                      onTap: (){
                                        Get.to(HallBookingPage(hallModel: hall));
                                      },
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Stack(
                                            children: <Widget>[
                                              Container(
                                                height: 104,
                                                foregroundDecoration:BoxDecoration(color: Colors.black26) ,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(8),
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          hall.images![0]),
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
                                                      Text( double.parse(hall.rated!) !=
                                                          0.0 ||
                                                          double.parse(hall.rated!) >=
                                                              1
                                                          ? double.parse(hall.rated!)
                                                          .toStringAsFixed(1)
                                                          : "New", style: Themes.mTravlogTitleStyle.copyWith(color: lightOrange)),
                                                      const Icon(FontAwesomeIcons.solidStar,color: lightOrange,size: 11,),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                bottom: 8,
                                                left: 8,
                                                child: Text(
                                                  hall.name!,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: Themes.mTravlogTitleStyle,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Container(
                                            margin:const EdgeInsets.symmetric(horizontal: 12),
                                            child: Text(
                                              hall.description.toString().trimLeft(),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: Themes.mTravlogContentStyle,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Container(
                                            margin:const EdgeInsets.symmetric(horizontal: 12),
                                            child: Text(
                                              hall.address!,
                                              overflow: TextOverflow.ellipsis,
                                              style: Themes.mTravlogPlaceStyle,
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  }),
                            );
                          }).toList(),
                        );
                      },
                    ),

                ],
              ),
            ),
        ),

      ),
    );
  }

  TextFormField searchBar() {
    return TextFormField(
        controller: search,
        onChanged: (v){
         setState(() {
           searchText = v;
         });
        },
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(5),
            isDense: true,
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(15),
            ),
            hintText: 'Search by name',
            hintStyle: Themes.inputStyle.copyWith(fontWeight: FontWeight.w300),
            prefixIcon: const Icon(
              FontAwesomeIcons.search,
              color: blueClr,
              size: 20,
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: blueClr)),
            floatingLabelStyle: Themes.inputStyle.copyWith(
              fontSize: 18,
            )));
  }
}
