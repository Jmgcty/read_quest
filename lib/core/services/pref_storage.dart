import 'package:shared_preferences/shared_preferences.dart';

enum SharedPrefKeys { sessionId }

class SharedPrefStorage {
  SharedPrefStorage._();
  static final SharedPrefStorage instance = SharedPrefStorage._();

  //
  Future<void> setAuthSession(String sessionId) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(SharedPrefKeys.sessionId.name, sessionId);
  }

  Future<String?> getAuthSession() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(SharedPrefKeys.sessionId.name);
  }

  Future<void> removeAuthSession() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove(SharedPrefKeys.sessionId.name);
  }
}
