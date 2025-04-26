import 'package:flutter/material.dart';
import 'package:inventoryz/_Utils/account.dart';
import 'package:inventoryz/_Utils/env.dart';
import 'package:inventoryz/_Utils/history.dart';
import 'package:inventoryz/_Utils/transaction.dart';
import 'package:inventoryz/components/navigation.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var transactions = [];
  var activities = [];
  var totalStaff = "";
  var totalTransactionPrice = 0.0;
  bool showContent = false;

  @override
  void initState() {
    super.initState();
    _loadTransaction();
  }

  Future<void> _loadTransaction() async {
    transactions = await Transaction.getTransactionLast30Days();
    activities = await History.getHistorys();
    totalStaff = await Account.getTotalStaff();
    totalTransactionPrice = await Transaction.getTotalTrasanctionPrice();
    showContent = true;
    setState(() {});
  }

  int getTotalTransactionCompleted() {
    int totalTransactionCompleted = 0;
    for (int i = 0; i < transactions.length; i++) {
      if (transactions[i]['status'] == "completed") {
        totalTransactionCompleted += 1;
      }
    }
    return totalTransactionCompleted;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('hall0o')),
      body:
          !showContent
              ? Center(
                child: Text(
                  "Fetching data...",
                  style: TextStyle(color: Colors.blueAccent, fontSize: 30.0),
                ),
              )
              : Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 60),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Welcome Back, Wildan",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 20.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    // Text(
                    //   "We have build and show the statistic about the products and it will help your productivitas.",
                    //   style: TextStyle(
                    //     fontFamily: 'Poppins',
                    //     fontSize: 16.0,
                    //     fontWeight: FontWeight.normal,
                    //   ),
                    // ),
                    // SizedBox(height: 20.0),
                    transactions.isEmpty &&
                            activities.isEmpty &&
                            totalStaff.isEmpty
                        ? Center(child: Text('Fetching Data...'))
                        : SizedBox(
                          height: 140,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              statistic(transactions.length, 'Transaction'),
                              statistic(int.parse(totalStaff), 'Guard Account'),
                              statistic(activities.length, 'Activities'),
                            ],
                          ),
                        ),
                    SizedBox(
                      // height: 120.0,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 15.0,
                            left: 10.0,
                            right: 10.0,
                            bottom: 10.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Currently Balance",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.account_balance_wallet,
                                        color: Colors.blueAccent.shade400,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "Balance",
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.normal,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "Rp. ${Environment.numFormat.format(totalTransactionPrice)}",
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.check_box,
                                        color: Colors.blueAccent,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "Total Trasaction (Completed)",
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.normal,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "(${getTotalTransactionCompleted().toString()})",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      bottomNavigationBar: NavigationBottomAdmin(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        tooltip: 'Scan Transaction',
        backgroundColor: Colors.blueAccent.shade700,
        child: Icon(
          Icons.qr_code_scanner_sharp,
          size: 30.0,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Card statistic(int angka, String detailCard) {
    return Card(
      color: const Color.fromRGBO(30, 136, 229, .8),
      child: Container(
        padding: EdgeInsets.all(8),
        width: 180.0,
        // height: 120.0,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          // spacing: 10.0,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  detailCard,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Text(
              angka.toString(),
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Last 30 days",
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
