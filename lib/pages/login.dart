import 'package:flutter/material.dart';
import 'package:my_app/_Utils/account.dart';
import 'package:my_app/pages/Dashboard.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _Login();
}

class _Login extends State<LoginPage> {
  // final account = Account();

  Map<String, String> loginData = {"email": "", "password": ""};

  @override
  void initState() {
    _isLogin();
    super.initState();
  }

  bool _isMatch = false;
  String _messageLogin = "";

  Future<void> _isLogin() async {
    var getAccount = await Account.getAccount();
    if (getAccount.isNotEmpty) {
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => Dashboard()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('Login Page')),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          children: [
            Column(
              spacing: 10.0,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 300.0,
                  color: Colors.blue.shade400,
                  child: Image(
                    image: AssetImage('assets/images/a.jpg'),
                    fit: BoxFit.fill,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 5.0,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 20,
                      child: Text(
                        'SIGN IN',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.lightBlueAccent[700],
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 20,
                      child: Text(
                        'Email',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 30,
                      padding: EdgeInsets.only(left: 20.0),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 230, 225, 225),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: TextField(
                        inputFormatters: [],
                        decoration: InputDecoration(
                          icon: Icon(Icons.email_rounded),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.only(
                            top: 8.0,
                            left: 10.0,
                            right: 10.0,
                            bottom: 8.0,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blueAccent,
                              width: 2.0,
                            ),
                          ),
                          hintText: "Input Your Email Address here...",
                          hintStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        onChanged: (String value) => loginData['email'] = value,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 20,
                      child: Text(
                        'Password',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 30,
                      padding: EdgeInsets.only(left: 20.0),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 230, 225, 225),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          icon: Icon(Icons.account_box_sharp),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.only(
                            top: 8.0,
                            left: 10.0,
                            right: 10.0,
                            bottom: 8.0,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blueAccent,
                              width: 2.0,
                            ),
                          ),
                          hintText: "Input Your Password here...",
                          hintStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        onChanged:
                            (String value) => loginData['password'] = value,
                      ),
                    ),
                  ],
                ),
                Text(
                  _messageLogin,
                  style: TextStyle(
                    fontSize: 16.0,
                    color:
                        _isMatch
                            ? Colors.blueAccent.shade400
                            : Colors.red.shade600,
                  ),
                ),
                InkWell(
                  child: Container(
                    width: MediaQuery.of(context).size.width - 30,
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.shade400,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(
                      'SIGN IN',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  onTap: () async {
                    bool isPassed = await Account.login(
                      loginData['email'] as String,
                      loginData['password'] as String,
                    );
                    setState(() {
                      _isMatch = isPassed;
                      _messageLogin =
                          isPassed
                              ? "Your Credentials is match!"
                              : "Your Credentials is not match!";
                    });
                    if (isPassed) {
                      Navigator.pushReplacement(
                        // ignore: use_build_context_synchronously
                        context,
                        MaterialPageRoute(builder: (context) => Dashboard()),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
