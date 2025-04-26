import 'package:cloudinary_url_gen/transformation/effect/effect_actions.dart';
import 'package:flutter/material.dart';
import 'package:inventoryz/_Utils/account.dart';
import 'package:inventoryz/_Utils/products.dart';
import 'package:inventoryz/_Utils/transaction.dart';
import 'package:intl/intl.dart';
import 'package:inventoryz/pages/manage_transaction.dart';

class AddTransaction extends StatefulWidget {
  const AddTransaction({super.key});

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  var transaction = Transaction(0, 0, 0, 'uncompleted');
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> selectedProducts = [];
  Map<String, String> warehouse = {
    "name": "PT Wildan Kusuma",
    "address": "Jalan Ambasador 31. Cendrawasih RT 07/13 12L",
  };
  final _numFormat = NumberFormat.decimalPattern('ID-id');
  bool showAlert = false;
  @override
  void initState() {
    _loadData();
    super.initState();
  }

  Future<void> _loadData() async {
    products = await Products.getProducts();
    setState(() => {});
  }

  bool findSameProduct(Map<String, dynamic> product) {
    for (int i = 0; i < selectedProducts.length; i++) {
      if (selectedProducts[i]['id'] == product['id']) {
        return true;
      }
    }
    return false;
  }

  void addProduct(Map<String, dynamic> product) {
    if (selectedProducts.isEmpty || !findSameProduct(product)) {
      selectedProducts.add(product);
      selectedProducts[selectedProducts.length - 1]['qty'] = 1.toString();
    } else {
      for (int i = 0; i < selectedProducts.length; i++) {
        if (selectedProducts[i]['id'] == product['id']) {
          if (int.parse(selectedProducts[i]['qty']) >=
              int.parse(selectedProducts[i]['stock'])) {
            selectedProducts[i]['qty'] = product['stock'];
          } else {
            selectedProducts[i]['qty'] =
                (int.parse(selectedProducts[i]['qty']) + 1).toString();
          }
        }
      }
    }
  }

  int getTotalPrice() {
    int totalPrice = 0;
    for (var product in selectedProducts) {
      totalPrice += int.parse(product['price']) * int.parse(product['qty']);
    }
    return totalPrice;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(showAlert),
      body: Container(
        // margin: EdgeInsets.only(top: 60.0),
        color: Color(0XDFDFDFDF),
        padding: EdgeInsets.all(10.0),
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'List Products',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey.shade400,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Container(
                            color: Colors.white,
                            height: MediaQuery.of(context).size.height - 100,
                            child: Column(
                              children: [
                                SizedBox(height: 5.0),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Choose The Product",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0,
                                          fontFamily: 'Poppins',
                                          color: Colors.blueAccent.shade200,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 50.0,
                                        height: 50.0,
                                        child: Card(
                                          color: Colors.red,
                                          child: Center(
                                            child: IconButton(
                                              color: Colors.white,
                                              onPressed:
                                                  () => Navigator.pop(context),
                                              icon: Icon(
                                                Icons.close,
                                                color: Colors.white,
                                                size: 25.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                products.isEmpty
                                    ? Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height -
                                            140,
                                        child: Center(
                                          child: Text(
                                            "(Fetching data)...\nPlease wait or you can Reopen this widget...",
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "Poppins",
                                              color: Colors.blueAccent,
                                              decoration: TextDecoration.none,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    )
                                    : SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height -
                                          120,
                                      child: ListView.builder(
                                        itemCount: products.length,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              addProduct(products[index]);
                                              showAlert = true;
                                              setState(() => {});
                                            },
                                            child: Container(
                                              width: 200.0,
                                              padding: EdgeInsets.all(10.0),
                                              margin: EdgeInsets.all(5.0),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Image(
                                                    image: NetworkImage(
                                                      products[index]['image_url'],
                                                    ),
                                                    width: 50.0,
                                                    height: 50.0,
                                                    fit: BoxFit.fill,
                                                  ),
                                                  SizedBox(width: 10.0),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        '${products[index]['name'].length > 30 ? products[index]['name'].substring(0, 25) : products[index]['name']}',
                                                        style: TextStyle(
                                                          fontFamily: 'Poppins',
                                                          fontSize: 17.0,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          overflow:
                                                              TextOverflow.fade,
                                                          color: Colors.black,
                                                          decorationColor:
                                                              Colors.white,
                                                        ),
                                                        softWrap: true,
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            MediaQuery.of(
                                                              context,
                                                            ).size.width -
                                                            100.0,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              'status : ${int.parse(products[index]['stock']) >= 5 ? "Good" : "Low"}',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontSize: 14.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w200,
                                                                color:
                                                                    int.parse(
                                                                              products[index]['stock'],
                                                                            ) >=
                                                                            5
                                                                        ? Colors
                                                                            .green
                                                                        : Colors
                                                                            .red
                                                                            .shade600,
                                                                decorationColor:
                                                                    Colors
                                                                        .white,
                                                              ),
                                                            ),
                                                            Text(
                                                              '${products[index]['stock']} Pcs',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontSize: 12.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    Colors
                                                                        .black,
                                                                shadows: [],
                                                                decorationColor:
                                                                    Colors
                                                                        .white,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Text(
                      'Add Product +',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.blue.shade700,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
              selectedProducts.isEmpty
                  ? Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 20,
                        height: MediaQuery.of(context).size.height / 2 - 100,
                      ),
                      Text(
                        "Add Product To Make Transaction",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Poppins",
                          color: Colors.blueAccent,
                        ),
                      ),
                    ],
                  )
                  : SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height - 170,
                    child: ListView(
                      children: [
                        ...selectedProducts.map(
                          (product) => Row(children: [productCard(product)]),
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width - 20,
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Summary Transaction",
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Total Product",
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.normal,
                                          fontFamily: "Poppins",
                                        ),
                                      ),
                                      Text(
                                        "${selectedProducts.length.toString()} Pcs",
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.normal,
                                          fontFamily: "Poppins",
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Total Price',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.normal,
                                          fontFamily: "Poppins",
                                        ),
                                      ),
                                      Text(
                                        "Rp. ${_numFormat.format(getTotalPrice())}",
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.normal,
                                          fontFamily: "Poppins",
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Destination',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.normal,
                                          fontFamily: "Poppins",
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder:
                                                (context) => AlertDialog(
                                                  title: Text("Shipping to"),
                                                  content: SizedBox(
                                                    child: Column(
                                                      children: [
                                                        TextField(
                                                          controller:
                                                              TextEditingController(
                                                                text:
                                                                    warehouse["name"],
                                                              ),
                                                          decoration: InputDecoration(
                                                            border:
                                                                OutlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                        width:
                                                                            0.5,
                                                                      ),
                                                                ),
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                        color:
                                                                            Colors.blueAccent,
                                                                        width:
                                                                            1.0,
                                                                      ),
                                                                ),
                                                            labelText:
                                                                "Warehouse Name",
                                                            hintText:
                                                                "input warehouse name",
                                                            hintStyle:
                                                                TextStyle(
                                                                  color:
                                                                      Colors
                                                                          .grey,
                                                                  fontSize:
                                                                      12.0,
                                                                ),
                                                            prefixIcon: Icon(
                                                              Icons.warehouse,
                                                            ),
                                                          ),
                                                          onChanged:
                                                              (String value) =>
                                                                  warehouse['name'] =
                                                                      value,
                                                        ),
                                                        SizedBox(height: 10.0),
                                                        TextField(
                                                          controller:
                                                              TextEditingController(
                                                                text:
                                                                    warehouse["address"],
                                                              ),
                                                          decoration: InputDecoration(
                                                            border:
                                                                OutlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                        width:
                                                                            0.5,
                                                                      ),
                                                                ),
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                        color:
                                                                            Colors.blueAccent,
                                                                        width:
                                                                            1.0,
                                                                      ),
                                                                ),
                                                            labelText:
                                                                "Address",
                                                            hintText:
                                                                "iinput the warehouse address",
                                                            hintStyle:
                                                                TextStyle(
                                                                  color:
                                                                      Colors
                                                                          .grey,
                                                                  fontSize:
                                                                      12.0,
                                                                ),
                                                            prefixIcon: Icon(
                                                              Icons.warehouse,
                                                            ),
                                                          ),
                                                          onChanged:
                                                              (String value) =>
                                                                  warehouse['address'] =
                                                                      value,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  actions: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            Navigator.pop(
                                                              context,
                                                            );
                                                          },
                                                          child: Text(
                                                            "Cancel",
                                                            style: TextStyle(
                                                              fontSize: 16.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontFamily:
                                                                  "Poppins",
                                                            ),
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            setState(() {});
                                                            Navigator.pop(
                                                              context,
                                                            );
                                                          },
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                  10.0,
                                                                ),

                                                            decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    4.0,
                                                                  ),
                                                              color:
                                                                  Colors
                                                                      .blueAccent
                                                                      .shade700,
                                                            ),
                                                            child: Text(
                                                              "Save",
                                                              style: TextStyle(
                                                                fontSize: 18.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontFamily:
                                                                    "Poppins",

                                                                color:
                                                                    Colors
                                                                        .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                          );
                                        },
                                        child: Text(
                                          "${warehouse['name']!.length >= 18 ? warehouse['name']!.substring(0, 18) : warehouse['name']}...",
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.blue.shade500,
                                            fontFamily: "Poppins",
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width - 10,
                                    decoration: BoxDecoration(
                                      color: Colors.blueAccent.shade700,
                                      borderRadius: BorderRadius.circular(4.0),
                                      // boxShadow: [BoxShadow(color: Colors.black)],
                                    ),
                                    margin: EdgeInsets.only(top: 10.0),
                                    padding: EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () async {
                                        showDialog(
                                          context: context,
                                          builder:
                                              (context) => AlertDialog(
                                                title: Text(
                                                  "Creating Trasanction....",
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed:
                                                        () => Navigator.pop(
                                                          context,
                                                        ),
                                                    child: Text(
                                                      "Oke",
                                                      style: TextStyle(
                                                        fontSize: 16.0,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                        );
                                        Map<String, dynamic> transaction = {
                                          "id_user":
                                              (await Account.getAccount())['id'],
                                          "total_price": getTotalPrice(),
                                          "destination": warehouse["name"],
                                          "address": warehouse["address"],
                                        };
                                        if (await Transaction.insertTrasanction(
                                          selectedProducts,
                                          transaction,
                                        )) {
                                          await showDialog(
                                            context: context,
                                            builder:
                                                (context) => AlertDialog(
                                                  title: Text(
                                                    "Succesfully Create Transaction",
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        Navigator.pop(context);
                                                        Navigator.pop(context);
                                                        Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    ManageTransaction(),
                                                          ),
                                                        );
                                                      },
                                                      child: Text(
                                                        "Oke",
                                                        style: TextStyle(
                                                          fontSize: 16.0,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                          );
                                        } else {
                                          await showDialog(
                                            context: context,
                                            builder:
                                                (context) => AlertDialog(
                                                  title: Text(
                                                    "Failed Create Transaction",
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed:
                                                          () => Navigator.pop(
                                                            context,
                                                          ),
                                                      child: Text(
                                                        "Oke",
                                                        style: TextStyle(
                                                          fontSize: 16.0,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                          );
                                        }
                                      },
                                      child: Text(
                                        "Create Transaction",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5.0),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Text(
                                      "Please make sure the product is correctly",
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.normal,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => {},
      //   child: Icon(Icons.check),
      // ),
    );
  }

  GestureDetector productCard(Map<String, dynamic> product) {
    String name = product['name'];
    String price = product['price'];
    String qty = product['qty'];
    String imageUrl = product['image_url'];
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Update - ${name.substring(0, 10)}...",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    SizedBox(
                      width: 50.0,
                      height: 50.0,
                      child: Card(
                        color: Colors.red,
                        child: Center(
                          child: IconButton(
                            color: Colors.white,
                            onPressed:
                                () => showDialog(
                                  context: context,
                                  builder:
                                      (context) => AlertDialog(
                                        title: Text(
                                          'Are you sure want remove the product from the order?',
                                        ),
                                        actions: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
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
                                                onPressed: () {
                                                  selectedProducts.remove(
                                                    product,
                                                  );
                                                  setState(() => {});
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  'Delete',
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                ),
                            icon: Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 25.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                content: SizedBox(
                  height: 200.0,
                  child: Column(
                    children: [
                      TextField(
                        controller: TextEditingController(text: qty),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(width: 0.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blueAccent,
                              width: 1.0,
                            ),
                          ),
                          labelText: "Quantity",
                          hintText: "input quantity product",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 12.0,
                          ),
                          prefixIcon: Icon(Icons.warehouse),
                        ),
                        onChanged: (String value) => product['qty'] = value,
                      ),
                    ],
                  ),
                ),
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
                          style: TextStyle(fontSize: 16.0, color: Colors.black),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          addProduct(product);
                          setState(() => {});
                          Navigator.pop(context);
                        },
                        child: Text('Save', style: TextStyle(fontSize: 16.0)),
                      ),
                    ],
                  ),
                ],
              ),
        );
      },
      child: SizedBox(
        width: 250.0,
        // height: 200.0,
        child: Card(
          margin: EdgeInsets.all(5.0),
          child: Wrap(
            spacing: 3.0,
            children: [
              Image(
                image: NetworkImage(imageUrl),
                height: 180.0,
                width: 250.0,
                fit: BoxFit.fill,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Rp. ${_numFormat.format(int.parse(price))}",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "$qty Quantity",
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _appBar(bool showAlert) {
    return AppBar(
      backgroundColor: Colors.blueAccent.shade700,
      title: Text(
        'Transactions',
        style: TextStyle(
          fontSize: 18.5,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      leading: InkWell(
        onTap: () {
          if (!showAlert) return Navigator.pop(context);
          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: Text('Are you sure want to leave?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Text('Yes'),
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
        child: Icon(Icons.arrow_back, size: 30.0, color: Colors.white),
      ),
    );
  }
}
