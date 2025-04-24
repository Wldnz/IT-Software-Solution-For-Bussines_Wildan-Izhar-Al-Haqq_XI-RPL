import 'package:cloudinary/cloudinary.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String host = dotenv.get('host');
  static String username = dotenv.get('username');
  static String password = dotenv.get('password');
  static String database = dotenv.get('database');
  static String port = dotenv.get('port');
  static final cloudinary = Cloudinary.signedConfig(
    apiKey: dotenv.get('CLOUDINARY_API_KEY'),
    apiSecret: dotenv.get('CLOUDINARY_API_SECRET'),
    cloudName: dotenv.get('CLOUDINARY_NAME'),
  );
  static int _index = 0;
  static int getSelectedIndexNavigationBottom() => _index;
  static int setSelectedIndexNavigationBottom(int index) => _index = index;
}
