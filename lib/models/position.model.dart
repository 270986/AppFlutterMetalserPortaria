class PositionModel {
  double longitude;
  double latitude;
  double accuracy;
  String date;
  int ponto;
  String usuario;

  PositionModel(
      {this.accuracy, this.date, this.latitude, this.longitude, this.ponto});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Date'] = this.date;
    data['Usuario'] = this.usuario;
    data['Latitude'] = this.latitude;
    data['Longitude'] = this.longitude;
    data['Ponto'] = this.ponto;
    data['Accuracy'] = this.accuracy;

    return data;
  }

  PositionModel.toJson(Map<String, dynamic> json) {
    longitude = json["longitude"];
    latitude = json["latitude"];
    accuracy = json["accuracy"];
    date = json["date"];
    ponto = json["ponto"];
  }
}
