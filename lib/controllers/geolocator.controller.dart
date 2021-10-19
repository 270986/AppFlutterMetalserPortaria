import 'dart:async';
import 'package:app_flutter/models/position.model.dart';
import 'package:geolocator/geolocator.dart';

class GeolocatorController {
  GeolocatorController();

  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  String longitude = "";
  String latitude = "";
  String accuracy = "";
  DateTime date = new DateTime.now();

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
    longitude = position.longitude.toString();
    latitude = position.latitude.toString();
    accuracy = position.accuracy.toString();
    date = DateTime.now();
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
      print(position.longitude.toString());
      print(position.latitude.toString());
      print(position.accuracy.toString());

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
      _verifyAccuracy();
    }
    // tentar pegar de novo. deu ruim..
  }

  _verifyAccuracy() {
    if (melhorCoordenada.accuracy <= 40 && _dePara()) {
      // verificar de para das coordenadas e salva no localstorage
    } else {
      //tentar de novo!
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
