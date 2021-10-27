import 'package:flutter/material.dart';
import 'package:app_flutter/controllers/geolocator.controller.dart';

class BestGeolocator extends StatelessWidget {
  final controller = GeolocatorController();
  //final String title;
  //final Function selecionaPonto;
  //BestGeolocator({this.title, this.selecionaPonto});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15),
      alignment: Alignment.center,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                Text("Precisão: " + controller.accuracy),
                Text("Latitude: " + controller.latitude),
                Text("Longitude: " + controller.longitude),
                Text("Precisão: " + controller.accuracy),
                Text("DataLancamento: " + controller.date.toString()),
                SizedBox(
                  height: 60,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
