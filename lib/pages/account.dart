import 'package:flutter/material.dart';
import 'package:inventoryz/components/navigation.dart';
import 'package:inventoryz/pages/add_account.dart';
import 'package:inventoryz/pages/login.dart';
import 'package:inventoryz/pages/personal_account.dart';
import 'package:inventoryz/_Utils/account.dart' as akun;

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
        title: Text("Manage Account"),
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
        // margin: EdgeInsets.only(top: 50.0),
        padding: EdgeInsets.all(10.0),
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _card(
                Icon(
                  Icons.account_circle_rounded,
                  color: Colors.blueAccent.shade400,
                  size: 60,
                ),
                'Manage Personal Account',
                PersonalAccount(),
              ),
              SizedBox(height: 20.0),
              _card(
                Icon(
                  Icons.account_circle_rounded,
                  color: Colors.blueAccent.shade400,
                  size: 60,
                ),
                "Manage Guard Account (Can't Access Right Now)",
              ),
              SizedBox(height: 20.0),
              _cardLogout(
                Icon(
                  Icons.login_outlined,
                  color: Colors.blueAccent.shade400,
                  size: 60,
                ),
                "Log Out?",
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBottomAdmin(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddAccount()),
          );
        },
        tooltip: 'Add Account',
        child: Icon(Icons.add),
      ),
    );
  }

  SizedBox _card(Icon icon, String name, [page]) {
    return SizedBox(
      width: 340.0,
      height: 200.0,
      child: Card(
        child: InkWell(
          onTap:
              page != null
                  ? () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => page),
                  )
                  : () => {},
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              icon,
              SizedBox(height: 20.0),
              Text(
                name,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  fontSize: 18.0,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox _cardLogout(Icon icon, String name) {
    return SizedBox(
      width: 340.0,
      height: 200.0,
      child: Card(
        child: InkWell(
          onTap: () async {
            showDialog(
              context: context,
              builder:
                  (context) => AlertDialog(
                    title: Text("Are you sure want to sign out?"),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              await akun.Account.logout();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginPage(),
                                ),
                              );
                              // Navigator.pop(context);
                            },
                            child: Text(
                              'Sign Out',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              icon,
              SizedBox(height: 20.0),
              Text(
                name,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  fontSize: 18.0,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
