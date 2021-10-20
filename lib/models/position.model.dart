import 'package:geolocator/geolocator.dart';

class PositionModel {
  double longitude;
  double latitude;
  double accuracy;
  DateTime date;

  PositionModel({this.accuracy, this.date, this.latitude, this.longitude});

  PositionModel.toJson(Map<String, dynamic> json) {
    longitude = json["longitude"];
    latitude = json["latitude"];
    accuracy = json["accuracy"];
    date = json["date"];
  }
}
