import 'package:flutter/material.dart';
import 'package:inventoryz/_Utils/transaction.dart';
import 'package:intl/intl.dart';

class DetailTransaction extends StatefulWidget {
  const DetailTransaction({super.key, required this.transaction});

  final Map<String, dynamic> transaction;

  @override
  State<DetailTransaction> createState() => _DetailTransactionState();
}

class _DetailTransactionState extends State<DetailTransaction> {
  List<Map<String, dynamic>> selectedProducts = [];
  Map<String, dynamic> transaction = {};

  final _numFormat = NumberFormat.decimalPattern('ID-id');

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  Future<void> _loadData() async {
    transaction = widget.transaction;
    selectedProducts = await Transaction.getDetailTransactionById(
      transaction["id"],
    );
    print(selectedProducts);
    setState(() => {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(transaction),
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
                        "The Transaction Didn't Have Product",
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
                                        "Rp. ${_numFormat.format(int.parse(transaction['total_price']))}",
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
                                                          enabled: false,
                                                          controller:
                                                              TextEditingController(
                                                                text:
                                                                    transaction["destination"],
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
                                                        ),
                                                        SizedBox(height: 10.0),
                                                        TextField(
                                                          enabled: false,
                                                          controller:
                                                              TextEditingController(
                                                                text:
                                                                    transaction["address"],
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
                                                                "input the warehouse address",
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
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  actions: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text(
                                                        "Close",
                                                        style: TextStyle(
                                                          fontSize: 18.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily: "Poppins",
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                          );
                                        },
                                        child: Text(
                                          "${transaction['destination']!.length >= 18 ? transaction['destination']!.substring(0, 18) : transaction['destination']}...",
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
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(4.0),
                                      // boxShadow: [BoxShadow(color: Colors.black)],
                                    ),
                                    margin: EdgeInsets.only(top: 10.0),
                                    padding: EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder:
                                              (_) => AlertDialog(
                                                title: Text("Coming Soon..."),
                                                content: Text("Coming Soon..."),
                                                actions: [
                                                  TextButton(
                                                    onPressed:
                                                        () => Navigator.pop(
                                                          context,
                                                        ),
                                                    child: Text("OK!"),
                                                  ),
                                                ],
                                              ),
                                        );
                                      },
                                      child: Text(
                                        "Delete Transaction",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
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
                      ],
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox productCard(Map<String, dynamic> product) {
    String name = product['name'];
    String price = product['price'];
    String qty = product['quantity'];
    String imageUrl = product['image_url'];
    return SizedBox(
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
    );
  }

  AppBar _appBar(var trasanction) {
    return AppBar(
      backgroundColor: Colors.blueAccent.shade700,
      title: Text(
        'Transaction - ${trasanction['id']}',
        style: TextStyle(
          fontSize: 18.5,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      leading: InkWell(
        onTap: () => Navigator.pop(context),
        child: Icon(Icons.arrow_back, size: 30.0, color: Colors.white),
      ),
    );
  }
}
