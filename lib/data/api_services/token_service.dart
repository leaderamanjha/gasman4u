import 'package:get_storage/get_storage.dart';
// import 'package:eeze/data/models/user_model.dart';

class TokenService {
  static final _box = GetStorage();
  static const _tokenKey = 'auth_token';
  // static const _userKey = 'user_info';
  static const _profileImageKey = 'profile_image';

  static Future<String?> getToken() async {
    return _box.read(_tokenKey);
  }

  static Future<void> saveToken(String token) async {
    await _box.write(_tokenKey, token);
  }

  static Future<void> deleteToken() async {
    await _box.remove(_tokenKey);
  }

  // static Future<void> saveUserInfo(User user) async {
  //   await _box.write(_userKey, user.toJson());
  // }

  // static Future<User?> getUserInfo() async {
  //   final userMap = _box.read(_userKey);
  //   return userMap != null ? User.fromJson(userMap) : null;
  // }

  static Future<void> saveProfileImagePath(String path) async {
    await _box.write(_profileImageKey, path);
  }

  static Future<String?> getProfileImagePath() async {
    return _box.read(_profileImageKey);
  }

  static Future<void> clearAllData() async {
    await _box.erase();
  }
}
