// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../models/user_model.dart';

// class UserService {
//   static Future<UserModel?> getUser(int id) async {
//     final url = Uri.parse("https://ecotechapi-production.up.railway.app/usuario/$id");

//     final response = await http.get(url);

//     if (response.statusCode == 200) {
//       final Map<String, dynamic> data = json.decode(response.body);

//       return UserModel.fromJson(data);
//     }

//     return null;
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class UserService {
  static Future<UserModel?> getUser(int id) async {
    final url = Uri.parse(
      "https://ecotechapi-production.up.railway.app/usuario/$id",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return UserModel.fromJson(data);
    }

    return null;
  }
}