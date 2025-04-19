import 'package:flutter/material.dart';
import 'package:my_app/_Utils/product.dart';
import 'package:my_app/_Utils/transaction.dart';

class AddTransaction extends StatefulWidget {
  const AddTransaction({super.key});

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {

  var transaction = Transaction(0,0,0,'uncompleted');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Container(
        margin: EdgeInsets.only(
          top: 60.0
        ),
        padding: EdgeInsets.all(10.0),
        width: double.infinity,
        // height: 200.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               Text('List Products', style: TextStyle(
                fontSize: 24.0,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold)),
                TextButton(onPressed: (){

                }, child: Text('Add Product', style: TextStyle(
                fontSize: 20.0,
                color: Colors.blue.shade700,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.normal)),)
             ],
           ),
            Container(
              width: MediaQuery.of(context).size.width - 80,
              padding: EdgeInsets.all(10.0),
              child: ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                 ProductCard('21212', 212, 12, 'https://my.alfred.edu/zoom/_images/foster-lake.jpg')
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Card ProductCard(String name, int price, int qty, String image_url) {
    return Card(
      color: const Color.fromARGB(255, 241, 240, 240),
      child: Container(
        width: 340.0,
        child: Column(
          children: [
            Image(image: NetworkImage(image_url), width: 320),
            Container(
              padding: EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Rp. $price",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "$qty Quantity",
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


 AppBar _appBar() {
    return AppBar(
      title: Text('Add Transaction'),
      centerTitle: true,
      elevation: 0.0,
      automaticallyImplyLeading: false,
      leading: InkWell(
        onTap : (){
          showDialog(context: context, builder: (context) => AlertDialog(
            title: Text('Are You Sure Want To Leave it?'),
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
          ));
        },
        child : Icon(Icons.arrow_back,
        size : 30.0)
        ,
      ),
    );
  }
}