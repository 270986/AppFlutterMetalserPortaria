import 'dart:async';
import 'package:app_flutter/models/position.model.dart';
import 'package:flutter/material.dart';
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

  void toggleListening(context) {
    mudaLoading(true);
    positionsList = [];

    _positionStreamSubscription?.cancel();

    final positionStream = _geolocatorPlatform.getPositionStream();

    Future.delayed(Duration(milliseconds: 10000), () {
      _positionStreamSubscription?.cancel();
      _getBestPosition(context);
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

  _getBestPosition(context) {
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

      _verifyAccuracy(context, melhorCoordenada);
    }
    // tentar pegar de novo. deu ruim..
  }

  _verifyAccuracy(context, melhorCoordenada) async {
    if (melhorCoordenada.accuracy <= 40 && (_dePara(melhorCoordenada) > 0)) {
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
      if (count == 0) {
        count++;
        //tentar de novo!
        // abrir popup com mensagem e um botao tentar de novo.[
        // e a fuyncao tentar de novo chama a funncao toggleListening
        showDialog(
          context: context,
          builder: (_) {
            return WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                title: Text("Alerta!"),
                content: Text("Sua localização está fora de alcance"),
                actions: [
                  TextButton(
                      onPressed: () {
                        toggleListening(context);
                        Navigator.of(context).pop();
                      },
                      child: Text("TENTAR NOVAMENTE")),
                ],
                elevation: 24,
                backgroundColor: Colors.white,
              ),
            );
          },
          barrierDismissible: false,
        );
        mudaLoading(false);
      } else {
        // salva a coordenada capturada
        // e da sucesso pro porteiro continuar a rota

        count = 0;
        var prefs = await SharedPreferences.getInstance();

        var sharedPreferencePositionsList;

        String sharedPreferencePositions =
            prefs.getString('sharedPreferencePositions');

        if (sharedPreferencePositions == null) {
          sharedPreferencePositionsList = [];
        } else {
          sharedPreferencePositionsList =
              json.decode(sharedPreferencePositions);
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
      }
    }
  }

  selecionaPonto() {}

  int _dePara(elhorCoordenada) {
    int ponto = 0;

    if (melhorCoordenada.latitude >= -20.19033 &&
        melhorCoordenada.latitude <= -20.19056 &&
        melhorCoordenada.longitude >= -40.26975 &&
        melhorCoordenada.longitude <= -40.26998) {
      ponto = 1;
    } else if (melhorCoordenada.latitude >= -20.19019 &&
        melhorCoordenada.latitude <= -20.19037 &&
        melhorCoordenada.longitude >= -40.26868 &&
        melhorCoordenada.longitude <= -40.26887) {
      ponto = 2;
    } else if (melhorCoordenada.latitude >= -20.19179 &&
        melhorCoordenada.latitude <= -20.19197 &&
        melhorCoordenada.longitude >= -40.26879 &&
        melhorCoordenada.longitude <= -40.26898) {
      ponto = 3;
    } else if (melhorCoordenada.latitude >= -20.19157 &&
        melhorCoordenada.latitude <= -20.19175 &&
        melhorCoordenada.longitude >= -40.26987 &&
        melhorCoordenada.longitude <= -40.27007) {
      ponto = 4;
    } else {
      ponto = 0;
    }
    // se estiver no lugar certo retorna true,, se nao retorna false
    return ponto;
  }

  void cancelListening() {
    _positionStreamSubscription.cancel();
  }

  void envioAPI() {
// vai tentar enviar pra API.... se der sucesso a gente limpa o objeto.
// se der erro, nao limpa e continua coletando.

// comparar com 3 pontos..

    print('');
  }

  void limparPosicoes() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.remove("sharedPreferencePositions");
    mudaLatitude("");
    mudaLongitude("");
    mudaAccuracy("");
  }
}
