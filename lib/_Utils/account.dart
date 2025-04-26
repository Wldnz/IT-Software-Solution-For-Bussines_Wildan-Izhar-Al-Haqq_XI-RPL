import 'package:inventoryz/_Utils/history.dart';
import 'package:inventoryz/_config/db.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert'; // for utf8 encoding
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Account {
  final Map<String, dynamic> account = {};

  static bool isLogin = false;

  static var storage = FlutterSecureStorage();

  static Future<Map<String, String>> getAccount() async {
    var expectedFields = [
      "id",
      "name",
      "fullname",
      "email",
      "password",
      "phone",
      "image_url",
      "role",
    ];
    try {
      final connection = await DBConnection.connect();
      var id = await storage.read(key: 'id');
      var result = await connection.execute(
        "SELECT * FROM users where id='$id'",
      );

      Map<String, String> account = {};

      if (result.rows.isNotEmpty) {
        var resultAssoc = result.rows.first.assoc();
        for (var field in expectedFields) {
          account[field] = resultAssoc[field] as String;
        }
      }
      await connection.close(); // tutup koneksi
      return account;
    } catch (error) {
      return {}; // return empty kalau error
    }
  }

  static Future<bool> login(String email, String password) async {
    try {
      final connection = await DBConnection.connect();
      var sha256Pass = sha256.convert(utf8.encode(password));
      var result = await connection.execute(
        "SELECT * FROM users where email='$email' AND password='$sha256Pass' AND status='valid'",
      );

      if (result.rows.isNotEmpty) {
        await storage.write(key: 'id', value: result.rows.first.assoc()['id']);
        await connection.close(); // tutup koneksi
        History.createHistory('Succesfully Login');
        return true;
      }
      await connection.close(); // tutup koneksi
      History.createHistory('user with email=$email failed login');
      return false;
    } catch (error) {
      return false; // return empty kalau error
    }
  }

  static Future<bool> logout() async {
    try {
      await storage.delete(key: 'id');
      return true;
    } catch (error) {
      return false; // return empty kalau error
    }
  }

  static Future<dynamic> getTotalStaff() async {
    try {
      final connection = await DBConnection.connect();
      var result = await connection.execute(
        "SELECT COUNT(id) as total_staff FROM users WHERE role='staff'",
      );

      if (result.rows.isNotEmpty) {
        await connection.close(); // tutup koneksi
        var totalStaff = result.rows.first.assoc()['total_staff'];
        return totalStaff;
      }
      await connection.close(); // tutup koneksi
      return false;
    } catch (error) {
      return false; // return empty kalau error
    }
  }

  static Future<bool> addAccount(Map<String, dynamic> account) async {
    try {
      final connection = await DBConnection.connect();
      var sha256Pass = sha256.convert(utf8.encode(account['password']));

      var result = await connection.execute(
        "INSERT INTO users VALUES(NULL,'${account['name']}','${account['fullname']}','${account['email']}','${account['phone']}','$sha256Pass','${account['image_url']}','${account['role']}','valid');",
      );

      connection.close();
      if (result.affectedRows > BigInt.zero) {
        History.createHistory('Successfully Insert Account ${account['name']}');
        return true;
      }
      return false;
    } catch (error) {
      History.createHistory('Failed When Want To Adding Account');
      return false; // return empty kalau error
    }
  }

  static Future<bool> updateProfile(Map<String, dynamic> account) async {
    try {
      final connection = await DBConnection.connect();

      var name = account['name'];
      var fullname = account['fullname'];
      var email = account['email'];
      var imageUrl = account['image_url'];
      var role = account['role'];
      var phone = account['phone'];
      var id = account['id'];

      var result = await connection.execute(
        "UPDATE users set name='$name', fullname='$fullname', email='$email', phone='$phone', role='$role', image_url='$imageUrl' where id=$id",
      );

      if (result.affectedRows > BigInt.zero) {
        await connection.close();
        History.createHistory('Successfully Update Profile  $name');
        return true;
      }
      await connection.close(); // tutup koneksi
      return false;
    } catch (error) {
      History.createHistory('Failed When Want To Update Profile');
      return false; // return empty kalau error
    }
  }
}
