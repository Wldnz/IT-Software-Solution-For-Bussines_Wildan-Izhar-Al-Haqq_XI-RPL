import 'package:flutter/material.dart';
import 'package:inventoryz/_Utils/history.dart';
import 'package:inventoryz/components/notfound.dart';

class AllHistory extends StatefulWidget {
  const AllHistory({super.key});

  @override
  State<AllHistory> createState() => _AllHistoryState();
}

class _AllHistoryState extends State<AllHistory> {
  var historys = [];

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  Future<void> _loadData() async {
    historys = await History.getHistorys();
    setState(() {
      historys;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Recently Activities Users',
          style: TextStyle(
            fontSize: 18.5,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue.shade700,
        toolbarHeight: 60.0,
        centerTitle: true,
        leading: InkWell(
          child: Icon(Icons.arrow_back, size: 30, color: Colors.white),
          onTap: () => Navigator.pop(context),
        ),
      ),
      body:
          historys.isEmpty
              ? NotFoundData()
              : ListView.builder(
                itemCount: historys.length,
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.all(20.0),
                itemBuilder: (context, index) {
                  return Container(
                    width: 280.0,
                    padding: EdgeInsets.all(10.0),
                    margin: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xDFDFDFDF),
                          offset: Offset(2.0, 1.0),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          historys[index]['action'],
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 14.0,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Action by ${historys[index]['name']}',
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 12.0,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            Text(
                              DateTime.fromMillisecondsSinceEpoch(
                                int.parse(historys[index]['created_at']),
                              ).toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.w200,
                                fontSize: 10.0,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
    );
  }
}
