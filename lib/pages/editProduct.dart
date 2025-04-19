import 'dart:ffi';
import 'dart:io';

import 'package:cloudinary/cloudinary.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/_Utils/Products.dart';
import 'package:my_app/_Utils/env.dart';
import 'package:my_app/_Utils/product.dart';


class EditProduct extends StatefulWidget {
  const EditProduct({super.key});

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  XFile? _image;
  File? _imagePath;

  Map<String, dynamic> product = {};

  final cloudinary = Environment.cloudinary;

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
        product['image'] = filePath;
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    product = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      appBar: _appBar(product),
      body: ListView(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: [
                SizedBox(height: 20.0),
                Container(
                  width: MediaQuery.of(context).size.width / 2 + 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 10.0,
                    children: [
                      if (_imagePath != null || product['image'] is File)
                        Image.file(
                          _imagePath ?? product['image'] as File,
                          width: 200.0,
                          height: 200.0,
                          fit: BoxFit.fill,
                        )
                      else
                        Image(
                          width: 200.0,
                          height: 200.0,
                          fit: BoxFit.fill,
                          // image: NetworkImage(
                          //   'https://th.bing.com/th/id/OIP.Jz2BJwvfO-i0PdEz_YO78QHaE8?rs=1&pid=ImgDetMain',
                          // ),
                          image: NetworkImage(product['image_url']),
                        ),
                      InkWell(
                        onTap: () => selectImageFromGallery(),
                        child: Container(
                          padding: EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade900,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          // width: 200.0,
                          child: Text(
                            'Change Image',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 18.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Column(
                  spacing: 20.0,
                  children: [
                    textFieldProduct(context, 'Name', 'Product Name', product),
                    textFieldProduct(
                      context,
                      'Description',
                      'Description',
                      product,
                    ),
                    textFieldProduct(
                      context,
                      'Price',
                      'Price',
                      product,
                      Icon(
                        Icons.payments_rounded,
                        color: Colors.green,
                        weight: 800,
                      ),
                    ),
                    textFieldProduct(
                      context,
                      'Stock',
                      'Stock',
                      product,
                      Icon(
                        Icons.adjust_outlined,
                        color:
                            int.parse(product['stock']) >= 3
                                ? (int.parse(product['stock']) >= 5
                                    ? Colors.green
                                    : Colors.yellow)
                                : Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 50,)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Save Product',
        onPressed: () {
          showDialog(
            context: context,
            builder:
                (ctx) => AlertDialog(
                  title: Text('Are You Sure Want To Change?'),
                  content: Text('If you sure, please wait a few seconds (it depends on your internet)'),
                  actions: [
                    TextButton(
                      onPressed: () async{
                        Navigator.of(ctx).pop();
                        if(_image != null){
                          try{
                            var uploudImage = await cloudinary.upload(
                            file: _image!.path,
                            fileBytes: await _image!.readAsBytes(),
                            folder: 'inventoryz',
                            fileName: DateTime(20205).timeZoneName + _image!.name,
                          );
                          print('berhasil');
                          product['image_url'] = uploudImage.secureUrl;
                          }catch(error){
                            print(error);
                          }
                        }                       
                        if(await Products.updateProduct(product)){
                          print('Succesfully');
                        }
                      },
                      child: Text('Save'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancel'),
                    ),
                  ],
                ),
          );
        },
        backgroundColor: Colors.blueAccent.shade400,
        child: Icon(Icons.check, weight: 800.0, color: Colors.white),
      ),
    );
  }

  Container textFieldProduct(
    BuildContext context,
    String fieldName,
    String hintText,
    Map<String, dynamic> product, [
    icon,
  ]) {
    return Container(
      width: MediaQuery.of(context).size.width - 30,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            fieldName,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              fontSize: 20,
            ),
          ),
          SizedBox(height: 4),
          SizedBox(
            width: MediaQuery.of(context).size.width - 60,
            child: TextField(
              controller: TextEditingController(
                text: product[fieldName.toLowerCase()].toString(),
              ),
              keyboardType:
                  fieldName.toLowerCase() == "stock" || fieldName.toLowerCase() == "price"
                      ? TextInputType.number
                      : TextInputType.text,
              decoration: InputDecoration(
                icon: icon,
                border: OutlineInputBorder(borderSide: BorderSide(width: 1.5)),
                contentPadding: EdgeInsets.only(
                  top: 8.0,
                  left: 10.0,
                  right: 10.0,
                  bottom: 8.0,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                ),
                hintText: "$hintText here...",
                hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
              onChanged: (String value) {
                if (product[fieldName.toLowerCase()] is int) {
                  product[fieldName.toLowerCase()] =
                      int.parse(value) > 1 ? int.parse(value) : 0;
                } else {
                  product[fieldName.toLowerCase()] = value;
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  AppBar _appBar(Map<String, dynamic> product) {
    return AppBar(
      title: Text(product['name']),
      centerTitle: true,
      elevation: 0.0,
      actions: [
        InkWell(
          child: Container(
            margin: EdgeInsets.only(right: 10.0),
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              color: Colors.red.shade600,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Icon(Icons.delete, color: Colors.white),
          ),
          onTap: () async{
            showDialog(context: context, builder: (context) => AlertDialog(
              title: Text('Are You Sure Want To Delete That'),
              content: Text('Please wait for a few seconds...'),
              actions: [
                TextButton(
                      onPressed: () async{
                        Navigator.of(context).pop();
                        Products.deleteProduct(product['id']);
                        Navigator.pop(context);
                      },
                      child: Text('Delete'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancel'),
                    ),
              ],
            ));
          },
        ),
      ],
    );
  }
}
