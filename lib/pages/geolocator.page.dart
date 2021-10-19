import 'package:app_flutter/controllers/geolocator.controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GeolocatorPage extends StatefulWidget {
  const GeolocatorPage({Key key}) : super(key: key);

  @override
  _GeolocatorState createState() => _GeolocatorState();
}

class _GeolocatorState extends State<GeolocatorPage> {
  final controller = GeolocatorController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bem vindo ao App da Metalser"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.only(top: 15),
        alignment: Alignment.center,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 130,
              color: Colors.lightGreenAccent,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Container(
                      width: 125,
                      color: Colors.blue,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Ponto 1",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Container(
                      width: 120,
                      color: Colors.blue,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Ponto 2",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Container(
                      width: 120,
                      color: Colors.blue,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Ponto 3",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Container(
                      width: 125,
                      color: Colors.blue,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Ponto 4",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Container(
                padding: EdgeInsets.only(top: 60),
                child: Column(
                  children: [
                    Text("Precisão high"),
                    Text("Longitude: " + controller.longitude),
                    Text("Latitude: " + controller.latitude),
                    Text("Precisão: " + controller.accuracy),
                    Text("Data: " + controller.date.toString()),
                    SizedBox(
                      height: 60,
                    ),
                    ElevatedButton(
                      child: (Text("start")),
                      onPressed: () {
                        setState(() {
                          controller.toggleListening();
                        });
                      },
                    ),
                    ElevatedButton(
                      child: (Text("stop")),
                      onPressed: () {
                        setState(() {
                          controller.cancelListening();
                        });
                      },
                    ),
                    ElevatedButton(
                      child: (Text(" envio API")),
                      onPressed: () {
                        setState(() {
                          controller.envioAPI();
                        });
                      },
                    ),
                    ElevatedButton(
                      child: (Text("Limpar")),
                      onPressed: () {
                        setState(() {
                          controller.limparPosicoes();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: Container(color: Colors.blue),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add_location),
          onPressed: () {
            setState(() {
              controller.getCurrentPosition();
            });
          }),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 40.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Desenvolvido por Metalser - TI",
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),
        color: Colors.lime,
      ),
    );
  }

  teste() {
    print("teste");
  }
}
