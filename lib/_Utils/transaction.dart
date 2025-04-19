
import 'package:my_app/_config/db.dart';

class Transaction {

  // final int id;
  final int id_user;
  final int id_gudang ;
  final int total_price;
  final String status;

  const Transaction(this.id_user, this.id_gudang, this.total_price, this.status);

  static Future<List<Map<String, dynamic>>> getTransaction() async {
    try {
      final connection = await DBConnection.connect();
      var result = await connection.execute('SELECT * FROM transactions');

      List<Map<String, dynamic>> transaction = [];

      for (var row in result.rows) {
        transaction.add(row.assoc()); // ambil data per row dalam bentuk Map
      }

      await connection.close(); // tutup koneksi

      return transaction;
    } catch (error) {
      print('Error fetching products: $error');
      return []; // return empty kalau error
    }
  }

  static Future<List<Map<String, dynamic>>> getTransactionLast30Days() async {
    var _30daysUnix = DateTime.now().millisecondsSinceEpoch + (60*60*24*30*1000);
    try {
      final connection = await DBConnection.connect();
      var result = await connection.execute('SELECT * FROM transactions where created_at < $_30daysUnix');

      List<Map<String, dynamic>> transaction = [];

      for (var row in result.rows) {
        transaction.add(row.assoc()); // ambil data per row dalam bentuk Map
      }

      await connection.close(); // tutup koneksi

      return transaction;
    } catch (error) {
      print('Error fetching products: $error');
      return []; // return empty kalau error
    }
  }

}