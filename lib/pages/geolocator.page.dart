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
  var altura;
  @override
  Widget build(BuildContext context) {
    altura = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Metalser Portaria"),
        centerTitle: true,
      ),
      body: Observer(builder: (_) {
        return controller.isLoading ? loaderWidget() : outraHome();
      }),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 40.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Desenvolvido por Metalser - TI",
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
            ],
          ),
        ),
        color: Colors.blue,
      ),
    );
  }

  buildLoading(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          );
        });
  }

  Widget outraHome() {
    return Container(
      width: double.infinity,
      //
      color: Colors.white,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 20),
            child: Container(
              height: 30,
              //  color: Colors.red,
              // child: Image.asset("assets/images/Logo_Metalser.png",
              //     fit: BoxFit.contain),
            ),
          ),
          Container(
            //[] color: Colors.blue,
            height: altura * 0.33,

            child: Image.asset("assets/images/ass.png", fit: BoxFit.contain),
          ),
          Container(
            //
            color: Colors.white,
            width: double.infinity,
            height: altura * 0.4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 30),
                  child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      width: double.infinity,
                      child: _raisedButton(
                          "Registrar Localização", Colors.blue, context)),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  width: double.infinity,
                  child:
                      _raisedButton1("Finalizar Ronda", Colors.blue, context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  buildShowDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  _raisedButton(String texto, Color cor, BuildContext context) {
    // ignore: deprecated_member_use
    return RaisedButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      color: cor,
      padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
      child: Text(texto,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          )),
      onPressed: () {
        controller.toggleListening(context);
      },
    );
  }

  _raisedButton1(String texto, Color cor, BuildContext context) {
    // ignore: deprecated_member_use
    return RaisedButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      color: cor,
      padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
      child: Text(texto,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          )),
      onPressed: () {
        controller.buttonEnviarDados(context);
      },
    );
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
                      controller.buttonEnviarDados(context);
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
