import 'package:bookingme/controllers/profile_controller.dart';
import 'package:bookingme/ui/widgets/bottom_navigation.dart';
import 'package:bookingme/ui/widgets/button.dart';
import 'package:bookingme/ui/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../theme.dart';
import 'edit_profile.dart';
import 'homescreen.dart';

class ProfilePage extends StatelessWidget {
  static const routeName = '/profile';
  ProfileController controller = Get.put(ProfileController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 3,
        title: Text(
          "Profile",
          style: Themes.header2,
        ),
        centerTitle: true,
        backgroundColor: blueClr,
        leading: MyIconButton(
          onPressed: () => Get.off(() => BottomNavigation(index: 0,)),
          icon: Icons.arrow_back,
          iconSize: 25,
          color: Colors.white,
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
        width: double.infinity,
        height:MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        child: Column(
            children: [
              SizedBox(height: 30),
              SizedBox(
                height: 115,
                width: 115,
                child: Stack(
                  clipBehavior: Clip.none,
                  fit: StackFit.expand,
                  children: [
                    GetBuilder(
                      init: ProfileController(),
                      builder:(_){
                        return  CircleAvatar(
                        backgroundImage:controller.pic==''? AssetImage("assets/userIcon.png"): Image.network(controller.pic).image,
                      );
                      },
                    ),
                    Positioned(
                        bottom: 0,
                        right: -5,
                        height: 35,
                        width: 35,
                        child: RawMaterialButton(
                          onPressed: () async {
                            await controller.updateProfileImage();
                          },
                          elevation: 2.0,
                          fillColor: blueClr,
                          child: const Icon(
                            FontAwesomeIcons.pen,
                            color: whiteClr,
                            size: 15,
                          ),
                          // padding: const EdgeInsets.all(15.0),
                          shape: const CircleBorder(),
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GetBuilder(
                  init: ProfileController(),
                builder: (context) {
                  return Text(
                    controller.isLoading?"":controller.name,
                    style: Themes.header2.copyWith(color: blackClr),
                  );
                }
              ),
              GetBuilder(
                init: ProfileController(),
                builder:(_)=> Container(
                  width:double.infinity,
                  height:90,
                  child: Card(
                    semanticContainer: true,
                    color: blueClr,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        cardItem('Booked',controller.isLoading?"":'${controller.booked}',),
                        cardItem('My Halls',controller.isLoading?"":'${controller.myHalls}',),
                      ],
                    ),
                    elevation: 4,
                    shadowColor: blueClr,
                    margin: EdgeInsets.all(20),
                    shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: blueClr, width: 0)),
                  ),
                ),
              ),
              Container(
                width:double.infinity,
                height:90,
                child: Card(
                  color: Colors.white,
                  child: ListTile(
                    onTap: ()=> !controller.isLoading?Get.to(()=>EditProfile(title: "Name",type:"N")):(){},
                    title: Text("Name",style: Themes.header2.copyWith(
                        fontSize: 15,
                        color: Colors.black
                    ),),
                    trailing: Icon(FontAwesomeIcons.arrowRight,size: 15,color: Colors.black,),
                  ),
                  elevation: 0,
                  shadowColor: Colors.white,
                  margin: EdgeInsets.all(20),
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey, width: 1)),
                ),
              ),
              Container(
                width:double.infinity,
                height:90,
                child: Card(
                  color: Colors.white,
                  child: ListTile(
                    onTap:!controller.isLoading? ()=>Get.to(()=>EditProfile(title: "Email Address",type:"E")):(){},
                    title: Text("Email Address",style: Themes.header2.copyWith(
                        fontSize: 15,
                        color: Colors.black
                    ),),
                    trailing: Icon(FontAwesomeIcons.arrowRight,size: 15,color: Colors.black,),
                  ),
                  elevation: 0,
                  shadowColor: Colors.white,
                  margin: EdgeInsets.all(20),
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey, width: 1)),
                ),
              ),
              Container(
                width:double.infinity,
                height:90,
                child: Card(
                  color: Colors.white,
                  child: ListTile(
                    onTap: !controller.isLoading?()=>Get.to(()=>EditProfile(title: "Phone Number",type:"P")):(){},
                    title: Text("Phone Number",style: Themes.header2.copyWith(
                      fontSize: 15,
                      color: Colors.black
                    ),),
                    trailing: Icon(FontAwesomeIcons.arrowRight,size: 15,color: Colors.black,),
                  ),
                  elevation: 0,
                  shadowColor: Colors.white,
                  margin: EdgeInsets.all(20),
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey, width: 1)),
                ),
              ),
              Container(
                width:double.infinity,
                height:90,
                child: Card(
                  color: Colors.white,
                  child: ListTile(
                    onTap: !controller.isLoading?()=>Get.to(()=>EditProfile(title: "Password",type:"Pass")):(){},
                    title: Text("Password",style: Themes.header2.copyWith(
                        fontSize: 15,
                        color: Colors.black
                    ),),
                    trailing: Icon(FontAwesomeIcons.arrowRight,size: 15,color: Colors.black,),
                  ),
                  elevation: 0,
                  shadowColor: Colors.white,
                  margin: EdgeInsets.all(20),
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey, width: 1)),
                ),
              ),

            ],
        ),
      ),
          )),
    );
  }

  Column cardItem(String title,String number,) {
    return Column(
                    mainAxisAlignment:MainAxisAlignment.center,
                    children: [
                         Text(number,style: Themes.header2
                             .copyWith(color: Colors.white, fontSize: 14),),
                         Text(
                           title,
                          style: Themes.header2
                              .copyWith(color: Colors.white, fontSize: 14),
                        ),
                    ],
                  );
  }
}
