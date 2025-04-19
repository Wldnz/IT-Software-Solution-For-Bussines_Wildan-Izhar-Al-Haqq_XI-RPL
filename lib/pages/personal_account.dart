import 'package:flutter/material.dart';
import 'package:my_app/_Utils/account.dart';

class PersonalAccount extends StatefulWidget {
  const PersonalAccount({super.key});

  @override
  State<PersonalAccount> createState() => _PersonalAccountState();
}

class _PersonalAccountState extends State<PersonalAccount> {
  Map<String,dynamic> account = {};

  @override
  void initState() {
    // TODO: implement initState
    _loadData();
    super.initState();
  }

  Future<void> _loadData() async {
    setState((){
      account = await Account.getAccount();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Personal Account Management',
          style: TextStyle(
            fontSize: 16.5,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: [
                Container(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 56,
                        child: ClipOval(
                          child: Icon(
                            Icons.account_circle,
                            size: 30,
                            color: Colors.blueAccent.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(child: Column(
                  spacing: 15.0,
                  children: [
                  _fieldPersonalAccount('name','Username',Icon(Icons.account_box_sharp),account),
                  _fieldPersonalAccount('fullname','Full Name',Icon(Icons.account_box_sharp),account),
                  _fieldPersonalAccount('email','Email',Icon(Icons.email_rounded),account),
                  _fieldPersonalAccount('phone','Phone',Icon(Icons.phone_enabled_rounded),account),
                  ])),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width - 30,
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.shade400,
                  borderRadius: BorderRadius.circular(10.0)
                ),
                child: InkWell(
                  onTap: () async{
                    print('Starting Save Account');
                    if(await Account.updateProfile(account)){
                      print('Succesfully update profile account');
                    }
                  },
                  child: Text('Save & Changes', style : TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    fontSize: 18.0
                  ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Column _fieldPersonalAccount(
    String fieldname,
    String fieldname1,
    Icon icon,
    Map<String,dynamic> account,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          fieldname1,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.normal,
            fontSize: 16.0,
          ),
        ),
        SizedBox(height: 5.5),
        TextField(
          controller: TextEditingController(text : account[fieldname]),
          decoration: InputDecoration(
            prefixIcon: icon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                style: BorderStyle.solid,
                color: Colors.black,
              ),
            ),
            contentPadding: EdgeInsets.only(
              top: 8.0,
              left: 10.0,
              right: 10.0,
              bottom: 8.0,
            ),
            hintText: "input your $fieldname here...",
            hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          onChanged: (String value) => account[fieldname] = value,
        ),
      ],
    );
  }
}
