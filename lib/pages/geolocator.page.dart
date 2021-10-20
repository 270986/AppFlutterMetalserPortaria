import 'package:app_flutter/controllers/geolocator.controller.dart';
import 'package:app_flutter/widgets/card_item.widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

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
      body: Observer(builder: (_) {
        return controller.isLoading ? loaderWidget() : homePage();
      }),
      drawer: Container(color: Colors.blue),
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

  Widget loaderWidget() {
    return controller.isLoading ? loader() : homePage();
  }

  Widget loader() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            strokeWidth: 2,
          )
        ],
      ),
    );
  }

  Widget homePage() {
    return Container(
      padding: EdgeInsets.only(top: 15),
      alignment: Alignment.center,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              height: 130,
              color: Colors.lightGreenAccent,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.pontosList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CardItem(
                      title: controller.pontosList[index],
                    );
                  })),
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
    );
  }
}
