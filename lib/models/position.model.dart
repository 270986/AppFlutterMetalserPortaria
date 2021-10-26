class PositionModel {
  double longitude;
  double latitude;
  double accuracy;
  DateTime date;
  int ponto;
  String usuario;

  PositionModel(
      {this.accuracy, this.date, this.latitude, this.longitude, this.ponto});

  PositionModel.toJson(Map<String, dynamic> json) {
    longitude = json["longitude"];
    latitude = json["latitude"];
    accuracy = json["accuracy"];
    date = json["date"];
    ponto = json["ponto"];
  }
}
