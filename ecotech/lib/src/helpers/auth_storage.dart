import 'package:shared_preferences/shared_preferences.dart';

class AuthStorage {
  static const String _keyUserId = 'userId';
  static const String _keyUserName = 'userName';
  static const String _keyToken = 'token';

  // --------------------------------------------------------
  // SALVAR SESSÃO DO USUÁRIO
  // --------------------------------------------------------
  static Future<void> salvarSessao({
    required int userId,
    required String userName,
    required String token,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyUserId, userId);
    await prefs.setString(_keyUserName, userName);
    await prefs.setString(_keyToken, token);
  }

  // --------------------------------------------------------
  // LER USERID SALVO
  // --------------------------------------------------------
  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyUserId);
  }

  // --------------------------------------------------------
  // LER USERNAME SALVO
  // --------------------------------------------------------
  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserName);
  }

  // --------------------------------------------------------
  // LER TOKEN SALVO
  // --------------------------------------------------------
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  // --------------------------------------------------------
  // VERIFICAR SE ESTÁ LOGADO
  // --------------------------------------------------------
  static Future<bool> isLogado() async {
    final userId = await getUserId();
    return userId != null;
  }

  // --------------------------------------------------------
  // LIMPAR SESSÃO (LOGOUT)
  // --------------------------------------------------------
  static Future<void> limpar() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyUserName);
    await prefs.remove(_keyToken);
  }
}