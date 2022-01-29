import 'dart:io';

import 'package:bookingme/controllers/hall_controller.dart';
import 'package:bookingme/ui/widgets/bottom_navigation.dart';
import 'package:bookingme/ui/widgets/button.dart';
import 'package:bookingme/ui/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';

import '../theme.dart';
import 'homescreen.dart';

class AddHall extends StatelessWidget {
  AddHall({Key? key}) : super(key: key);
  HallController controller = Get.put(HallController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    String dropdown;

    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        title: Text(
          "Add a hall",
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
        actions: [
          MyTextButton(
            onPressed: () => controller.postHall(context),
            text: 'Post',
            color: Colors.white,
            textSize: 16,

          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GetBuilder(
                init: HallController(),
                builder: (_) => SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Card(
                              color: blueClr,
                              child: MyIconButton(
                                width: double.infinity,
                                height: size.height * 0.1,
                                icon: FontAwesomeIcons.camera,
                                onPressed: () => controller.images.length == 10
                                    ? null
                                    : controller.pickMultiImages(),
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Card(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GridView.builder(
                                    itemCount: controller.images.length,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 5),
                                    shrinkWrap: true,
                                    reverse: true,
                                    padding: const EdgeInsets.all(2.0),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return SizedBox(
                                        height: 50,
                                        width: 50,
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            Image.file(
                                              File(controller
                                                  .images[index].path),
                                              fit: BoxFit.cover,
                                            ),
                                            MyIconButton(
                                              onPressed: () {
                                                controller.removePhoto(index);
                                              },
                                              icon: FontAwesomeIcons.trashAlt,
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                          margin: const EdgeInsets.only(
                            right: 7,
                            top: 4,
                          ),
                          alignment: Alignment.centerRight,
                          child: Text(
                            '${controller.images.length}/10',
                            style: Themes.header2
                                .copyWith(color: Colors.black, fontSize: 13),
                          )),
                      SingleChildScrollView(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          width: double.infinity,
                          height: size.height * 0.1,
                          child: InputField(
                            withBorder: false,
                            hintText: 'Write the name of the place',
                            controller: controller.titleController,
                            labelText: 'Name',
                            onChanged: (String value) {},
                            icon: FontAwesomeIcons.home,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        width: double.infinity,
                        // height: size.height * 0.2,
                        child: InputField(
                          textInputAction: TextInputAction.done,
                          withBorder: false,
                          keyboardType: TextInputType.multiline,
                          maxlines: 3,
                          hintText:
                              'Write down what features and benefits it will provide',
                          controller: controller.descController,
                          labelText: 'Description',
                          onChanged: (String value) {},
                          icon: FontAwesomeIcons.penSquare,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 12),
                        width: double.infinity,
                        child: GFCard(
                          margin: const EdgeInsets.all(0),
                          content: Column(
                            children: [
                              Container(
                                child: Text("Choose a price mechanism",
                                    style: Themes.header3.copyWith(
                                        fontSize: 13, color: Colors.black)),
                                alignment: Alignment.topLeft,
                              ),
                              const SizedBox(height: 7),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Row(
                                    children: [
                                      GFCheckbox(
                                        size: 22,
                                        activeBgColor: GFColors.SUCCESS,
                                        type: GFCheckboxType.circle,
                                        onChanged: (value) {
                                          controller.checkerBox(value, 1);
                                        },
                                        value: controller.isPerHour,
                                        inactiveIcon: null,
                                      ),
                                      Text(
                                        "  Per Hour",
                                        style: Themes.header3
                                            .copyWith(color: blackClr),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      GFCheckbox(
                                        size: 22,
                                        type: GFCheckboxType.circle,
                                        activeBgColor: GFColors.SUCCESS,
                                        onChanged: (value) {
                                          controller.checkerBox(value, 2);
                                        },
                                        value: controller.isPerDay,
                                      ),
                                      Text(
                                        "  Per Day",
                                        style: Themes.header3
                                            .copyWith(color: blackClr),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          controller.isPerHour
                              ? priceRow(
                              text: "Per Hour",
                              iconColor: GFColors.DANGER,
                              controller: controller.priceHourController)
                              : Container(),
                          controller.isPerDay
                              ? priceRow(
                              text: "Per Day",
                              iconColor: GFColors.SECONDARY,
                              controller: controller.priceDayController)
                              : Container(),
                        ],
                      ),
                      GFCard(
                        margin:const EdgeInsets.only(top: 10),
                        content:  Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              padding:const EdgeInsets.symmetric(horizontal: 0,vertical: 7),
                              child: Text('Do you have any conditions?',
                                  style: Themes.header2.copyWith(
                                      fontSize: 15, color: Colors.black)),
                            ),
                            Expanded(
                              child:  Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Row(
                                      children: [
                                        GFRadio(
                                          type: GFRadioType.blunt,
                                          size: 22,
                                          value: 0,
                                          groupValue: controller.groupValue,
                                          onChanged: (value) {
                                            controller.radioButton(value);
                                          },
                                          inactiveIcon:null,
                                            activeBorderColor: GFColors.DANGER,
                                            customBgColor: GFColors.DANGER,
                                        ),
                                        Text("  No"),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        GFRadio(
                                          autofocus: true,
                                          type: GFRadioType.blunt,
                                          size: 22,
                                          value: 1,
                                          groupValue: controller.groupValue,
                                          onChanged: (value) {
                                            controller.radioButton(value);
                                          },
                                          inactiveIcon: null,
                                          activeBorderColor: GFColors.SUCCESS,
                                          customBgColor: GFColors.SUCCESS,
                                        ),
                                        Text("  Yes"),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                      controller.groupValue==1?Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2,vertical: 0),
                        width: double.infinity,
                        // height: size.height * 0.2,
                        child: InputField(
                          textInputAction: TextInputAction.done,
                          withBorder: false,
                          keyboardType: TextInputType.multiline,
                          maxlines: 3,
                          hintText:
                          'Write what the conditions are.',
                          controller: controller.conditionController,
                          labelText: 'Conditions',
                          onChanged: (String value) {},
                          icon: FontAwesomeIcons.penSquare,
                        ),
                      ):Container(),
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
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
                              controller.addressDropDown(newValue);
                              controller.showPlaceF();
                            },
                            items: [
                              'Irbid', 'Zarqa', 'Mafraq', 'Ajloun', 'Jerash', 'Madaba', 'Balqa', 'Karak', 'Tafileh', 'Maan' , 'Aqaba',
                              'Amman',

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
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        width: double.infinity,
                        height: size.height * 0.1,
                        child: InputField(
                          withBorder: false,
                          hintText: 'ex.Shmeisani',
                          controller: controller.areaController,
                          labelText: 'Area',
                          onChanged: (String value) {},
                          icon: FontAwesomeIcons.mapMarker,
                        ),
                      ),
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(top: 10),
                        child: DropdownButtonHideUnderline(
                          child: GFDropdown(
                            padding: const EdgeInsets.all(15),
                            borderRadius: BorderRadius.circular(10),
                            border: const BorderSide(
                                color: Colors.black12, width: 1),
                            dropdownButtonColor: Colors.white,
                            value: controller.dropdownType,
                            onChanged: (newValue) {
                              controller.typeDropDown(newValue);
                            },
                            items: [
                              'Bowling', 'Studio', 'Gymnasium', 'Classroom',

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
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        width: double.infinity,
                        height: size.height * 0.1,
                        child: InputField(
                          textInputAction:TextInputAction.done ,
                          keyboardType: TextInputType.number,
                          withBorder: false,
                          hintText: '',
                          controller: controller.phoneController,
                          labelText: 'Mobile Number',
                          onChanged: (String value) {},
                          icon: FontAwesomeIcons.phone,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // const SizedBox(height:10),
            ],
          ),
        ),
      ),
    );
  }

   priceRow({iconColor, text, controller}) {
    return Container(
      width:130,
      height:100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              width: double.infinity,
              height: 100,
              child: InputField(
                textInputAction: TextInputAction.done,
                withBorder: false,
                keyboardType: TextInputType.phone,
                // hintText: 'Enter the price',
                controller: controller,
                labelText: 'Price',
                onChanged: (String value) {},
                icon: FontAwesomeIcons.solidMoneyBillAlt,
                iconColor: Colors.green,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              // padding: const EdgeInsets.all(20),
              alignment: Alignment.center,
              decoration:  const BoxDecoration(
                  color: Colors.white,
                  border:
                      Border(bottom: BorderSide(color: Colors.grey, width: 1))),
              // margin: EdgeInsets.all(20),
              child: Text(
                text,
                style: Themes.header2.copyWith(color: blackClr, fontSize: 14),
              ),
            ),
          )
        ],
      ),
    );
  }
}
