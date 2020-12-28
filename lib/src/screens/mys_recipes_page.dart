import 'package:fake_backend/models.dart';
import 'package:flutter/material.dart';
import 'package:recetas/src/components/recipe_widget.dart';
import 'package:recetas/src/conection/server_controller.dart';

class MyRecipes extends StatefulWidget {
  final ServerController serverController;

  MyRecipes(this.serverController, {Key key}) : super(key: key);

  @override
  _MyRecipesState createState() => _MyRecipesState();
}

class _MyRecipesState extends State<MyRecipes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mis Recetas"),
      ),
      body: FutureBuilder<List<Recipe>>(
        future: widget.serverController.getUserRecipesList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Recipe> list = snapshot.data;

            if (list.length == 0)
              return SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.info,
                        size: 120,
                        color: Colors.grey[300],
                      ),
                      Text(
                        "Empieza creando una receta",
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );

            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                Recipe recipe = list[index];
                return RecipeWidget(
                  recipe: recipe,
                  serverController: widget.serverController,
                  onChange: () {
                    setState(() {});
                  },
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
