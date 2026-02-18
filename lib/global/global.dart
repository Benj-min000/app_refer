import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? sharedPreferences;
FirebaseAuth firebaseAuth = FirebaseAuth.instance;

String? get currentUid => sharedPreferences?.getString("uid");

// Example: if UID is "ABC", key "name" becomes "ABC_name"
Future<void> saveUserPref<T>(String key, T value) async {
  if (currentUid == null) return;
  final String prefixedKey = "${currentUid}_$key";

  if (value is String) {
    await sharedPreferences!.setString(prefixedKey, value);
  } else if (value is int) {
    await sharedPreferences!.setInt(prefixedKey, value);
  } else if (value is bool) {
    await sharedPreferences!.setBool(prefixedKey, value);
  } else if (value is double) {
    await sharedPreferences!.setDouble(prefixedKey, value);
  } else if (value is List<String>) {
    await sharedPreferences!.setStringList(prefixedKey, value);
  }
}

// Retrieves a value prefixed by the current user's UID
T? getUserPref<T>(String key) {
  if (currentUid == null) return null;
  final String prefixedKey = "${currentUid}_$key";
  
  return sharedPreferences!.get(prefixedKey) as T?;
}

// Use this during Logout to ensure the UID is gone, 
Future<void> clearSession() async {
  await sharedPreferences!.remove("uid");
  // Optional: await sharedPreferences!.clear(); // Only if you want to wipe everything
}