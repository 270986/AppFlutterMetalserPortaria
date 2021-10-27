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

    List<Map<String, dynamic>> chckList =
        posicoes.map((e) => (e.toJson())).toList();

    String _body = json.encode(chckList);

    var response = await http.post(url, headers: header, body: _body);

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
