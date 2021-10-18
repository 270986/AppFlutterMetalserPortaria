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
    _positionStreamSubscription?.cancel();

    final positionStream = _geolocatorPlatform.getPositionStream();

    _positionStreamSubscription = positionStream.handleError((error) {
      _positionStreamSubscription?.cancel();
      _positionStreamSubscription = null;
    }).listen((position) {
      print(position.longitude.toString());

      positionsList.add(PositionModel(
          accuracy: position.accuracy,
          date: position.timestamp,
          latitude: position.latitude,
          longitude: position.longitude));
    });
  }

  void cancelListening() {
    _positionStreamSubscription.cancel();
  }

  void envioAPI() {
    teste = positionsList;
// vai tentar enviar pra API.... se der sucesso a gente limpa o objeto.
// se der erro, nao limpa e continua coletando.
    print('');
  }

  void limparPosicoes() {
    positionsList = [];
    teste = [];
  }
}
