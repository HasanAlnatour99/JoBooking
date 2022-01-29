import 'package:bookingme/controllers/hall_controller.dart';
import 'package:bookingme/models/hall.dart';
import 'package:bookingme/ui/widgets/button.dart';
import 'package:bookingme/ui/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../theme.dart';
import 'my_halls.dart';
import 'promotion_add.dart';

class HallDetail extends StatefulWidget {
  const HallDetail({Key? key, required this.hallModel}) : super(key: key);
  final HallModel hallModel;

  @override
  State<HallDetail> createState() => _HallDetailState();
}

class _HallDetailState extends State<HallDetail> {
  HallController c = Get.put(HallController());
   late TextEditingController nameController ;
  late TextEditingController descController ;
  late TextEditingController conditionsController ;
  late TextEditingController areaController ;
  late TextEditingController phoneController ;
  late TextEditingController priceHourController;
  late TextEditingController priceDayController;
  //
  // late TextEditingController nameController ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    priceHourController  = TextEditingController(text: widget.hallModel.price!['pricePerHour']??"");
    priceDayController  = TextEditingController(text: widget.hallModel.price!['pricePerDay']??"");
    nameController = TextEditingController(text: widget.hallModel.name);
    descController = TextEditingController(text:  widget.hallModel.description);
    conditionsController = TextEditingController(text:  widget.hallModel.conditions);
    areaController= TextEditingController(text:  widget.hallModel.address!.split(',')[0]);
    phoneController= TextEditingController(text:  widget.hallModel.phone);
    print(widget.hallModel.address!.split(',')[1]);
    c.addressDropDown(widget.hallModel.address!.split(',')[1].removeAllWhitespace);
    c.typeDropDown(widget.hallModel.type!.removeAllWhitespace);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    priceHourController.dispose();
    priceDayController.dispose();
    phoneController.dispose();
    nameController.dispose();
    descController.dispose();
    conditionsController.dispose();
    areaController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    int _currentIndex = 0;
    int index = 0;
    return GetBuilder(
      init: HallController(),
      builder:(_)=> Scaffold(
        appBar: AppBar(
          elevation: 3,
          title: Text(
            "Hall Details",
            style: Themes.header2,
          ),
          centerTitle: true,
          backgroundColor: blueClr,
          leading: MyIconButton(
            onPressed: () {
             c.edited==true? c.editToggle():null;
              Get.back();
            },
            icon: Icons.arrow_back,
            iconSize: 25,
            color: Colors.white,
          ),
          actions: [
            c.edited?IconButton(
              onPressed: (){
                c.editToggle();
                c.updateHall(context,area:areaController.text,conditions: conditionsController.text,description:descController.text ,
                    hallID:widget.hallModel.hallID ,name:nameController.text ,phone:phoneController.text ,
                    pricePerDay:c.isPerDay? priceDayController.text:"",
                    pricePerHour:c.isPerHour? priceHourController.text :"" );
              },
              icon: Icon(FontAwesomeIcons.save),
            ): PopupMenuButton(
              icon: const Icon(FontAwesomeIcons.ellipsisV,color: Colors.white,size:20),
              itemBuilder: (BuildContext context) =>[
                PopupMenuItem<int>(
                  value: 0,
                  child: const Text("Edit",style: TextStyle(color: Colors.black),),
                  onTap: ()=>c.editToggle(),
                ),
                PopupMenuItem<int>(
                  value: 1,
                  child:const Text("Delete",style: TextStyle(color: Colors.black),),
                  onTap: ()  {},
                ),
                PopupMenuItem<int>(
                  value: 2,
                  child:const Text("Promotion",style: TextStyle(color: Colors.black),),
                  onTap: () {},
                )
              ],
              onSelected: (item) {
                if(item==1){
                  c.removeHall(widget.hallModel.hallID,context);
                }
                if(item==2){
                  Get.to(PromotionAdd(hallModel: widget.hallModel,));
                }
              },
            ),
          ],
        ),

        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  child: CarouselSlider(
                    options: CarouselOptions(
                      autoPlay: false,
                      pauseAutoPlayOnTouch: true,
                      pageSnapping: true,
                      enableInfiniteScroll: false,

                      // enlargeCenterPage: true,
                      //scrollDirection: Axis.vertical,
                      onPageChanged: (index, reason) {
                        print(reason);
                        setState(
                          () {
                            c.currentIndex.value = index;
                          },
                        );
                      },
                    ),
                    items: widget.hallModel.images!
                        .map(
                          (item) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              margin: const EdgeInsets.only(
                                top: 10.0,
                                bottom: 10.0,
                              ),
                              elevation: 6.0,
                              shadowColor: blueClr,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(30.0),
                                ),
                                child: Stack(
                                  children: <Widget>[
                                    Image.network(
                                      item,
                                      fit: BoxFit.contain,
                                      width: double.infinity,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: widget.hallModel.images!.map((urlOfItem) {
                    int index = widget.hallModel.images!.indexOf(urlOfItem);
                    return Obx(
                      () => Container(
                        width: 6.0,
                        height: 6.0,
                        margin: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 2.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: c.currentIndex.value == index
                              ? mBlueColor
                              : mGreyColor,
                        ),
                      ),
                    );
                  }).toList(),
                ),

                GFCard(
                  margin: EdgeInsets.all(0),
                  content: Container(
                      alignment: Alignment.centerLeft,
                      child: c.edited?TextField(
                        controller: nameController,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration.collapsed(hintText: 'Name'),
                      ):Text("${widget.hallModel.name}")),
                ),
                GFCard(
                    margin: EdgeInsets.all(3),
                    padding: EdgeInsets.all(15),
                    title: GFListTile(
                      padding: EdgeInsets.all(0),
                      margin: EdgeInsets.all(0),
                      title: Text(
                        "Description",
                        style: Themes.header2
                            .copyWith(color: Colors.black, fontSize: 15),
                      ),
                    ),
                    titlePosition: GFPosition.start,
                    content: c.edited?TextField(
                      minLines: 1,
                      maxLines: 3,
                      textInputAction: TextInputAction.done,
                      controller: descController,
                      decoration: InputDecoration.collapsed(hintText: 'Description',),
                    ):Text("${widget.hallModel.description}")),
                GFCard(
                    margin: EdgeInsets.all(3),
                    padding: EdgeInsets.all(15),
                    title: GFListTile(
                      padding: EdgeInsets.all(0),
                      margin: EdgeInsets.all(0),
                      title: Text(
                        "Conditions",
                        style: Themes.header2
                            .copyWith(color: Colors.black, fontSize: 15),
                      ),
                    ),
                    titlePosition: GFPosition.start,
                    content: Container(
                        alignment: Alignment.centerLeft,
                        child:  c.edited?TextField(
                          textInputAction: TextInputAction.done,
                          controller: conditionsController,
                          minLines: 1,
                          maxLines: 2,
                          decoration: InputDecoration.collapsed(hintText: 'Conditions'),
                        ):Text("${widget.hallModel.conditions}"))),
                c.edited?Column(
                  children: [
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
                          value: c.dropdownValue,
                          onChanged: (newValue) {
                            c.addressDropDown(newValue);
                            print("A");
                            c.showPlaceF();
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
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: InputField(
                        withBorder: false,
                        hintText: 'ex.Shmeisani',
                        controller: areaController,
                        labelText: 'Area',
                        onChanged: (String value) {

                        },
                        icon: FontAwesomeIcons.mapMarker,
                      ),
                    ),
                  ],
                ):GFCard(
                    margin: EdgeInsets.all(3),
                    padding: EdgeInsets.all(15),
                    title: GFListTile(
                      padding: EdgeInsets.all(0),
                      margin: EdgeInsets.all(0),
                      title: Text(
                        "Address",
                        style: Themes.header2
                            .copyWith(color: Colors.black, fontSize: 15),
                      ),
                    ),
                    titlePosition: GFPosition.start,
                    content: Container(
                        alignment: Alignment.centerLeft,
                        child: Text("${widget.hallModel.address}"))),

                c.edited? Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: InputField(
                    textInputAction:TextInputAction.done ,
                    keyboardType: TextInputType.number,
                    withBorder: false,
                    hintText: '',
                    controller: phoneController,
                    labelText: 'Mobile Number',
                    onChanged: (String value) {},
                    icon: FontAwesomeIcons.phone,
                  ),
                ):GFCard(
                    margin: EdgeInsets.all(3),
                    padding: EdgeInsets.all(15),
                    title: GFListTile(
                      padding: EdgeInsets.all(0),
                      margin: EdgeInsets.all(0),
                      title: Text(
                        "Mobile Number",
                        style: Themes.header2
                            .copyWith(color: Colors.black, fontSize: 15),
                      ),
                    ),
                    titlePosition: GFPosition.start,
                    content: Container(
                        alignment: Alignment.centerLeft,
                        child: Text("${widget.hallModel.phone}"))),
               c.edited?Container(): GFCard(
                    margin: EdgeInsets.all(0),
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("Visited:   ${widget.hallModel.visitors}",style: Themes.header2
                            .copyWith(color: Colors.black, fontSize: 13),),
                        Container(color: Colors.black45, height: 15, width: 2,),
                        Text("Rated:   ${double.parse(widget.hallModel.rated!) !=
                            0.0 ||
                            double.parse(widget.hallModel.rated!) >=
                                1
                            ? double.parse(widget.hallModel.rated!)
                            .toStringAsFixed(1)
                            : "New"}",style:  Themes.header2
                            .copyWith(color: Colors.black, fontSize: 13),),
                      ],
                    )),
                c.edited?Container(
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
                      value: c.dropdownType,
                      onChanged: (newValue) {
                        c.typeDropDown(newValue);
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
                ):Container(),
               c.edited?
                   Column(
                     children: [
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
                                         activeBgColor: GFColors.DANGER,
                                         type: GFCheckboxType.circle,
                                         onChanged: (value) {
                                           c.checkerBox(value, 1);
                                         },
                                         value: c.isPerHour,
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
                                         activeBgColor: GFColors.SECONDARY,
                                         onChanged: (value) {
                                           c.checkerBox(value, 2);
                                         },
                                         value: c.isPerDay,
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
                           c.isPerHour
                               ? priceRowEdit(
                               text: "Per Hour",
                               iconColor: GFColors.DANGER,
                               controller: priceHourController)
                               : Container(),
                           c.isPerDay
                               ? priceRowEdit(
                               text: "Per Day",
                               iconColor: GFColors.SECONDARY,
                               controller: priceDayController)
                               : Container(),
                         ],
                       ),
                     ],
                   )
                   : Row(
                  children: [
                    widget.hallModel.price!['pricePerHour'] != ''
                        ? priceRow(
                            text: "${widget.hallModel.price!['pricePerHour']}",
                            iconColor: GFColors.DANGER,
                            type: 'Per Hour')
                        : Container(),
                    widget.hallModel.price!['pricePerDay'] != ''
                        ? priceRow(
                            text: "${widget.hallModel.price!['pricePerDay']}",
                            iconColor: GFColors.SECONDARY,
                            type: 'Per Day')
                        : Container(),
                    widget.hallModel.price!['pricePerWeek'] != ''
                        ? priceRow(
                            text: "${widget.hallModel.price!['pricePerWeek']}",
                            iconColor: GFColors.SUCCESS,
                            type: 'Per Week')
                        : Container(),
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
  priceRowEdit({iconColor, text, controller}) {
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
                icon:  FontAwesomeIcons.solidMoneyBillAlt,
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
  priceRow({iconColor, text, type}) {
    return Container(
      width: 130,
      height: 100,
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
              child: InputFieldRead(
                readOnly: true,
                intialValue: text,
                textInputAction: TextInputAction.done,
                withBorder: false,
                keyboardType: TextInputType.phone,
                hintText: text == '' ? '0' : text,
                labelText: 'Price',
                onChanged: (String value) {},
                icon:  FontAwesomeIcons.solidMoneyBillAlt,
                iconColor: Colors.green,
                controller: null,
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
              decoration: const BoxDecoration(
                  color: Colors.white,
                  border:
                      Border(bottom: BorderSide(color: Colors.grey, width: 1))),
              // margin: EdgeInsets.all(20),
              child: Text(
                type,
                style: Themes.header2.copyWith(color: blackClr, fontSize: 14),
              ),
            ),
          )
        ],
      ),
    );
  }
}
