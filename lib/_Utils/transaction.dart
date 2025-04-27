import 'package:inventoryz/_Utils/products.dart';
import 'package:inventoryz/_config/db.dart';

class Transaction {
  // final int id;
  final int idUser;
  final int idGudang;
  final int totalPrice;
  final String status;

  const Transaction(this.idUser, this.idGudang, this.totalPrice, this.status);

  static Future<List<Map<String, dynamic>>> getTransaction([
    String orderBy = "created_at DESC",
  ]) async {
    try {
      final connection = await DBConnection.connect();
      var result = await connection.execute(
        'SELECT * FROM transactions ORDER BY $orderBy',
      );

      List<Map<String, dynamic>> transaction = [];

      for (var row in result.rows) {
        transaction.add(row.assoc()); // ambil data per row dalam bentuk Map
      }

      await connection.close(); // tutup koneksi

      return transaction;
    } catch (error) {
      return []; // return empty kalau error
    }
  }

  static Future<bool> insertTrasanction(
    List<Map<String, dynamic>> orderProducts,
    Map<String, dynamic> transaction,
  ) async {
    if (orderProducts.isEmpty || transaction.isEmpty) return false;
    try {
      final currentUnixTimeStamp =
          DateTime.now().millisecondsSinceEpoch.toString();
      final connection = await DBConnection.connect();
      String sql =
          "INSERT INTO transactions VALUES(NULL,${transaction['id_user']},'${transaction['total_price']}','${transaction['destination']}','${transaction['address']}','$currentUnixTimeStamp','$currentUnixTimeStamp','checking')";
      var result = await connection.execute(sql);
      if (result.affectedRows > BigInt.zero) {
        String sql2 = "INSERT INTO orders VALUES";
        for (int i = 0; i < orderProducts.length; i++) {
          if (i == orderProducts.length - 1) {
            sql2 +=
                "(NULL, '${result.lastInsertID}','${orderProducts[i]['id']}','${orderProducts[i]['price']}','${orderProducts[i]['qty']}');";
          } else {
            sql2 +=
                "(NULL,'${result.lastInsertID}','${orderProducts[i]['id']}','${orderProducts[i]['price']}','${orderProducts[i]['qty']}'),";
          }
        }
        var result2 = await connection.execute(sql2);

        if (result2.affectedRows > BigInt.zero) {
          connection.close();
          for (int i = 0; i < orderProducts.length; i++) {
            var product = orderProducts[i];
            product['stock'] =
                (int.parse(product['stock']) > 0
                        ? int.parse(product['stock']) -
                            int.parse(product['qty'])
                        : 0)
                    .toString();
            Products.updateProduct(product);
          }
          return true;
        }
      }
      connection.close();
      return false;
    } catch (error) {
      return false; // return empty kalau error
    }
  }

  static Future<double> getTotalTrasanctionPrice() async {
    var unix30Days =
        DateTime.now().millisecondsSinceEpoch + (60 * 60 * 24 * 30 * 1000);
    try {
      final connection = await DBConnection.connect();
      var result = await connection.execute(
        'SELECT * FROM transactions where created_at < $unix30Days',
      );

      double totalPrice = 0;

      for (var row in result.rows) {
        totalPrice += double.parse(row.assoc()['total_price']!);
      }

      await connection.close(); // tutup koneksi

      return totalPrice;
    } catch (error) {
      return 0; // return empty kalau error
    }
  }

  static Future<List<Map<String, dynamic>>> getTransactionLast30Days([
    String orderBy = "created_at DESC",
  ]) async {
    var unix30Days =
        DateTime.now().millisecondsSinceEpoch + (60 * 60 * 24 * 30 * 1000);
    try {
      final connection = await DBConnection.connect();
      var result = await connection.execute(
        'SELECT * FROM transactions where created_at < $unix30Days ORDER BY $orderBy',
      );

      List<Map<String, dynamic>> transaction = [];

      for (var row in result.rows) {
        transaction.add(row.assoc()); // ambil data per row dalam bentuk Map
      }

      await connection.close(); // tutup koneksi

      return transaction;
    } catch (error) {
      return []; // return empty kalau error
    }
  }

  static Future<List<Map<String, dynamic>>> getDetailTransactionById(
    dynamic id,
  ) async {
    try {
      final connection = await DBConnection.connect();
      var result = await connection.execute(
        "SELECT o.id as id_order, p.id as id_product, p.name, p.image_url, o.price, o.quantity FROM orders o INNER JOIN products p ON o.id_product = p.id WHERE o.id_transaction = '$id';",
      );

      List<Map<String, dynamic>> orderProducts = [];

      for (var row in result.rows) {
        orderProducts.add(row.assoc()); // ambil data per row dalam bentuk Map
      }

      await connection.close(); // tutup koneksi

      return orderProducts;
    } catch (error) {
      return []; // return empty kalau error
    }
  }

  static Future<List<Map<String, dynamic>>> getTrasactionByFilters(
    String status,
    String price,
    String lastPublish,
  ) async {
    var unixByPublishDate =
        DateTime.now().millisecondsSinceEpoch -
        (60 *
            60 *
            24 *
            (lastPublish.isNotEmpty
                ? int.parse(lastPublish.split(" ")[0])
                : 0) *
            1000);
    String sql =
        "SELECT * FROM transactions WHERE total_price >= 0 ${status.isNotEmpty ? "AND status='$status'" : ""} ${lastPublish.isNotEmpty ? "AND created_at >= $unixByPublishDate" : ""} ORDER BY created_at DESC${price.contains("Highest") ? ", total_price DESC" : ", total_price ASC"};";
    try {
      final connection = await DBConnection.connect();
      final result = await connection.execute(sql);
      List<Map<String, dynamic>> products = [];
      if (result.rows.isNotEmpty) {
        for (var row in result.rows) {
          products.add(row.assoc());
        }
      }
      await connection.close();
      return products;
    } catch (error) {
      print(error);
      return [];
    }
  }
}
