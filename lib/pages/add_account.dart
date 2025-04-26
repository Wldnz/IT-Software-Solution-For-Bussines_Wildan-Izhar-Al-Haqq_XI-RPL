import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inventoryz/_Utils/account.dart';
import 'package:inventoryz/_Utils/env.dart';

class AddAccount extends StatefulWidget {
  const AddAccount({super.key});

  @override
  State<AddAccount> createState() => _AddAccountState();
}

class _AddAccountState extends State<AddAccount> {
  XFile? _image;
  File? _imagePath;
  Map<String, dynamic> account = {
    "name": "",
    "fullname": "",
    "email": "",
    "phone": null,
    "password": "",
    "role": "staff",
  };

  String messageFailed = "";

  bool checkAllFieldIsFill() {
    var expectedField = [
      "name",
      "fullname",
      "email",
      "phone",
      "password",
      "role",
    ];
    for (int i = 0; i < expectedField.length; i++) {
      if (account[expectedField[i]].toString().isEmpty) {
        messageFailed = "Please fill all fields..";
        return false;
      }
    }
    messageFailed = "";
    return true;
  }

  Future<void> selectImageFromGallery() async {
    try {
      final XFile? selectedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (selectedImage == null) return;
      File filePath = File(selectedImage.path);
      setState(() {
        _image = selectedImage;
        _imagePath = filePath;
      });
    } catch (error) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text('Something Error When Opening Gallery...'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Close',
                    style: TextStyle(fontSize: 16.0, fontFamily: "Poppins"),
                  ),
                ),
              ],
            ),
      );
    }
  }

  Future<void> selectImageFromCamera() async {
    try {
      final XFile? selectedImage = await ImagePicker().pickImage(
        source: ImageSource.camera,
      );
      if (selectedImage == null) return;
      File filePath = File(selectedImage.path);
      setState(() {
        _image = selectedImage;
        _imagePath = filePath;
      });
    } catch (error) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text('Something Error When Opening Camera...'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Close',
                    style: TextStyle(fontSize: 16.0, fontFamily: "Poppins"),
                  ),
                ),
              ],
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent.shade700,
        title: Text(
          'Add Account',
          style: TextStyle(
            fontSize: 18.0,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height - 100,
              padding: EdgeInsets.all(20.0),
              child: ListView(
                children: [
                  SizedBox(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return SizedBox(
                                  width: double.infinity,
                                  height: 160.0,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          await selectImageFromCamera();
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(5.0),
                                          width:
                                              MediaQuery.of(
                                                context,
                                              ).size.width -
                                              30,
                                          height: 40.0,
                                          decoration: BoxDecoration(
                                            color: Colors.blueAccent.shade700,
                                            borderRadius: BorderRadius.circular(
                                              6.0,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.photo_camera,
                                                color: Colors.white,
                                                size: 20.0,
                                              ),
                                              SizedBox(width: 10.0),
                                              Text(
                                                'Take a photo',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.w600,
                                                  // fontFamily: 'Poppins',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      GestureDetector(
                                        onTap: () async {
                                          await selectImageFromGallery();
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(5.0),
                                          width:
                                              MediaQuery.of(
                                                context,
                                              ).size.width -
                                              30,
                                          height: 40.0,
                                          decoration: BoxDecoration(
                                            color: Colors.red.shade700,
                                            borderRadius: BorderRadius.circular(
                                              6.0,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.photo_camera,
                                                color: Colors.white,
                                                size: 20.0,
                                              ),
                                              SizedBox(width: 10.0),
                                              Text(
                                                'Uploud Photo',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.w600,
                                                  // fontFamily: 'Poppins',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: CircleAvatar(
                            radius: 56,
                            child: ClipOval(
                              child:
                                  _imagePath != null
                                      ? Image(
                                        image: FileImage(_imagePath as File),
                                        fit: BoxFit.cover,
                                        width: 250.0,
                                      )
                                      : account['image_url'] != null
                                      ? Image(
                                        image: NetworkImage(
                                          account['image_url'],
                                        ),
                                        fit: BoxFit.cover,
                                        width: 250.0,
                                      )
                                      : Icon(
                                        Icons.account_circle,
                                        size: 30,
                                        color: Colors.blueAccent.shade700,
                                      ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    child: Column(
                      spacing: 15.0,
                      children: [
                        _fieldPersonalAccount(
                          'name',
                          'Username',
                          Icon(Icons.account_box_sharp),
                          account,
                        ),
                        _fieldPersonalAccount(
                          'fullname',
                          'Full Name',
                          Icon(Icons.account_box_sharp),
                          account,
                        ),
                        _fieldPersonalAccount(
                          'email',
                          'Email',
                          Icon(Icons.email_rounded),
                          account,
                        ),
                        _fieldPersonalAccount(
                          'phone',
                          'Phone',
                          Icon(Icons.phone_enabled_rounded),
                          account,
                        ),
                        _fieldPersonalAccount(
                          'password',
                          'Password',
                          Icon(Icons.security_rounded),
                          account,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Role :",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16.0,
                                  ),
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width - 40,
                                  child: DropdownButton(
                                    menuWidth: 400.0,
                                    value: account['role'],
                                    items: [
                                      DropdownMenuItem(
                                        value: 'staff',
                                        child: Text('staff'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'admin',
                                        child: Text('admin'),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      account['role'] = value;
                                      setState(() => {});
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  messageFailed.isEmpty
                      ? Center()
                      : Text(
                        messageFailed,
                        style: TextStyle(
                          color: Colors.redAccent.shade700,
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal,
                        ),
                        textAlign: TextAlign.center,
                      ),
                  SizedBox(height: 10),
                  Container(
                    width: MediaQuery.of(context).size.width - 30,
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.shade400,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: InkWell(
                      onTap: () async {
                        if (!checkAllFieldIsFill()) {
                          setState(() => {});
                          return;
                        }
                        showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: Text("Creating Acount....."),
                                content: Text("Please Wait....."),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text(
                                      "Oke",
                                      style: TextStyle(fontSize: 16.0),
                                    ),
                                  ),
                                ],
                              ),
                        );
                        if (_image != null) {
                          var uploudImage = await Environment.cloudinary.upload(
                            file: _image!.path,
                            fileBytes: await _image!.readAsBytes(),
                            folder: 'inventoryz',
                            fileName:
                                "profile - ${DateTime(20205).timeZoneName}",
                          );
                          account['image_url'] = uploudImage.secureUrl;
                        } else {
                          account['image_url'] =
                              "https://static.vecteezy.com/system/resources/thumbnails/036/744/532/small_2x/user-profile-icon-symbol-template-free-vector.jpg";
                        }
                        if (await Account.addAccount(account)) {
                          await showDialog(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: Text(
                                    'Sucessfully Adding Account -${account['name']}',
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'OK',
                                        style: TextStyle(
                                          color: Colors.blue.shade700,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                          );
                          Navigator.pop(context);
                        } else {
                          await showDialog(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: Text(
                                    'Failed Adding Account -${account['name']}',
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text(
                                        'OK',
                                        style: TextStyle(
                                          color: Colors.blue.shade700,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                          );
                        }
                      },
                      child: Text(
                        'Create Account',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                          fontSize: 18.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column _fieldPersonalAccount(
    String fieldname,
    String fieldname1,
    Icon icon,
    Map<String, dynamic> account,
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
          controller: TextEditingController(text: account[fieldname]),
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
