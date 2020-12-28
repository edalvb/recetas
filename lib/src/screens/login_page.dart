import 'package:fake_backend/user.dart';
import 'package:flutter/material.dart';
import 'package:recetas/src/conection/server_controller.dart';

class LoginPage extends StatefulWidget {
  final ServerController serverController;
  final BuildContext context;

  LoginPage(this.serverController, this.context, {Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _loading;
  GlobalKey<FormState> _formKey;

  String userName;
  String password;

  String _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 30),
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.cyan[300],
                    Colors.cyan[800],
                  ],
                ),
              ),
              child: Image.asset(
                "assets/images/logo.png",
                color: Colors.white,
                height: 160,
              ),
            ),
            Transform.translate(
              offset: Offset(0, -60),
              child: Center(
                child: SingleChildScrollView(
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: const EdgeInsets.only(
                        left: 20, right: 20, top: 200, bottom: 20),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 35, vertical: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          TextFormField(
                            initialValue: "user",
                            decoration: InputDecoration(
                              labelText: "Usuario",
                            ),
                            onSaved: (value) {
                              userName = value;
                            },
                            validator: (value) {
                              if (value.isEmpty)
                                return "Este Campo es Oblicatorio";
                            },
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          TextFormField(
                            initialValue: "user",
                            decoration: InputDecoration(
                              labelText: "Contraseña",
                            ),
                            obscureText: true,
                            onSaved: (value) {
                              password = value;
                            },
                            validator: (value) {
                              if (value.isEmpty)
                                return "Este Campo es Oblicatorio";
                            },
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Theme(
                            data: Theme.of(context)
                                .copyWith(accentColor: Colors.white),
                            child: RaisedButton(
                              color: Theme.of(context).primaryColor,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              textColor: Colors.white,
                              onPressed: () async => _login(context),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Iniciar Sesión"),
                                  if (_loading)
                                    Container(
                                      height: 20,
                                      width: 20,
                                      margin: const EdgeInsets.only(left: 20),
                                      child: CircularProgressIndicator(),
                                    )
                                ],
                              ),
                            ),
                          ),
                          if (_errorMessage.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _errorMessage,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("¿No estas registrado?"),
                              FlatButton(
                                textColor: Theme.of(context).primaryColor,
                                onPressed: () => _showRegister(context),
                                child: Text("Registrarse"),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _login(BuildContext context) async {
    if (!_loading) {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
        setState(() {
          _loading = true;
          this._errorMessage = "";
        });
        User user = await widget.serverController.login(userName, password);
        if (user != null) {
          Navigator.of(context).pushReplacementNamed("/home", arguments: user);
        } else {
          setState(() {
            this._errorMessage = "Usuario o Contraseña incorrecto.";
            _loading = false;
          });
        }
      }
    }
  }

  _showRegister(BuildContext context) =>
      Navigator.of(context).pushNamed("/register");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._loading = false;
    this._formKey = GlobalKey<FormState>();
    this.userName = "";
    this.password = "";
    this._errorMessage = "";
    widget.serverController.init(widget.context);
  }
}
