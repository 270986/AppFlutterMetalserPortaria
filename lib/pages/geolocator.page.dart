import 'package:app_flutter/controllers/geolocator.controller.dart';
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
        title: Text("Metalser Portaria"),
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
    return loader();
    //   return controller.isLoading ? loader() : homePage();
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
          Center(
            child: Column(
              children: [
                SizedBox(
                  height: 160,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    child: (Text("Registrar Ronda")),
                    style: ElevatedButton.styleFrom(
                      shape: const BeveledRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        controller.toggleListening(context);
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                //BestGeolocator(),
                Container(
                  padding: EdgeInsets.only(top: 15),
                  alignment: Alignment.center,
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            Text("Ponto: " +
                                controller.pontoEncontrado.toString()),
                            Text("Latitude: " + controller.latitude),
                            Text("Longitude: " + controller.longitude),
                            Text("Precisão: " + controller.accuracy),
                            Text("Data: " + controller.date.toString()),
                            SizedBox(
                              height: 60,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    child: (Text("Enviar Dados")),
                    style: ElevatedButton.styleFrom(
                      shape: const BeveledRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        controller.envioAPI(context);
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
