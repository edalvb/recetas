import 'package:fake_backend/recipe.dart';
import 'package:flutter/material.dart';
import 'package:recetas/src/conection/server_controller.dart';

class RecipeWidget extends StatelessWidget {
  final Recipe recipe;
  final ServerController serverController;
  final VoidCallback onChange;

  RecipeWidget({this.recipe, this.serverController, this.onChange, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const border = 20.0;

    return Padding(
      padding: EdgeInsets.fromLTRB(15, 20, 15, 0),
      child: GestureDetector(
        onTap: () => _showDetails(context),
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(border)),
          child: Container(
            height: 250,
            width: double.infinity,
            alignment: Alignment.bottomLeft,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(border),
              image: DecorationImage(
                  image: FileImage(recipe.photo), fit: BoxFit.cover),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.35),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(border),
                ),
              ),
              child: ListTile(
                title: Text(
                  recipe.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  recipe.user.nickname,
                  style: TextStyle(color: Colors.white),
                ),
                trailing: _getFavoriteWidget(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getFavoriteWidget() {
    return FutureBuilder<bool>(
      future: serverController.getIsFavorite(recipe),
      builder: (context, snaphot) {
        if (snaphot.hasData) {
          final isFavorite = snaphot.data;
          if (isFavorite) {
            return IconButton(
              icon: Icon(Icons.favorite),
              color: Colors.red,
              onPressed: () async {
                await serverController.deleteFavorite(recipe);
                onChange();
              },
            );
          } else {
            return IconButton(
              icon: Icon(Icons.favorite_border),
              color: Colors.red,
              onPressed: () async {
                onChange();
                await serverController.addFavorite(recipe);
              },
            );
          }
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  _showDetails(BuildContext context) {
    Navigator.pushNamed(context, "/details", arguments: recipe);
  }
}
