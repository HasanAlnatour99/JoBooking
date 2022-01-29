
import 'package:flutter/material.dart';

class searchbar extends StatelessWidget {
  const searchbar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 50,
        
        
        decoration: BoxDecoration(
          
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(25),
          border: Border.all()
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: "Find A Class  ",
              prefixIcon: Icon(Icons.search,color: Colors.indigo,),
              disabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}

Widget titletext (String title, double fontesize)
{
return                 Text(title,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: fontesize),);


}

