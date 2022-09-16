import 'package:flutter_secure_storage/flutter_secure_storage.dart';

///
///
///@author musabisimwa
///secure local database for one persisrence storage
/// attributes crud
/// encrypted
///
///
class LocalStorageService {
  static final _storage = FlutterSecureStorage();

// key to query the address later on
  static const _addressKey = 'addressKey';

  static Future setAddress(String address) async {
    await _storage.write(key: _addressKey, value: address);
  }

  static Future<String?> getAddress() async {
    return await _storage.read(key: _addressKey);
  }

//delete 
  static Future removeAddress() async {
    await _storage.delete(key: _addressKey);
  }
}
