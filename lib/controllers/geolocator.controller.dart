import 'dart:async';
import 'package:app_flutter/models/position.model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
part 'geolocator.controller.g.dart';

class GeolocatorController = GeolocatorControllerBase
    with _$GeolocatorController;

abstract class GeolocatorControllerBase with Store {
  GeolocatorControllerBase();

  List<Map<String, dynamic>> posicoesFinais = [];

  int count = 0;

  @observable
  String longitude = "";

  @observable
  DateTime date = new DateTime.now();

  @observable
  String latitude = "";

  @observable
  String accuracy = "";

  @observable
  bool isLoading = false;

  @action
  mudaLongitude(value) => longitude = value;

  @action
  mudaDate(value) => date = value;

  @action
  mudaLatitude(value) => latitude = value;

  @action
  mudaAccuracy(value) => accuracy = value;

  @action
  mudaLoading(value) => isLoading = value;

  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

  List<String> pontosList = ["Ponto 1", "Ponto 2", "Ponto 3", "Ponto 4"];

  List<PositionModel> positionsList = [];
  List<PositionModel> teste;
  PositionModel melhorCoordenada;
  StreamSubscription<Position> _positionStreamSubscription;

  getCurrentPosition() async {
    final hasPermission = await _handlePermission();

    if (!hasPermission) {
      return;
    }

    final position = await _geolocatorPlatform.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        forceAndroidLocationManager: true);
    print("position: " + position.altitude.toString());
    mudaLongitude(position.longitude.toString());
    mudaDate(position.timestamp);
    mudaLatitude(position.latitude.toString());
    mudaAccuracy(position.accuracy.toString());
  }

  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await _geolocatorPlatform.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
      return true;
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  void toggleListening() {
    mudaLoading(true);
    positionsList = [];

    _positionStreamSubscription?.cancel();

    final positionStream = _geolocatorPlatform.getPositionStream();

    Future.delayed(Duration(milliseconds: 10000), () {
      _positionStreamSubscription?.cancel();
      _getBestPosition();
    });

    _positionStreamSubscription = positionStream.handleError((error) {
      _positionStreamSubscription?.cancel();
      _positionStreamSubscription = null;
    }).listen((position) {
      // mudaLongitude(position.longitude.toString());
      // mudaDate(position.timestamp);
      // mudaLatitude(position.latitude.toString());
      // mudaAccuracy(position.accuracy.toString());

      positionsList.add(PositionModel(
          accuracy: position.accuracy,
          date: position.timestamp,
          latitude: position.latitude,
          longitude: position.longitude));
    });
  }

  _getBestPosition() {
    if (positionsList.length > 0) {
      var menorAccuracy = positionsList[0].accuracy;
      melhorCoordenada = PositionModel(
        accuracy: positionsList[0].accuracy,
        date: positionsList[0].date,
        latitude: positionsList[0].latitude,
        longitude: positionsList[0].longitude,
      );
      positionsList.forEach((position) {
        if (position.accuracy < menorAccuracy) {
          menorAccuracy = position.accuracy;
          melhorCoordenada = PositionModel(
            accuracy: position.accuracy,
            date: position.date,
            latitude: position.latitude,
            longitude: position.longitude,
          );
        }
      });
      print("menor accuracy: " + menorAccuracy.toString());
      print("longitude: " + melhorCoordenada.longitude.toString());
      print("latitude: " + melhorCoordenada.latitude.toString());

      mudaLongitude(melhorCoordenada.longitude.toString());
      mudaDate(melhorCoordenada.date);
      mudaLatitude(melhorCoordenada.latitude.toString());
      mudaAccuracy(melhorCoordenada.accuracy.toString());

      _verifyAccuracy();
    }
    // tentar pegar de novo. deu ruim..
  }

  _verifyAccuracy() async {
    count++;

    if (melhorCoordenada.accuracy <= 40 && _dePara()) {
      count = 0;
      var prefs = await SharedPreferences.getInstance();

      var sharedPreferencePositionsList;

      String sharedPreferencePositions =
          prefs.getString('sharedPreferencePositions');

      if (sharedPreferencePositions == null) {
        sharedPreferencePositionsList = [];
      } else {
        sharedPreferencePositionsList = json.decode(sharedPreferencePositions);
      }

      Map<String, dynamic> posicao = {};
      posicao["longitude"] = melhorCoordenada.longitude;
      posicao["latitude"] = melhorCoordenada.latitude;
      posicao["date"] = melhorCoordenada.date.toString();
      posicao["accuracy"] = melhorCoordenada.accuracy;

      // tentar enviar o dado para a API!
// se estiver sem internet ou der erro... ai sim salva no shared preferences

      sharedPreferencePositionsList.add(posicao);
      prefs.setString("sharedPreferencePositions",
          json.encode(sharedPreferencePositionsList));

      mudaLoading(false);
      //  prefs.setString("tokenjwt", );
      // verificar de para das coordenadas e salva no localstorage
    } else {
      if (count == 1) {
        count++;
        //tentar de novo!
        // abrir popup com mensagem e um botao tentar de novo.[
        // e a fuyncao tentar de novo chama a funncao toggleListening

      } else {
        // salva a coordenada capturada
        // e da sucesso pro porteiro continuar a rota

        count = 0;
      }
    }
  }

  bool _dePara() {
    // se estiver no lugar certo retorna true,, se nao retorna false
    return true;
  }

  void cancelListening() {
    _positionStreamSubscription.cancel();
  }

  void envioAPI() {
    teste = positionsList;
// vai tentar enviar pra API.... se der sucesso a gente limpa o objeto.
// se der erro, nao limpa e continua coletando.

// comparar com 3 pontos..

    print('');
  }

  void limparPosicoes() {
    positionsList = [];
    teste = [];
  }
}
