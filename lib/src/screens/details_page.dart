import 'package:fake_backend/models.dart';
import 'package:flutter/material.dart';
import 'package:recetas/src/components/tab_preparation.dart';
import 'package:recetas/src/components/tap_ingredients_widget.dart';
import 'package:recetas/src/conection/server_controller.dart';

class DetailsPage extends StatefulWidget {
  Recipe recipe;
  final ServerController serverController;

  DetailsPage({this.recipe, this.serverController, Key key}) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  bool favorite;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                title: Text(widget.recipe.name),
                expandedHeight: 320,
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: FileImage(widget.recipe.photo),
                    ),
                  ),
                  child: Container(
                    color: Colors.black.withOpacity(.5),
                  ),
                ),
                pinned: true,
                bottom: TabBar(
                  labelColor: Colors.white,
                  indicatorWeight: 4,
                  tabs: <Widget>[
                    Tab(
                      child: Text(
                        "Ingredientes",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Preparación",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
                actions: [
                  if (widget.recipe.user.id ==
                      widget.serverController.loggerUser.id)
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () async {
                        final nRecipe = await Navigator.of(context).pushNamed(
                            "/edit_recipe",
                            arguments: widget.recipe);
                        setState(() {
                          widget.recipe = nRecipe as Recipe;
                        });
                      },
                    ),
                  getFavoriteWidget(),
                  IconButton(
                    icon: Icon(Icons.help_outline),
                    onPressed: () => _showAboutIt(context),
                  ),
                ],
              )
            ];
          },
          body: TabBarView(
            children: <Widget>[
              TabIngredientsWidget(
                recipe: widget.recipe,
              ),
              TabPreparation(
                recipe: widget.recipe,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getFavoriteWidget() {
    if (favorite != null) {
      if (favorite) {
        return IconButton(
          icon: Icon(Icons.favorite),
          color: Colors.red,
          onPressed: () async {
            await widget.serverController.deleteFavorite(widget.recipe);
            setState(() {
              favorite = false;
            });
          },
        );
      } else {
        return IconButton(
          icon: Icon(Icons.favorite_border),
          color: Colors.white,
          onPressed: () async {
            await widget.serverController.addFavorite(widget.recipe);
            setState(() {
              favorite = true;
            });
          },
        );
      }
    } else {
      return Container(
        margin: EdgeInsets.all(15),
        width: 30,
        child: CircularProgressIndicator(),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadState();
  }

  void loadState() async {
    final state = await widget.serverController.getIsFavorite(widget.recipe);
    setState(() {
      this.favorite = state;
    });
  }

  void _showAboutIt(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Acerca de la receta"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      "Nombre: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(widget.recipe.name),
                ],
              ),
              Divider(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: Text(
                    "Usuario: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                  Text(widget.recipe.user.nickname),
                ],
              ),
              Divider(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                      child: Text(
                    "Fecha de publicación: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                  Text(
                      "${widget.recipe.date.day}/${widget.recipe.date.month}/${widget.recipe.date.year}")
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
