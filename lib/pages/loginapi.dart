import 'dart:convert';
import 'package:app_flutter/pages/usuario.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginApi {
  static Future<Usuario> login(String username, String password) async {
    var usuario;
    var prefs = await SharedPreferences.getInstance();

    var url = 'http://189.84.211.26:82/ApiBackofficeJWT/users/login';

    var header = {"Content-Type": "application/json"};
    Map params = {"Username": username, "Password": password};
    var _body = json.encode(params);
    var response = await http.post(url, headers: header, body: _body);
    //var mapResponse = await json.decode(json.encode(response.body));
    //Map mapResponse = json.decode(response.body);
    //var request = http.MultipartRequest('POST', Uri.parse('url, headers: header, body: _body'));
    //request.files.add(await http.MultipartFile.fromPath('', 'file_path'));
    print("login :  $response");
    Map mapResponse = json.decode(response.body);
    //var mapResponse = json.decode(json.encode(response.body));
    print(mapResponse);
    if (response.statusCode == 200) {
      usuario = Usuario.fromJson(mapResponse);
      prefs.setString("tokenjwt", mapResponse["token"]);
    } else {
      usuario = null;
    }
    return usuario;
  }
}
