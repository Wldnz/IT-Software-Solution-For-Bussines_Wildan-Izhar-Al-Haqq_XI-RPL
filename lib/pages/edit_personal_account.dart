
import 'package:flutter/material.dart';

class EditPersonalAccount extends StatefulWidget {
  const EditPersonalAccount({super.key});

  @override
  State<EditPersonalAccount> createState() => _EditPersonalAccountState();
}

class _EditPersonalAccountState extends State<EditPersonalAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar:AppBar(
        title: Text('Recently Activities Users', style: TextStyle(
          fontSize: 18.5,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold,
          color: Colors.white
        )),
    )
    );
  }
}