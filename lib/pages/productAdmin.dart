import 'package:flutter/material.dart';
import 'package:my_app/_Utils/products.dart';
import 'package:my_app/components/navigation.dart';
import 'package:my_app/pages/addProduct.dart';
import 'package:my_app/pages/editProduct.dart';

class ProductAdmin extends StatefulWidget {
  const ProductAdmin({super.key});

  @override
  State<ProductAdmin> createState() => _ProductAdminState();
}

class _ProductAdminState extends State<ProductAdmin> {
  var products = Products.getProducts() as Future;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Manage Products'),
      //   centerTitle: true,
      //   elevation: 0.0,
      // ),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.all(20.0),
            child: Column(
              spacing: 30.0,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: 10.0,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 100,
                      child: TextField(
                        style: TextStyle(fontFamily: 'Poppins'),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search_rounded),
                          contentPadding: EdgeInsets.all(12.0),
                          border: InputBorder.none,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.black26),
                          ),
                          hintText: 'Search Any here...',
                          // hintStyle: TextStyle(color: const Color(0xDFDFDFDF)),
                        ),
                        onSubmitted: (String value) {
                          setState(() {
                            products =
                                value.isNotEmpty
                                    ? Products.getProductByName(value) as Future
                                    : products = Products.getProducts();
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: 50.0,
                      height: 50.0,
                      child: Card(
                        color: Colors.blueAccent.shade400,
                        child: Icon(Icons.filter_alt, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  // height: 200,
                  child: FutureBuilder(
                    future: products,
                    builder: (context, snapShot) {
                      if (snapShot.connectionState == ConnectionState.waiting) {
                        return Center(child: Text('Fetching Data....'));
                      } else if (snapShot.hasError) {
                        return Center(child: Text('Error: ${snapShot.error}'));
                      } else if (!snapShot.hasData || snapShot.data!.isEmpty) {
                        return Center(child: Text('No Products'));
                      } else {
                        List<Map<String, dynamic>> data = snapShot.data!;
                        return Column(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                var product = data[index];
                                return InkWell(
                                  child: productCard(
                                    product['name'],
                                    int.parse(product['price']),
                                    int.parse(product['stock']),
                                    product['image_url'],
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditProduct(),
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
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBottomAdmin(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProduct()),
          );
        },
        tooltip: 'Add Product',
        child: Icon(Icons.add),
      ),
    );
  }

  Card productCard(String name, int price, int stock, String imageUrl) {
    return Card(
      color: const Color.fromARGB(255, 241, 240, 240),
      child: SizedBox(
        width: 400.0,
        child: Column(
          children: [
            Image(image: NetworkImage(imageUrl), width: 380),
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
                        "$stock Pcs",
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
