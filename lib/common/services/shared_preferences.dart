import 'package:shared_preferences/shared_preferences.dart' as package;

abstract interface class SharedPreferences {
  Future<String?> getString(String key);
  Future<void> setString(String key, String value);
}

class DefaultSharedPreferences implements SharedPreferences {
  const DefaultSharedPreferences();

  @override
  Future<String?> getString(String key) async {
    return (await package.SharedPreferences.getInstance()).getString(key);
  }

  @override
  Future<void> setString(String key, String value) async {
    (await package.SharedPreferences.getInstance()).setString(key, value);
    return;
  }
}