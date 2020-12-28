import 'dart:io';

import 'package:fake_backend/models.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recetas/src/components/image_picker_widget.dart';
import 'package:recetas/src/components/ingredient_widget.dart';
import 'package:recetas/src/conection/server_controller.dart';

class AddRecipePage extends StatefulWidget {
  final ServerController serverController;
  final Recipe recipe;

  AddRecipePage(this.serverController, {Key key, this.recipe})
      : super(key: key);

  @override
  _AddRecipePageState createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  String name = "", description = "";
  List<String> ingredientsList = [], stepList = [];

  File photoFile;
  PickedFile imageFile;

  final nIngredientController = TextEditingController();
  final nPasoController = TextEditingController();

  bool editing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Form(
        key: formKey,
        child: Stack(
          children: [
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
                actions: [
                  IconButton(
                      icon: Icon(Icons.save), onPressed: () => _save(context))
                ],
              ),
              height: kToolbarHeight + 20,
            ),
            Center(
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: const EdgeInsets.only(
                    left: 20, right: 20, top: 200, bottom: 20),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
                  child: ListView(
                    children: <Widget>[
                      TextFormField(
                        initialValue: this.name,
                        decoration: InputDecoration(
                          labelText: "Nombre de receta",
                        ),
                        onSaved: (value) {
                          this.name = value;
                        },
                        validator: (value) {
                          if (value.isEmpty) return "Llene éste campo";
                        },
                      ),
                      TextFormField(
                        initialValue: this.description,
                        decoration: InputDecoration(
                          labelText: "Descripción",
                        ),
                        onSaved: (value) {
                          this.description = value;
                        },
                        validator: (value) {
                          if (value.isEmpty) return "Llene éste campo";
                        },
                        maxLines: 6,
                      ),
                      SizedBox(height: 20),
                      ListTile(
                        title: Text("Ingredientes"),
                        trailing: FloatingActionButton(
                          heroTag: "uno",
                          // Si hay 2 heroTag con el mismo valor cuando se quiere abrir otra pantalla, falla.
                          child: Icon(Icons.add),
                          onPressed: () {
                            _ingredientDialog(context);
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      getIngredientsList(),
                      SizedBox(height: 20),
                      ListTile(
                        title: Text("Pasos"),
                        trailing: FloatingActionButton(
                          heroTag: "dos",
                          // Si hay 2 heroTag con el mismo valor cuando se quiere abrir otra pantalla, falla.
                          child: Icon(Icons.add),
                          onPressed: () {
                            _stepDialog(context);
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      getStepsList(),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getIngredientsList() {
    if (ingredientsList.length == 0) {
      return Text(
        "Listado Vacio",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey),
      );
    } else {
      return Column(
        children: List.generate(ingredientsList.length, (index) {
          return IngredientWidget(
            index: index,
            ingredientName: ingredientsList[index],
            onIngredientDeleteCallback: (index) {
              questionDialog(context, "¿Seguro desear eliminar el ingrediente?",
                  () {
                setState(() {
                  ingredientsList.removeAt(index);
                });
              });
            },
            onIngredientEditCallback: (index) {
              setState(() {
                _ingredientDialog(context,
                    ingredient: ingredientsList[index], index: index);
              });
            },
          );
        }),
      );
    }
  }

  void _ingredientDialog(BuildContext context, {String ingredient, int index}) {
    final textController = TextEditingController(text: ingredient);
    final editing = ingredient != null;

    final onSave = () {
      final text = textController.text;
      if (text.isEmpty)
        _showSnack("El nombre está vacío");
      else {
        setState(() {
          if (editing) {
            ingredientsList[index] = text;
          } else {
            ingredientsList.add(text);
          }
          Navigator.pop(context);
        });
      }
    };

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("${editing ? "Editando" : "Agregando"} ingredient"),
            content: TextField(
              controller: textController,
              decoration: InputDecoration(labelText: "Ingrediente"),
              onEditingComplete: onSave,
            ),
            actions: [
              FlatButton(
                child: Text("Cancelar"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("${editing ? "Actualizar" : "Guardar"}"),
                onPressed: onSave,
              ),
            ],
          );
        });
  }

  _showSnack(String texto, {Color color = Colors.orange}) {
    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(texto),
      backgroundColor: color,
    ));
  }

  Widget getStepsList() {
    if (stepList.length == 0) {
      return Text(
        "Listado Vacio",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey),
      );
    } else {
      return Column(
        children: List.generate(stepList.length, (index) {
          return IngredientWidget(
            index: index,
            ingredientName: stepList[index],
            onIngredientDeleteCallback: (index) {
              questionDialog(context, "¿Seguro desear eliminar el paso?", () {
                setState(() {
                  stepList.removeAt(index);
                });
              });
            },
            onIngredientEditCallback: (index) {
              setState(() {
                _stepDialog(context, step: stepList[index], index: index);
              });
            },
          );
        }),
      );
    }
  }

  void _stepDialog(BuildContext context, {String step, int index}) {
    final textController = TextEditingController(text: step);
    final editing = step != null;

    final onSave = () {
      final text = textController.text;
      if (text.isEmpty)
        _showSnack("El paso está vacío");
      else {
        setState(() {
          if (editing) {
            stepList[index] = text;
          } else {
            stepList.add(text);
          }
          Navigator.pop(context);
        });
      }
    };

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("${editing ? "Editando" : "Agregando"} pasos"),
          content: TextField(
            controller: textController,
            decoration: InputDecoration(labelText: "Paso"),
            textInputAction: TextInputAction.newline,
            maxLines: 6,
            // onEditingComplete: onSave,
          ),
          actions: [
            FlatButton(
              child: Text("Cancelar"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text("${editing ? "Actualizar" : "Guardar"}"),
              onPressed: onSave,
            ),
          ],
        );
      },
    );
  }

  void questionDialog(BuildContext context, String message, VoidCallback onOk) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(message),
          actions: [
            FlatButton(
              child: Text("No"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                  onOk();
                },
                child: Text("Si")),
          ],
        );
      },
    );
  }

  void _save(BuildContext context) async {
    bool saved = false;

    if (!formKey.currentState.validate()) return;

    formKey.currentState.save();

    if (imageFile == null) {
      _showSnack("La imágen está vacía.", color: Colors.grey[900]);
      return;
    }
    if (ingredientsList.length == 0) {
      _showSnack("No tiene ingredientes.", color: Colors.grey[900]);
      return;
    }
    if (stepList.length == 0) {
      _showSnack("Porfavor agrega pasos a su receta.", color: Colors.grey[900]);
      return;
    }

    final recipe = Recipe(
        name: this.name,
        description: this.description,
        ingredients: this.ingredientsList,
        steps: this.stepList,
        photo: File(this.imageFile.path),
        user: widget.serverController.loggerUser,
        date: DateTime.now());

    if (editing) {
      recipe.id = widget.recipe.id;
      saved = await widget.serverController.updateRecipe(recipe);
    } else {
      final recipe2 = await widget.serverController.addRecipe(recipe);
      saved = recipe2 != null;
    }

    if (saved) {
      Navigator.pop(context, recipe);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text("Receta guardada exitosamente"),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Ok"))
            ],
          );
        },
      );
    } else {
      _showSnack("No se pudo guardar", color: Colors.grey[900]);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    editing = widget.recipe != null;

    if (editing) {
      name = widget.recipe.name;
      description = widget.recipe.description;
      ingredientsList = widget.recipe.ingredients;
      stepList = widget.recipe.steps;
      imageFile = PickedFile(widget.recipe.photo.path);
    }
  }
}
