import './key_value_storage_service.dart';


class KeyValueStorageServiceImpl implements KeyValueStorageService {

  Future getSharedPrefs() async {

    return await SharedPreferences

  }

  @override
  Future<T?> getValue<T>(String key) {
    // TODO: implement getValue
    throw UnimplementedError();
  }

  @override
  Future<bool> removeKey(String key) {
    // TODO: implement removeKey
    throw UnimplementedError();
  }

  @override
  Future<void> setKeyValue<T>(String key, T value) {
    // TODO: implement setKeyValue
    throw UnimplementedError();
  }

}

