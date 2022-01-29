import 'package:bookingme/ui/widgets/searchbar.dart';
import 'package:flutter/material.dart';

class home extends StatefulWidget {
  @override
  _homeState createState() => _homeState();
}
class _homeState extends State<home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff3f5f9),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  searchbar(),
                  Padding(
                    padding: const EdgeInsets.only(top:5.0),
                    child: titletext("Top Rated",20),
                  ),
                  // Container(
                  //   height: 240,
                  //   child: ListView.builder(itemCount:topratedlist.length,scrollDirection: Axis.horizontal,itemBuilder: (context,index){
                  //     return topratedcard(hoteltdata: hotellist[index],);
                  //   }),
                  // ),
                ],
              ),
            ),
          ),
        ),
      
      
    );
  }

 

}

/*
Widget sectionCard (IconData icon, String title){
  
  return Padding(
    padding: const EdgeInsets.only(right:8.0,left: 8.0),
    child: Column(
      children: [
        Container(
          height:  70,
          width: 70,
          decoration: BoxDecoration(
            color:  Colors.grey,
            borderRadius: BorderRadius.circular(50),
            
          ),
          child: Icon(icon,color :Colors.indigo,size: 30,),
        )
     ,Padding(
       padding: const EdgeInsets.only(top:8.0),
       child: Text(title),
     )
      ],
    ),
  );
}*/