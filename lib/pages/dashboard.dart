import 'package:flutter/material.dart';
import 'package:my_app/_Utils/Account.dart';
import 'package:my_app/_Utils/products.dart';
import 'package:my_app/_Utils/transaction.dart';
import 'package:my_app/components/navigation.dart';
import 'package:my_app/pages/productAdmin.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String name = 'wildan';

  int _currentIndex = 0;

  var transactions = [];

  @override
  void initState(){
    // TODO: implement initState
    _loadTransaction();
    super.initState();
  }

  Future<void> _loadTransaction() async {
    transactions = await Transaction.getTransactionLast30Days();
  }

  @override
  Widget build(BuildContext context){
    
    return Scaffold(
      // appBar: AppBar(title: Text('hall0o')),
      body: Container(
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
            SizedBox(
              height: 140,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  statistic(transactions.length, 'Transaction'),
                  statistic(5, 'Guard Account'),
                  statistic(300, 'Activities'),
                ],
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
