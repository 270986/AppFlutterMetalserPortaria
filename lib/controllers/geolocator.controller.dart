import 'dart:async';
import 'package:app_flutter/models/position.model.dart';
import 'package:app_flutter/services/geolocator.service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:android_intent/android_intent.dart';

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
      "latitude": -20.19041496871912,
      "longitude": -40.26980385769676,
      "ponto": 1,
    },
    {
      "latitude": -20.19030912549591,
      "longitude": -40.26876860164139,
      "ponto": 2,
    },
    {
      "latitude": -20.19103732539701,
      "longitude": -40.26887235277943,
      "ponto": 3,
    },
    {
      "latitude": -20.191873480950175,
      "longitude": -40.26890392921661,
      "ponto": 4,
    },
    {
      "latitude": -20.19174420874664,
      "longitude": -40.27000315823748,
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

  @observable
  bool bestGeolocator = false;

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

  @action
  mudaBestGeolocator(value) => bestGeolocator = value;

  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

  List<String> pontosList = ["Ponto 1", "Ponto 2", "Ponto 3", "Ponto 4"];

  List<PositionModel> positionsList = [];

  List<PositionModel> teste;

  PositionModel melhorCoordenada;

  StreamSubscription<Position> _positionStreamSubscription;

  void openLocationSetting(context) async {
    Navigator.of(context).pop();
    final AndroidIntent intent = new AndroidIntent(
      action: 'android.settings.LOCATION_SOURCE_SETTINGS',
    );
    await intent.launch();
  }

  getCurrentPosition(context) async {
    final hasPermission = await _handlePermission(context);

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

  Future<bool> _handlePermission(context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      envioApiSuccessDialog(
          context: context,
          title: "Localização Desativada!",
          msg: "Por favor, ative a localização do aparelho!",
          ativarLocalizacao: true);
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

  toggleListening(context) async {
    final hasPermission = await _handlePermission(context);

    if (!hasPermission) {
      return;
    }
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
      enviarParaApi(context);
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
                title: Text("Atenção!"),
                content: Text("Sua localização está fora de alcance!"),
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
        count = 0;
        enviarParaApi(context);
      }
    }
  }

  enviarParaApi(context) async {
    List<dynamic> sharedPreferencePositionsList = [];
    List<PositionModel> posicoesEnviarApi = [];

    var prefs = await SharedPreferences.getInstance();

    String sharedPreferencePositions =
        prefs.getString('sharedPreferencePositions');

    if (sharedPreferencePositions != null) {
      sharedPreferencePositionsList = json.decode(sharedPreferencePositions);
      sharedPreferencePositionsList.forEach((element) {
        posicoesEnviarApi.add(PositionModel(
            accuracy: element["Accuracy"],
            date: element["Date"],
            latitude: element["Latitude"],
            longitude: element["Longitude"],
            ponto: element["Ponto"],
            usuario: element["Usuario"]));
      });
    }

    posicoesEnviarApi.add(PositionModel(
        accuracy: melhorCoordenada.accuracy,
        date: melhorCoordenada.date,
        latitude: melhorCoordenada.latitude,
        longitude: melhorCoordenada.longitude,
        ponto: pontoEncontrado,
        usuario: prefs.getString("usuario")));

    await GeolocatorService.enviarPosicoes(posicoesEnviarApi)
        .then((value) async {
      if (value) {
        prefs.remove('sharedPreferencePositions');
      } else {
        prefs.setString(
            'sharedPreferencePositions', json.encode(posicoesEnviarApi));
      }
    });
    envioApiSuccessDialog(
        context: context,
        title: "Sucesso!",
        msg: "Sua localização foi registrada com sucesso!",
        ativarLocalizacao: false);
    mudaLoading(false);
  }

  buttonEnviarDados(context) async {
    mudaLoading(true);
    List<dynamic> sharedPreferencePositionsList = [];
    List<PositionModel> posicoesEnviarApi = [];
    var prefs = await SharedPreferences.getInstance();

    String sharedPreferencePositions =
        prefs.getString('sharedPreferencePositions');

    if (sharedPreferencePositions != null) {
      sharedPreferencePositionsList = json.decode(sharedPreferencePositions);
      sharedPreferencePositionsList.forEach((element) {
        posicoesEnviarApi.add(PositionModel(
            accuracy: element["Accuracy"],
            date: element["Date"],
            latitude: element["Latitude"],
            longitude: element["Longitude"],
            ponto: element["Ponto"],
            usuario: element["Usuario"]));
      });
    }
    if (posicoesEnviarApi.length > 0) {
      await GeolocatorService.enviarPosicoes(posicoesEnviarApi)
          .then((value) async {
        if (value) {
          prefs.remove('sharedPreferencePositions');
          envioApiSuccessDialog(
              context: context,
              title: "Sucesso!",
              msg: "Os dados foram enviados com sucesso!",
              ativarLocalizacao: false);

          // prefs.setString(
          //     'sharedPreferencePositions', json.encode(posicoesEnviarApi));
        } else {
          prefs.setString(
              'sharedPreferencePositions', json.encode(posicoesEnviarApi));
          envioApiSuccessDialog(
              context: context,
              title: "Atenção!",
              msg:
                  "Por algum motivo os dados não foram enviados. Tente novamente mais tarde!",
              ativarLocalizacao: false);
        }
      });
    } else {
      envioApiSuccessDialog(
          context: context,
          title: "Atenção!",
          msg: "Todos os dados já foram enviados!",
          ativarLocalizacao: false);
    }

    mudaLoading(false);
  }

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

  void envioApiSuccessDialog({context, title, msg, bool ativarLocalizacao}) {
    showDialog(
      context: context,
      builder: (_) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: Text(title),
            content: Text(msg),
            actions: [
              TextButton(
                  onPressed: () {
                    ativarLocalizacao
                        ? openLocationSetting(context)
                        : Navigator.of(context).pop();
                  },
                  child: ativarLocalizacao ? Text("Ativar") : Text("OK")),
            ],
            elevation: 24,
            //backgroundColor: Color.white,
          ),
        );
      },
      barrierDismissible: false,
    );
    //mudaBestGeolocator(true);
  }

  void limparPosicoes() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.remove("sharedPreferencePositions");
    mudaLatitude("");
    mudaLongitude("");
    mudaAccuracy("");
  }
}
