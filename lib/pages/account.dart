
import 'package:flutter/material.dart';
import 'package:my_app/components/navigation.dart';
import 'package:my_app/pages/addProduct.dart';
import 'package:my_app/pages/dashboard.dart';
import 'package:my_app/pages/manage_transaction.dart';
import 'package:my_app/pages/personal_account.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title : Text("Manage Account"),
        backgroundColor: Colors.blueAccent.shade400,
        toolbarHeight: 65.0,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20.0,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(
          top: 50.0,
        ),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            _card( Icon(Icons.account_circle_rounded, color: Colors.blueAccent.shade400, size: 60,), 'Manage Personal Account', PersonalAccount()),
            SizedBox(height: 50.0,),
            _card( Icon(Icons.account_circle_rounded, color: Colors.blueAccent.shade400, size: 60,), 'Manage Guard Account', AddProduct())
          ],
        ),
      ),
      bottomNavigationBar: NavigationBottomAdmin(),
      
    );
  }

  SizedBox _card(
    Icon icon,
    String name,
    StatefulWidget page,
  ) {
    return SizedBox(
            width: 340.0,
            height: 200.0,
            child: Card(
              child: InkWell(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => page)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    icon,
                    SizedBox(height: 20.0),
                    Text(name, style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      fontSize: 18.0
                    ),)
                  ],
                ),
              ),
            ),
          );
  }
}