import 'package:inventoryz/_Utils/history.dart';
import 'package:inventoryz/_config/db.dart';

class Products {
  static Future<List<Map<String, dynamic>>> getProducts([
    bool showSoldStock = false,
  ]) async {
    try {
      final connection = await DBConnection.connect();
      var result = await connection.execute(
        "SELECT * FROM products where status='public' ${!showSoldStock ? "AND stock != 0" : ""};",
      );

      List<Map<String, dynamic>> products = [];

      for (var row in result.rows) {
        products.add(row.assoc()); // ambil data per row dalam bentuk Map
      }

      await connection.close(); // tutup koneksi

      return products;
    } catch (error) {
      return []; // return empty kalau error
    }
  }

  static Future<bool> insertProduct(Map<String, dynamic> product) async {
    try {
      final connection = await DBConnection.connect();

      var name = product['name'];
      var description = product['description'];
      var category = product['category'];
      var price = int.parse(product['price']);
      var stock = double.parse(product['stock']);
      var imageUrl = product['image_url'];
      var currentTimeStamp = DateTime.now().millisecondsSinceEpoch;
      var result = await connection.execute(
        "INSERT INTO products VALUES(NULL,'$name','$description','$category','$price','$stock','$imageUrl','$currentTimeStamp','$currentTimeStamp','public')",
      );

      connection.close();
      if (result.affectedRows > BigInt.zero) {
        History.createHistory('Successfully Insert Product $name');
        return true;
      }
      return false;
    } catch (error) {
      History.createHistory('Failed When Want To Insert Product');
      return false; // return empty kalau error
    }
  }

  static Future<bool> updateProduct(Map<String, dynamic> product) async {
    try {
      final connection = await DBConnection.connect();
      var id = product['id'];
      var name = product['name'];
      var description = product['description'];
      var price = product['price'];
      var stock = product['stock'];
      var imageUrl = product['image_url'];
      var result = await connection.execute(
        "UPDATE products SET name='$name', description='$description', price='$price', stock='$stock', image_url='$imageUrl', status='public' where id='$id'",
      );

      if (result.affectedRows > BigInt.zero) {
        await connection.close(); // tutup koneksi
        History.createHistory('Successfully Update Product $name');
        return true;
      }

      await connection.close(); // tutup koneksi

      return false;
    } catch (error) {
      History.createHistory('Failed When Want To Update Product');
      return false; // return empty kalau error
    }
  }

  static Future<bool> deleteProduct(dynamic id) async {
    try {
      final connection = await DBConnection.connect();
      var result = await connection.execute(
        "update products set status='private' where id='$id'",
      );

      if (result.affectedRows > BigInt.zero) {
        await connection.close(); // tutup koneksi
        History.createHistory('Successfully Delete Product $id');
        return true;
      }

      await connection.close(); // tutup koneksi

      return false;
    } catch (error) {
      return false; // return empty kalau error
    }
  }

  static Future<List<Map<String, dynamic>>> getProductByName(
    String name,
  ) async {
    try {
      final connection = await DBConnection.connect();
      var result = await connection.execute(
        "select * from products where name='$name' OR name LIKE '%$name%' AND status='public' ",
      );

      List<Map<String, dynamic>> products = [];

      if (result.isNotEmpty) {
        for (var row in result.rows) {
          products.add(row.assoc()); // ambil data per row dalam bentuk Map
        }
      }
      await connection.close(); // tutup koneksi

      return products;
    } catch (error) {
      return [];
    }
  }
}
