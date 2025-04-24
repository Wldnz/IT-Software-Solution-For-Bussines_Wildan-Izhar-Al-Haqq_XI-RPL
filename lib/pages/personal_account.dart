import 'dart:io';

import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/_Utils/account.dart';
import 'package:my_app/_Utils/env.dart';

class PersonalAccount extends StatefulWidget {
  const PersonalAccount({super.key});

  @override
  State<PersonalAccount> createState() => _PersonalAccountState();
}

class _PersonalAccountState extends State<PersonalAccount> {
  XFile? _image;
  File? _imagePath;
  Map<String, dynamic> account = {};
  @override
  void initState() {
    _loadData();
    super.initState();
  }

  Future<void> _loadData() async {
    account = await Account.getAccount();
    setState(() {
      account;
    });
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
    } catch (error) {}
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
    } catch (error) {}
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        await selectImageFromCamera();
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(5.0),
                                        width:
                                            MediaQuery.of(context).size.width -
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
                                            MediaQuery.of(context).size.width -
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
                                      image: NetworkImage(account['image_url']),
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
                    ],
                  ),
                ),
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
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: InkWell(
                  onTap: () async {
                    if (_image != null) {
                      var uploudImage = await Environment.cloudinary.upload(
                        file: _image!.path,
                        fileBytes: await _image!.readAsBytes(),
                        folder: 'inventoryz',
                        fileName: "profile - ${DateTime(20205).timeZoneName}",
                      );
                      account['image_url'] = uploudImage.secureUrl;
                    }
                    if (await Account.updateProfile(account)) {
                      await showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: Text(
                                'Sucessfully update profile',
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
                    'Save & Changes',
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
        ],
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
