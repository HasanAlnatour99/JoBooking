import 'package:bookingme/models/hall.dart';
import 'package:bookingme/services/firestore_hall.dart';
import 'package:bookingme/ui/widgets/bottom_navigation.dart';
import 'package:bookingme/ui/widgets/button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';

import '../theme.dart';
import 'hall_details.dart';
import 'homescreen.dart';
class MyHalls extends StatefulWidget {
  const MyHalls({Key? key}) : super(key: key);

  @override
  State<MyHalls> createState() => _MyHallsState();
}

class _MyHallsState extends State<MyHalls> {
  final CollectionReference<Map<String, dynamic>> _hallCollection =
  FirebaseFirestore.instance.collection("halls");
  final FirebaseAuth _auth =  FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        title: Text(
          "My Halls",
          style: Themes.header2,
        ),
        centerTitle: true,
        backgroundColor: blueClr,
        leading: MyIconButton(
          onPressed: () => Get.off(() => BottomNavigation(index:0)),
          icon: Icons.arrow_back,
          iconSize: 25,
          color: Colors.white,
        ),
      ),
      body:SafeArea(
        child: SingleChildScrollView(
          child: StreamBuilder<QuerySnapshot>(
                stream:  _hallCollection.where('ownID',isEqualTo:_auth.currentUser!.uid ).snapshots(),
                builder:
                    (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  print(snapshot.connectionState);
                  if (snapshot.hasError) {
                    return const Text("Something went wrong");
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("loading");
                  }

                    List data = snapshot.data!.docs ;
                     return GridView(
                        physics: const PageScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 4.0,
                          mainAxisSpacing: 4.0,childAspectRatio: 0.7
                        ),
                        children: snapshot.data!.docs.map((DocumentSnapshot document) {
                          Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                          return GestureDetector(
                            onTap: (){
                             final HallModel s = HallModel.fromJson(data);
                              Get.to(HallDetail(hallModel: s,));
                            },
                            child: GFCard(
                              padding: const EdgeInsets.only(left:8),
                              image: Image.network(
                                data['images'][0],
                                height: MediaQuery.of(context).size.height * 0.2,
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.cover,
                              ),
                              showImage: true,
                              content: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  const SizedBox(height:3),
                                  Container(alignment:Alignment.centerLeft,child: Text('${data['visitors']}  Visited',style: const TextStyle(fontSize: 12),
                                  overflow: TextOverflow.ellipsis,
                                  )),
                                  const SizedBox(height:3),
                                  Container(alignment:Alignment.centerLeft,child: Text('${data['address']} ',overflow: TextOverflow.fade,style: const TextStyle(fontSize: 12),)),

                                ],
                              ),
                              title:  GFListTile(
                                padding: const EdgeInsets.only(top:7,bottom: 5),
                                margin: EdgeInsets.zero,
                                title: Text('${data['name']}',style: Themes.header2.copyWith(fontSize: 12,color: blackClr),),
                              ),

                            ),
                          );
                        }).toList(),
                      );

                },
              ),
        ),
      ) ,
    );
  }
}
