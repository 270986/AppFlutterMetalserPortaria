import 'dart:async';
import 'package:app_flutter/models/position.model.dart';
import 'package:app_flutter/services/geolocator.service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
//import 'dart:math' show sin, cos, sqrt, atan2;
//import 'package:vector_math/vector_math.dart';
part 'geolocator.controller.g.dart';

class GeolocatorController = GeolocatorControllerBase
    with _$GeolocatorController;

abstract class GeolocatorControllerBase with Store {
  GeolocatorControllerBase();

  List<Map<String, dynamic>> posicoesFinais = [];
  var distancia;
  int pontoEncontrado;

  List<Map<String, dynamic>> coordenadasReferencia = [
    {
      "latitude": -20.190338758248974,
      "longitude": -40.269761711862934,
      "ponto": 1,
    },
    {
      "latitude": -20.19025706066795,
      "longitude": -40.26871147688896,
      "ponto": 2,
    },
    {
      "latitude": -20.191937091690306,
      "longitude": -40.26883087978978,
      "ponto": 3,
    },
    {
      "latitude": -20.188229735926218,
      "longitude": -40.26889950029379,
      "ponto": 4,
    },
    {
      "latitude": -20.191788946610703,
      "longitude": -40.269993267587424,
      "ponto": 5,
    },
  ];

  int count = 0;

  @observable
  String longitude = "";

  @observable
  String date = new DateTime.now().toString();

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
      // mudaDataLancamento(position.timestamp);
      // mudaLatitude(position.latitude.toString());
      // mudaAccuracy(position.accuracy.toString());

      positionsList.add(PositionModel(
          accuracy: position.accuracy,
          date: (DateTime.now().year.toString() +
              "-" +
              DateTime.now().month.toString() +
              "-" +
              DateTime.now().day.toString() +
              " " +
              DateTime.now().hour.toString() +
              ":" +
              DateTime.now().minute.toString() +
              ":" +
              DateTime.now().second.toString()),
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
      print("latitude: " + melhorCoordenada.latitude.toString());
      print("longitude: " + melhorCoordenada.longitude.toString());

      mudaLongitude(melhorCoordenada.longitude.toString());
      mudaDate(melhorCoordenada.date);
      mudaLatitude(melhorCoordenada.latitude.toString());
      mudaAccuracy(melhorCoordenada.accuracy.toString());

      _verifyAccuracy(context, melhorCoordenada);
    }
    // tentar pegar de novo. deu ruim..
  }

  _verifyAccuracy(context, PositionModel melhorCoordenada) async {
    final distanciaresult = await _deParaNovo(melhorCoordenada);
    if (melhorCoordenada.accuracy <= 40 && distanciaresult <= 30) {
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
      posicao["date"] = melhorCoordenada.date;
      posicao["accuracy"] = melhorCoordenada.accuracy;
      posicao["ponto"] = pontoEncontrado;
      melhorCoordenada.ponto = pontoEncontrado;
      melhorCoordenada.usuario = prefs.getString("usuario");
      // TODO -> APAGAR DATE
      //  melhorCoordenada.date = "2021-10-26 13:25:57.887";
      List<PositionModel> test = [];
      test.add(melhorCoordenada);

      // tentar enviar o dado para a API!
// se estiver sem internet ou der erro... ai sim salva no shared preferences

      sharedPreferencePositionsList.add(posicao);
      await GeolocatorService.enviarPosicoes(test).then((value) async {
        print(value);
      });
      // await GeolocatorService.enviarPosicoes(sharedPreferencePositionsList)
      //     .then((value) async {
      //   print(value);
      // });
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
                //backgroundColor: Color.white,
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
        posicao["ponto"] = pontoEncontrado;

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

  /* int _dePara(melhorCoordenada) {
    int ponto = 0;

    if (melhorCoordenada.latitude >= -20.190331487812664 &&
        melhorCoordenada.latitude <= -20.19055840956599 &&
        melhorCoordenada.longitude >= -40.269696636655105 &&
        melhorCoordenada.longitude <= -40.269925305143126) {
      ponto = 1;
    } else if (melhorCoordenada.latitude >= -20.19018355502629 &&
        melhorCoordenada.latitude <= -20.190362289829544 &&
        melhorCoordenada.longitude >= -40.26867694664039 &&
        melhorCoordenada.longitude <= -40.268875430094525) {
      ponto = 2;
    } else if (melhorCoordenada.latitude >= -20.191796123043375 &&
        melhorCoordenada.latitude <= -20.19198346370194 &&
        melhorCoordenada.longitude >= -40.26878868916416 &&
        melhorCoordenada.longitude <= -40.268987169626406) {
      ponto = 3;
    } else if (melhorCoordenada.latitude >= -20.191599730329248 &&
        melhorCoordenada.latitude <= -20.191814590206477 &&
        melhorCoordenada.longitude >= -40.269826356317786 &&
        melhorCoordenada.longitude <= -40.2700643073265) {
      ponto = 4;
    } else if (melhorCoordenada.latitude >= -20.188225771819475 &&
        melhorCoordenada.latitude <= -20.188411431779592 &&
        melhorCoordenada.longitude >= -40.268889811788156 &&
        melhorCoordenada.longitude <= -40.269086954137876) {
      ponto = 9; //metalser
    } else {
      ponto = 0;
    }
    // se estiver no lugar certo retorna true,, se nao retorna false

    return ponto;
  } */

  Future<dynamic> _deParaNovo(PositionModel melhorCoordenada) async {
    pontoEncontrado = 1;
    distancia = Geolocator.distanceBetween(
        coordenadasReferencia[0]["latitude"],
        coordenadasReferencia[0]["longitude"],
        melhorCoordenada.latitude,
        melhorCoordenada.longitude);

    coordenadasReferencia.forEach((element) {
      var distanciaCalculada = Geolocator.distanceBetween(
          element["latitude"],
          element["longitude"],
          melhorCoordenada.latitude,
          melhorCoordenada.longitude);
      if (distanciaCalculada < distancia) {
        distancia = distanciaCalculada;
        pontoEncontrado = element["ponto"];
      }
    });

    return distancia;
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
