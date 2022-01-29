import 'package:bookingme/ui/widgets/bottom_navigation.dart';
import 'package:bookingme/ui/widgets/button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../theme.dart';


class SupportScreen extends StatefulWidget {
  SupportScreen({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();

  @override
  _SupportScreenState createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  TextEditingController _titleCtrl = TextEditingController();
  TextEditingController _descriptionCtrl = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _titleCtrl = TextEditingController();
    _descriptionCtrl = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _titleCtrl.dispose();
    _descriptionCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    String subject = '';
    String desc = '';
    return Scaffold(
      backgroundColor: const Color(0xFFdfe3ee),
      appBar: buildAppBar(context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 1.2,
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 1.4,
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.blueGrey,
                            offset: Offset(5, 5),
                            blurRadius: 10)
                      ],
                      color: const Color(0xFFf7f7f7),
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    padding: const EdgeInsets.only(left: 15, right: 0,top: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            RichText(
                              softWrap: true,
                              text: const TextSpan(children: [
                                TextSpan(
                                  text: "Need Support?\n\n",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      "We've got your back\nGet in touch with a friendly member of our team",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ]),
                            ),

                          ],
                        ),
                        Container(
                            margin: const EdgeInsets.only(
                                left: 20, right: 35, top: 30),
                            child: Form(
                              key: widget._formKey,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  TextFormField(
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(70)
                                    ],
                                    controller: _titleCtrl,
                                    validator: (val) {
                                      if (val!.isEmpty) {
                                        return "Title is required";
                                      }
                                    },
                                    onSaved: (val){
                                      setState(() {
                                        subject = val!;
                                      });
                                      _titleCtrl.clear();
                                    },
                                    decoration: InputDecoration(
                                        labelStyle:
                                            const TextStyle(fontSize: 18),
                                        hintStyle:
                                            const TextStyle(fontSize: 14),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        prefixIcon: const Icon(
                                          Icons.border_color,
                                          size: 20,
                                        ),
                                        labelText: "Subject",
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            borderSide: const BorderSide(
                                                color: Colors.grey)),
                                        hintText:
                                            "Write the title of your subject"),
                                    textInputAction: TextInputAction.next,
                                  ),
                                  const SizedBox(height: 30),
                                  TextFormField(
                                    maxLength: 600,
                                    onSaved: (val){
                                      setState(() {
                                        desc = val!.trimLeft();
                                      });
                                      _descriptionCtrl.clear();
                                    },
                                    validator: (val){
                                      if(val!.isEmpty){
                                        return "The description is required";
                                      }
                                      if(val.length<100){
                                        return "The description must be more than 100 characters";
                                      }
                                    },
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(600)
                                    ],
                                    controller: _descriptionCtrl,
                                    textInputAction: TextInputAction.done,
                                    maxLines: 5,
                                    decoration: InputDecoration(
                                      labelStyle: const TextStyle(fontSize: 18),
                                      hintStyle: const TextStyle(fontSize: 14),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: const BorderSide(
                                              color: Colors.grey)),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      floatingLabelStyle:
                                          const TextStyle(fontSize: 19),
                                      labelText: "Description",
                                      hintText:
                                          "Tell us more about your subject",
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        const SizedBox(height:50),
                         MyButton(
                            text: 'Submit',
                            onPressed: () async {
                              if (!widget._formKey.currentState!.validate()) {
                                return;
                              } else {
                                widget._formKey.currentState!.save();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    elevation: 4,
                                    backgroundColor:  blueClr,
                                    content: SizedBox(
                                      height: 50,
                                      child: ListTile(
                                        dense: true,
                                        leading: Icon(
                                          Icons.feedback_rounded,
                                          color: Colors.white,
                                        ),
                                        // contentPadding: EdgeInsets.symmetric(
                                        //     horizontal: 10, vertical: 10),
                                        title: Text("Thank You for Your Feedback",
                                          style: TextStyle(
                                            color: Colors.white,
                                            letterSpacing: 0.3,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                                await FirebaseFirestore.instance.collection("support").add({
                                  'subject':subject,
                                  'desc':desc,
                                  'email':_auth.currentUser!.email,
                                });
                              }
                            },
                          )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return  AppBar(
    elevation: 3,
    title: Text(
    'Contact Us',
    style: Themes.header2.copyWith(
    color: Colors.white,
    ),
    ),
    centerTitle: true,
    backgroundColor: blueClr,
    leading: MyIconButton(
    onPressed: () => Get.off(() => BottomNavigation(index: 0)),
    icon: Icons.arrow_back,
    iconSize: 25,
    color: Colors.white,),
    );
  }
}
