abstract final class LocalStorage {
  static final Map<String, String> _values = {};

  static String? getString(String key) => _values[key];

  static Future<void> setString(String key, String value) async {
    _values[key] = value;
  }

  static Future<void> clearAll() async {
    _values.clear();
  }
}
