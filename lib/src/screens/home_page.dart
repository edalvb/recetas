import 'package:fake_backend/models.dart';
import 'package:flutter/material.dart';
import 'package:recetas/src/components/my_drawer.dart';
import 'package:recetas/src/components/recipe_widget.dart';
import 'package:recetas/src/conection/server_controller.dart';

class HomePage extends StatefulWidget {
  final ServerController serverController;

  HomePage(this.serverController, {Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Cookbook"),
      ),
      drawer: MyDrawer(serverController: widget.serverController),
      body: FutureBuilder<List<Recipe>>(
        future: widget.serverController.getRecipesList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final list = snapshot.data;
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                Recipe recipe = list[index];
                return RecipeWidget(
                  recipe: recipe,
                  serverController: widget.serverController,
                  onChange: () async {
                    setState(() {
                      widget.serverController.getFavoritesList();
                    });
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
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          // color: Colors.white,
        ),
        onPressed: () {
          Navigator.of(context).pushNamed("/add_recipe");
        },
      ),
    );
  }
}
