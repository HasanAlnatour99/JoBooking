import 'dart:io';

import 'package:bookingme/controllers/hall_controller.dart';
import 'package:bookingme/models/hall.dart';
import 'package:bookingme/ui/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';

import '../theme.dart';

class PromotionAdd extends StatefulWidget {
  const PromotionAdd({Key? key,required this.hallModel}) : super(key: key);
  final HallModel hallModel;

  @override
  State<PromotionAdd> createState() => _PromotionAddState();
}

class _PromotionAddState extends State<PromotionAdd> {
  HallController controller = Get.put(HallController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.switchPromos=widget.hallModel.promotion!;

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        title: Text(
          "Promotion",
          style: Themes.header2,
        ),
        centerTitle: true,
        backgroundColor: blueClr,
        leading: MyIconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icons.arrow_back,
          iconSize: 25,
          color: Colors.white,
        ),
      ),
      body:SafeArea(
        child: GetBuilder(
          init:HallController(),
          builder:(_)
          {
            return Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  height: 250,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      widget.hallModel.promotionImage! == '' &&
                              controller.promoImg == ''
                          ? GFCard(
                              color: Colors.white,
                              content: Container(),
                            )
                          : Container(
                              foregroundDecoration: const BoxDecoration(
                                color: Colors.black26,
                              ),
                              child: Image.network(
                                controller.promoImg == ''
                                    ? widget.hallModel.promotionImage!
                                    : controller.promoImg,
                                fit: BoxFit.cover,
                              )),
                      MyIconButton(
                        onPressed: () {
                          controller.PromotionImage(widget.hallModel.hallID, context);
                        },
                        icon: FontAwesomeIcons.camera,
                        iconSize: 30,
                        color: widget.hallModel.promotionImage! == '' &&
                                controller.promoImg == ''
                            ? Colors.black
                            : Colors.white,
                      ),
                      widget.hallModel.promotionImage! == '' &&
                              controller.promoImg == ''
                          ? Positioned(
                              top: 30,
                              left: 90,
                              child: Text(
                                "Add an image for the promotion",
                                style: Themes.mServiceTitleStyle,
                              ))
                          : Container(),
                    ],
                  ),
                ),
                GFCard(
                  margin: const EdgeInsets.all(0),
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Promotion status",
                          style: Themes.mServiceTitleStyle),
                      FlutterSwitch(
                        width: 90.0,
                        height: 40.0,
                        valueFontSize: 20.0,
                        toggleSize: 30.0,
                        value: controller.switchPromos,
                        borderRadius: 30.0,
                        padding: 8.0,
                        showOnOff: true,
                        onToggle: (val) {
                          controller.switchPromosFn(val, widget.hallModel.hallID,widget.hallModel.promotionImage,context);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ) ,
    );
  }
}
