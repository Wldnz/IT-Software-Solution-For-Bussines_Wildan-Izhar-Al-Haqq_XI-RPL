
import 'package:flutter/material.dart';
import 'package:my_app/_Utils/history.dart';
import 'package:my_app/components/notfound.dart';

class AllHistory extends StatefulWidget {
  const AllHistory({super.key});

  @override
  State<AllHistory> createState() => _AllHistoryState();
}

class _AllHistoryState extends State<AllHistory> {

  var historys = [];

  @override
  void initState() {
    // TODO: implement initState
    _loadData();
    super.initState();
  }

  Future<void>_loadData() async{
    historys = await History.getHistorys();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text('Recently Activities Users', style: TextStyle(
          fontSize: 18.5,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold,
          color: Colors.white
        )),
        backgroundColor: Colors.blue.shade700,
        toolbarHeight: 60.0,
        centerTitle: true,
        leading: InkWell(
          child: Icon(Icons.arrow_back, size: 30, color: Colors.white),
          onTap: () => Navigator.pop(context),
        ),
      ),
      body: historys.isEmpty? NotFoundData() : ListView.builder(
        itemCount: historys.length,
        itemBuilder: (context, index){
          return SizedBox(
            width: MediaQuery.of(context).size.width - 100,
            child: Card(
                child: Text('Memperbaiki Ui'),
            ),
          );
        },
      ),
    );
  }
}