
import 'package:flutter/material.dart';

class NotFoundData extends StatelessWidget {
  const NotFoundData({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(image: AssetImage('assets/images/notfound.png'),height: 50,),
          SizedBox(height: 10,),
          Text("Sorry, We Couldn't found data...",style: TextStyle(
            fontFamily: "Poppins", 
            fontSize: 18.0,
            fontWeight: FontWeight.normal,
            color: Color.fromRGBO(255, 111, 0, 1),
          ),)
        ],
      ),
    );
  }
}