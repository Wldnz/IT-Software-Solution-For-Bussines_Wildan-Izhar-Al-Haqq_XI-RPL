import 'package:my_app/_config/db.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert'; // for utf8 encoding
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Account {
  final Map<String,dynamic> account = {}; 

  static bool isLogin = false;

  static var storage = FlutterSecureStorage();

  static Future<Map<String, String>> getAccount() async {
  final keys = ['id', 'name', 'fullname', 'email', 'phone', 'status'];
  Map<String, String> accountData = {};

  for (String key in keys) {
    final value = await storage.read(key: key);
    if (value != null) {
      accountData[key] = value;
    }
  }
  return accountData;
}


  static Future<bool> login(String email, String password) async {
    try {
      final connection = await DBConnection.connect();
      var sha256Pass = sha256.convert(utf8.encode(password));
      var result = await connection.execute("SELECT * FROM users where email='$email' AND password='$sha256Pass'");

      if(result.rows.isNotEmpty){
        for(var row in result.rows){
          var account = row.assoc();
          // account.add(row.assoc());
          storage.write(key: 'account', value: account.toString());
          storage.write(key: 'id', value: account['id']);
          storage.write(key: 'name', value: account['name']);
          storage.write(key: 'fullname', value: account['fullname']);
          storage.write(key: 'email', value: account['email']);
          storage.write(key: 'phone', value: account['phone']);
          storage.write(key: 'status', value: account['status']);
          await connection.close(); // tutup koneksi
          return true;
        }
      }
      await connection.close(); // tutup koneksi
      isLogin = false;
      return true;
    } catch (error) {
      print('Error fetching products: $error');
      return false; // return empty kalau error
    }

  }

   static Future<bool> updateProfile(Map<String,dynamic> account) async {
    try {
      final connection = await DBConnection.connect();

      var name = account['name'];
      var fullname = account['fullname'];
      var email = account['email'];
      var phone = account['phone'];
      var id = account['id'];

      var result = await connection.execute("UPDATE users set name='$name', fullname='$fullname',email='$email',phone='$phone' where id='$id'");


      if(result.affectedRows > BigInt.zero){
        await connection.close(); // tutup koneksi
        return true;
      }
      await connection.close(); // tutup koneksi
      return false;
    } catch (error) {
      print('Error fetching products: $error');
      return false; // return empty kalau error
    }
    
  }


}
