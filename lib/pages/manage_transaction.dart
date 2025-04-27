import 'package:flutter/material.dart';
import 'package:inventoryz/_Utils/env.dart';
import 'package:inventoryz/_Utils/transaction.dart';
import 'package:inventoryz/components/filter_dialog_transaction.dart';
import 'package:inventoryz/pages/add_transaction.dart';
import 'package:inventoryz/pages/detail_transaction.dart';

class ManageTransaction extends StatefulWidget {
  const ManageTransaction({super.key});

  @override
  State<ManageTransaction> createState() => _ManageTransactionState();
}

class _ManageTransactionState extends State<ManageTransaction> {
  List<Map<String, dynamic>> transactions = [];
  int valueOrderBy = 3;
  bool isGetDataTransactions = false;
  Map<String, dynamic> selectedFilter = {
    "status": "",
    "price": "",
    "created_at": "",
  };
  @override
  void initState() {
    _loadData();
    super.initState();
  }

  Future<void> _loadData() async {
    transactions = await Transaction.getTransactionLast30Days();
    isGetDataTransactions = true;
    setState(() => {});
  }

  Future<void> changeOrderBy() async {
    var orderBy = valueOrderBy > 2 ? "created_at" : "total_price";
    orderBy += (valueOrderBy % 2) == 0 ? " ASC" : " DESC";
    transactions = await Transaction.getTransactionLast30Days(orderBy);
    isGetDataTransactions = true;
    setState(() => {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Container(
        padding: EdgeInsets.all(10.0),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  spacing: 5.0,
                  children: [
                    Text('Order By :'),
                    DropdownButton(
                      value: valueOrderBy,
                      items: [
                        DropdownMenuItem(
                          value: 1,
                          child: Text('Highest Price'),
                        ),
                        DropdownMenuItem(value: 2, child: Text('Lowest Price')),
                        DropdownMenuItem(
                          value: 3,
                          child: Text('Recently Created'),
                        ),
                        DropdownMenuItem(value: 4, child: Text('Old Created')),
                      ],
                      onChanged: (int? value) async {
                        valueOrderBy = value as int;
                        transactions = [];
                        isGetDataTransactions = false;
                        setState(() => {});
                        changeOrderBy();
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Card(
                        color: Colors.blueAccent.shade700,
                        child: IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder:
                                  (context) => FilterDialogTransaction(
                                    selectedFilter: selectedFilter,
                                    onSubmit: (selectedFilter) async {
                                      this.selectedFilter = selectedFilter;
                                      transactions = [];
                                      setState(() {});
                                      transactions =
                                          await Transaction.getTrasactionByFilters(
                                            selectedFilter["status"],
                                            selectedFilter["price"],
                                            selectedFilter["created_at"],
                                          );
                                      setState(() {});
                                    },
                                  ),
                            );
                          },
                          icon: Icon(
                            Icons.filter_alt_sharp,
                            color: Colors.white,
                          ),
                          tooltip: 'Filter',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            SizedBox(
              height: MediaQuery.of(context).size.height - 180,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                      transactions.isEmpty
                          ? [
                            Center(
                              child: Text(
                                isGetDataTransactions
                                    ? "NOT FOUND"
                                    : "Fetching Data...",
                              ),
                            ),
                          ]
                          : transactions
                              .map(
                                (transaction) => GestureDetector(
                                  child: productCard(transaction),
                                ),
                              )
                              .toList(),
                ),
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

  AppBar _appBar() {
    return AppBar(
      backgroundColor: Colors.blueAccent.shade700,
      title: Text(
        'Manage Transactions',
        style: TextStyle(
          fontSize: 21.0,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(Icons.arrow_back, color: Colors.white, size: 30.0),
      ),
    );
  }

  GestureDetector productCard(Map<String, dynamic> transaction) {
    var date =
        DateTime.fromMillisecondsSinceEpoch(
          int.parse(transaction['created_at']),
        ).toString().split('.')[0];

    Color statusColor = Colors.red;
    if (transaction['status'] != 'rejected') {
      statusColor =
          transaction['status'] == "completed"
              ? Colors.green
              : const Color.fromARGB(255, 175, 159, 15);
    }
    return GestureDetector(
      onTap:
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailTransaction(transaction: transaction),
            ),
          ),
      child: Card(
        color: Colors.white,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          // height: 400.0,
          child: Column(
            children: [
              Icon(
                Icons.list_alt_outlined,
                size: 100,
                color: Colors.blueAccent.shade400,
              ),
              Container(
                padding: EdgeInsets.only(
                  top: 5.0,
                  left: 15.0,
                  right: 15.0,
                  bottom: 15.0,
                ),
                child: Column(
                  spacing: 5.0,
                  children: [
                    Text(
                      'Transaction id -${transaction['id']}',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Price",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal,
                          ),
                          softWrap: true,
                          overflow: TextOverflow.clip,
                          maxLines: 2,
                        ),
                        Text(
                          "Rp. ${Environment.numFormat.format(int.parse(transaction['total_price']))}",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                          softWrap: true,
                          overflow: TextOverflow.clip,
                          maxLines: 2,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Status",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal,
                          ),
                          softWrap: true,
                          overflow: TextOverflow.clip,
                          maxLines: 2,
                        ),
                        Text(
                          transaction['status'],
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                          softWrap: true,
                          overflow: TextOverflow.clip,
                          maxLines: 2,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Created at",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal,
                          ),
                          softWrap: true,
                          overflow: TextOverflow.clip,
                          maxLines: 2,
                        ),
                        Text(
                          date,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                          softWrap: true,
                          overflow: TextOverflow.clip,
                          maxLines: 2,
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
}
