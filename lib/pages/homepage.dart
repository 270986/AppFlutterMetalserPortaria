import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bem vindo ao App da Metalser"),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
      ),
      drawer: Container(color: Colors.blue),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add_alert),
          onPressed: () {
            print("Pressionado");
          }),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 40.0,
          child: Row(
            children: <Widget>[
              Text("Desenvolvido por Metalser - TI"),
              Icon(Icons.update)
            ],
          ),
        ),
        color: Colors.lime,
      ),
    );
  }
}
