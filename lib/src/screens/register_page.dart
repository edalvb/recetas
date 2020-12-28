import 'dart:io';

import 'package:fake_backend/user.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recetas/src/components/image_picker_widget.dart';
import 'package:recetas/src/conection/server_controller.dart';

class RegisterPage extends StatefulWidget {
  final ServerController serverController;
  final BuildContext context;
  final User userToEdit;

  RegisterPage(this.serverController, this.context, {Key key, this.userToEdit})
      : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _loading;
  GlobalKey<FormState> _formKey;
  GlobalKey<ScaffoldState> _scaffKey;

  String userName;
  String password;
  Genrer genrer;

  bool showPassword;

  String _errorMessage;

  PickedFile imageFile;

  bool editingUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffKey,
      body: Form(
        key: _formKey,
        child: Stack(
          children: <Widget>[
            ImagePickerWidget(
              imageFile: this.imageFile,
              onImageSelected: (PickedFile file) {
                setState(() {
                  this.imageFile = file;
                });
              },
            ),
            SizedBox(
              child: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                iconTheme: IconThemeData(color: Colors.white),
              ),
              height: kToolbarHeight + 20,
            ),
            Center(
              child: Transform.translate(
                offset: Offset(0, -60),
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
                    child: ListView(
                      children: <Widget>[
                        TextFormField(
                          initialValue: this.userName,
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
                          height: 20,
                        ),
                        TextFormField(
                          initialValue: this.password,
                          decoration: InputDecoration(
                              labelText: "Contraseña",
                              suffixIcon: IconButton(
                                icon: Icon(showPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () => setState(() {
                                  showPassword = !showPassword;
                                }),
                              )),
                          obscureText: !showPassword,
                          onSaved: (value) {
                            password = value;
                          },
                          validator: (value) {
                            if (value.isEmpty)
                              return "Este Campo es Oblicatorio";
                          },
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Género",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[700]),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  RadioListTile(
                                    title: Text(
                                      "Masculino",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    value: Genrer.MALE,
                                    groupValue: genrer,
                                    onChanged: (value) => setState(() {
                                      genrer = value;
                                    }),
                                  ),
                                  RadioListTile(
                                    title: Text(
                                      "Femenino",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    value: Genrer.FEMALE,
                                    groupValue: genrer,
                                    onChanged: (value) => setState(() {
                                      genrer = value;
                                    }),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Theme(
                          data: Theme.of(context)
                              .copyWith(accentColor: Colors.white),
                          child: RaisedButton(
                            color: Theme.of(context).primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            textColor: Colors.white,
                            onPressed: () async => _doProcess(context),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text((this.editingUser
                                    ? "Actualizar"
                                    : "Registrar")),
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
                      ],
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

  @override
  void initState() {
    super.initState();
    this._loading = false;
    this._errorMessage = "";
    this.genrer = Genrer.MALE;
    this.showPassword = false;
    this._formKey = GlobalKey<FormState>();
    this._scaffKey = GlobalKey<ScaffoldState>();
    this.editingUser = (widget.userToEdit != null);

    if (this.editingUser) {
      this.userName = widget.userToEdit.nickname;
      this.password = widget.userToEdit.password;
      this.imageFile = PickedFile(widget.userToEdit.photo.path);
      this.genrer = widget.userToEdit.genrer;
    }
  }

  _doProcess(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      if (imageFile == null) {
        print("No hay imagen");
        this._showSnackBar(
            context, "Seleccione una imagen porfavor", Colors.orange);
        return;
      }
      User user = User(
        genrer: this.genrer,
        nickname: this.userName,
        password: this.password,
        photo: File(this.imageFile.path),
      );
      var state;

      if (editingUser) {
        user.id = widget.serverController.loggerUser.id;
        state = await widget.serverController.updateUser(user);
      } else {
        state = await widget.serverController.addUser(user);
      }

      if (!state) {
        _showSnackBar(
            context,
            "No se pudo ${editingUser ? "actualizar" : "guardar"}",
            Colors.orange);
      }
      {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Información"),
              content: Text(
                  "Su usuario ha sido ${this.editingUser ? "actualiz" : "registr"}ado exitosamente."),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text("Ok"),
                ),
              ],
            );
          },
        );
      }
    }
  }

  void _showSnackBar(BuildContext context, String title, Color backaColor) {
    _scaffKey.currentState.showSnackBar(
      SnackBar(
        content: Text(
          title,
          textAlign: TextAlign.center,
        ),
        backgroundColor: backaColor,
      ),
    );
  }
}
