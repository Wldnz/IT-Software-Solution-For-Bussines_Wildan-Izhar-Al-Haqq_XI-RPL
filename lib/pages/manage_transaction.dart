import 'package:flutter/material.dart';
import 'package:my_app/_Utils/transaction.dart';
import 'package:my_app/pages/add_transaction.dart';
import 'package:my_app/pages/edit_transaction.dart';

class ManageTransaction extends StatefulWidget {
  const ManageTransaction({super.key});

  @override
  State<ManageTransaction> createState() => _ManageTransactionState();
}

class _ManageTransactionState extends State<ManageTransaction> {
  var transaction = Transaction(0, 0, 0, 'uncompleted');
  var transactions = Transaction.getTransaction();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(transaction),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 200,
              child: FutureBuilder(
                future: transactions,
                builder: (context, snapShot) {
                  if (snapShot.connectionState == ConnectionState.waiting) {
                    return Center(child: Text('Fetching Data Transaction....'));
                  } else if (snapShot.hasError) {
                    return Center(child: Text('Error: ${snapShot.error}'));
                  } else if (!snapShot.hasData || snapShot.data!.isEmpty) {
                    return Center(
                      child: Text('Sorry,We cant provide any Transaction'),
                    );
                  } else {
                    List<Map<String, dynamic>> data = snapShot.data!;
                    return SizedBox(
                      width: 200.0,
                      height: 200.90,
                      child: Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              var product = data[index];
                              return InkWell(
                                child: productCard(
                                  BigInt.from(int.parse(product['created_at'])),
                                  int.parse(product['total_price']),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditTransaction(),
                                      settings: RouteSettings(
                                        arguments: product,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTransaction()),
          );
        },
        tooltip: 'Add Product',
        child: Icon(Icons.add),
      ),
    );
  }

  AppBar _appBar(Transaction transaction) {
    return AppBar(
      title: Text('Available Transaction'),
      centerTitle: true,
      elevation: 0.0,
      automaticallyImplyLeading: false,
      leading: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back, size: 30.0),
      ),
    );
  }

  Card productCard(BigInt createdAt, int totalPrice) {
    var date =
        DateTime.fromMillisecondsSinceEpoch(createdAt.toInt() * 1000).toLocal();
    return Card(
      color: const Color.fromARGB(255, 241, 240, 240),
      child: SizedBox(
        width: 180.0,
        child: Column(
          children: [
            Icon(Icons.list_alt_outlined, size: 100),
            Container(
              padding: EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  Text(
                    'Transaction created on $date',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Price : Rp. $totalPrice",
                        style: TextStyle(
                          fontSize: 16.0,
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
}
