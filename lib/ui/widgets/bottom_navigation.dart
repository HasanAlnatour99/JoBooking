import 'package:bookingme/controllers/profile_controller.dart';
import 'package:bookingme/services/firestore_user.dart';
import 'package:bookingme/ui/pages/add_hall.dart';
import 'package:bookingme/ui/pages/contact_us.dart';
import 'package:bookingme/ui/pages/fav.dart';
import 'package:bookingme/ui/pages/hall_booking_section.dart';
import 'package:bookingme/ui/pages/homescreen.dart';
import 'package:bookingme/ui/pages/login_page.dart';
import 'package:bookingme/ui/pages/my_halls.dart';
import 'package:bookingme/ui/pages/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme.dart';

class BottomNavigation extends StatefulWidget {
   BottomNavigation({Key? key, required this.index}) : super(key: key);
  final  int index ;
  @override
  _BottomNavigationState createState() =>
      _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;
  var bottomTextStyle = GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500,height:2 );

  void _onItemTapped(int inx) {
    setState(() {
      _selectedIndex = inx;
    });
  }
  ProfileController controller = Get.put(ProfileController());

  static  final List _pages = [homescreen(), HallBookingSection()];
    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedIndex = widget.index;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
          backgroundColor: Colors.white,
          // appbar color.
          foregroundColor: Colors.black,
          elevation: 0.0,
          // appbar text color.
          centerTitle: true,
          title: Image.asset(
            'assets/joBooking.png',
            fit: BoxFit.contain,
            height: 45,
            width: 90,
          )),
      drawer: MainDrawer(),
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        height: 64,
        decoration: BoxDecoration(
          color: mFillColor,
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 15,
                offset: const Offset(0, 5))
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: _selectedIndex == 0
                  ? const Icon(FontAwesomeIcons.houseUser)
                  : const Icon(FontAwesomeIcons.home),
              title: Text(
                'Home',
                style: bottomTextStyle,
              ),
            ),

            BottomNavigationBarItem(
              icon: _selectedIndex == 1
                  ? const Icon(FontAwesomeIcons.calendarAlt)
                  : const Icon(FontAwesomeIcons.calendar),
              title: Text(
                'Bookings',
                style: bottomTextStyle,
              ),
            ),
          ],
          currentIndex:_selectedIndex,
          selectedItemColor: mBlueColor,
          unselectedItemColor: mSubtitleColor,
          onTap: _onItemTapped,
          backgroundColor: Colors.transparent,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 14,
          showUnselectedLabels: true,
          elevation: 0,
        ),
      ),
    );
  }

}
class MainDrawer extends StatelessWidget {
  MainDrawer({Key? key}) : super(key: key);
  ProfileController controller = Get.put(ProfileController());

  Widget buildlistTile(String title, IconData icon, Function() goto) {
    return ListTile(
        leading: Icon(
          icon,
          size: 28,
          color: blackClr,
        ),
        title: Text(
          title,
          style: Themes.header3
              .copyWith(color: blackClr, fontWeight: FontWeight.bold),
        ),
        onTap: goto);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.55,
      child: Drawer(
        child: ListView(
          children: [
            SizedBox(
              height: 100,
              child: DrawerHeader(
                  curve: Curves.elasticInOut,
                  padding: EdgeInsets.zero,
                  decoration: const BoxDecoration(
                    color: blueClr,
                  ),
                  child: GetBuilder(
                    init: ProfileController(),
                    builder: (_) => ListTile(
                      leading: CircleAvatar(
                        radius: 18,
                        child: controller.pic == ''
                            ? Image.asset(
                          "assets/userIcon.png",
                          fit: BoxFit.contain,
                        )
                            : Image.network(controller.pic,
                            fit: BoxFit.contain),
                        backgroundColor: Colors.transparent,
                      ),
                      title: Text(
                        controller.name.split(' ')[0],
                        style: Themes.header3,
                      ),
                      trailing: const Icon(
                        FontAwesomeIcons.arrowAltCircleRight,
                        color: Colors.white70,
                        size: 18,
                      ),
                      dense: true,
                      contentPadding: const EdgeInsets.all(20),
                      onTap: () {
                        Get.off(() => ProfilePage());
                      },
                    ),
                  )),
            ),
            const SizedBox(height: 20),
            buildlistTile("My Favourite", FontAwesomeIcons.heart, () {
              Get.off(() => Favscreen());
            }),
            buildlistTile("My Halls", FontAwesomeIcons.building, () {
              Get.off(() => MyHalls());
            }),
            buildlistTile("Add a hall", FontAwesomeIcons.plus, () {
              Get.off(() => AddHall());
            }),
            buildlistTile("Contact Us", FontAwesomeIcons.questionCircle, () {

              Get.off(() =>  SupportScreen());
            }),
            buildlistTile("Logout", Icons.logout, () async {
              UserSecureStorage.deleteUserToken();
              await FirebaseAuth.instance.signOut();
              Future<SharedPreferences> _prefs =
              SharedPreferences.getInstance();
              final SharedPreferences prefs = await _prefs;
              await prefs.clear();
              Get.off(() => LoginPage());
            })
          ],
        ),
      ),
    );
  }
}
