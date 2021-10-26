import 'dart:convert';
import 'package:app_flutter/models/position.model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GeolocatorService {
  static Future<bool> enviarPosicoes(List<PositionModel> posicoes) async {
    var prefs = await SharedPreferences.getInstance();

    var url = 'http://189.84.211.26:82/apiBackofficeJWT/portariagps/ListArray';
    var token = prefs.getString("tokenjwt");
    var header = {
      "Content-Type": "application/json",
      "Authorization": "bearer " + token
    };

    List<PositionModel> _body = posicoes;

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
      return true;
    } else {
      return false;
    }
  }
}
