import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SharedStorage {
  // Create storage
  static const storage = FlutterSecureStorage();
  static Map<String, String> values = {};

  // Read all values
  static Future<Map<String, String>> readAll() async {
    return await storage.readAll();
  }

  // Read value
  static Future<dynamic> read(String key) async {
    dynamic value;
    try {
      value = await storage.read(key: key);
    } catch(e) {
      value = null;
    }
    // print('ReadKey: $key Value: ${value}');
    return value;
  }

  // Write value
  static Future<bool> write(String key, dynamic value) async {
    const options = IOSOptions(accessibility: KeychainAccessibility.first_unlock);
    // print('$key : ${value.runtimeType}');
    value == null? await storage.write(key: key, value: value, iOptions: options)
        : await storage.write(key: key, value: value.toString(), iOptions: options);
    return true;
  }

  // Read all values
  static deleteAll() async {
    return await storage.deleteAll();
  }

  static delete(String key) async {
    return await storage.delete(key: key);
  }
}