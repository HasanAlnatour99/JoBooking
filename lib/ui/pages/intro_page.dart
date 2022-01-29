import 'package:bookingme/ui/widgets/button.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme.dart';
import 'login_page.dart';
import 'sign_up_page.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      // appBar: const PreferredSize(child: NoLogoHeaderWidget(height: 240,), preferredSize: Size.fromHeight(200),),
      body: SafeArea(
        child: Center(
          child: Stack(
            children: [
              DelayedDisplay(
                  fadeIn: true,
                  slidingCurve: Curves.easeOut,
                  delay: Duration(milliseconds: 1800),
                  fadingDuration: Duration(seconds: 1),
                  child: Align(
                      alignment: Alignment(0, 0.8),
                      child: MyButton(
                        text: "Sign up",
                        onPressed: () {
                          Get.off( SignUpPage());
                        },
                        width: size.width * 0.85,
                      ))),
              DelayedDisplay(
                  fadeIn: true,
                  slidingCurve: Curves.easeOut,
                  delay: Duration(milliseconds: 1000),
                  fadingDuration: Duration(seconds: 1),
                  child: Align(
                      alignment: Alignment(0, 0.6),
                      child: MyButton(
                        text: "Login",
                        onPressed: () {
                          Get.off( LoginPage());
                        },
                        width: size.width * 0.85,
                      ))),
              Align(
                alignment: Alignment(0, -0.6),
                child: DelayedDisplay(
                  fadeIn: true,
                  slidingCurve: Curves.easeOut,
                  fadingDuration: Duration(seconds: 1),
                  child: Container(
                    width: size.width,
                    height: size.height * 0.5,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: Image.asset("assets/intro_photo.png").image),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NoLogoHeaderWidget extends StatelessWidget {
  final double height;

  const NoLogoHeaderWidget({Key? key, required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: MyCustomClipper(),
      child: Container(
        height: height,
        color: blueClr,
        child: Center(
          child: Container(
            width: double.infinity,
          ),
        ),
      ),
    );
  }
}

class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 150);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 150);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return false;
  }
}
