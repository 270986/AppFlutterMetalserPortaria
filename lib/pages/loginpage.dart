import 'package:app_flutter/pages/alerta.dart';
import 'package:app_flutter/pages/geolocator.page.dart';

//import 'package:app_flutter/pages/homepage.dart';
import 'package:app_flutter/pages/loginapi.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final _ctrlLogin = TextEditingController();
  final _ctrlSenha = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(context),
    );
  }

  _body(BuildContext context) {
    return Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.all(15),
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 150.0,
                child: Image.asset("assets/images/Logo_Metalser.png",
                    fit: BoxFit.contain),
              ),
              SizedBox(height: 50.0),
              _textFormField("Usuário", "Digite o Usuário",
                  controller: _ctrlLogin, validator: _validaLogin),
              SizedBox(height: 30.0),
              _textFormField("Senha", "Digite a Senha",
                  senha: true, controller: _ctrlSenha, validator: _validaSenha),
              SizedBox(height: 50.0),
              _raisedButton("Entrar", Colors.blue, context),
            ],
          ),
        ));
  }

  _textFormField(
    String label,
    String hint, {
    bool senha = false,
    TextEditingController controller,
    FormFieldValidator<String> validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: senha,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );
  }

  String _validaLogin(String texto) {
    if (texto.isEmpty) {
      return "Digite o Usuário";
    }
    return null;
  }

  String _validaSenha(String texto) {
    if (texto.isEmpty) {
      return "Digite a Senha";
    }
    return null;
  }

  _raisedButton(String texto, Color cor, BuildContext context) {
    // ignore: deprecated_member_use
    return RaisedButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      color: cor,
      padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
      child: Text(texto,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          )),
      onPressed: () {
        _clickButton(context);
      },
    );
  }

  _clickButton(BuildContext context) async {
    bool formOk = _formKey.currentState.validate();

    if (!formOk) {
      return;
    }
    String username = _ctrlLogin.text;
    String password = _ctrlSenha.text;

    print("login : $username senha : $password");

    var usuario = await LoginApi.login(username, password);
    if (usuario != null) {
      _navegaHomepage(context);
    } else {
      alert(context, "Login Inválido");
    }
  }

  _navegaHomepage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GeolocatorPage()),
    );
  }
}
