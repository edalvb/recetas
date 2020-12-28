import 'package:fake_backend/models.dart';
import 'package:fake_backend/user.dart';
import 'package:flutter/material.dart';
import 'package:recetas/src/conection/server_controller.dart';
import 'package:recetas/src/screens/add_recipe_page.dart';
import 'package:recetas/src/screens/details_page.dart';
import 'package:recetas/src/screens/home_page.dart';
import 'package:recetas/src/screens/login_page.dart';
import 'package:recetas/src/screens/my_favorites_page.dart';
import 'package:recetas/src/screens/mys_recipes_page.dart';
import 'package:recetas/src/screens/register_page.dart';

import 'conection/server_controller.dart';

ServerController _serverController = ServerController();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recetas',
      initialRoute: "/",
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.cyan,
        accentColor: Colors.cyan[300],
        floatingActionButtonTheme:
            FloatingActionButtonThemeData(foregroundColor: Colors.white),
        appBarTheme: AppBarTheme(
          textTheme: TextTheme(
            headline6: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          builder: (BuildContext context) {
            switch (settings.name) {
              case "/":
                return LoginPage(_serverController, context);
              case "/home":
                _serverController.loggerUser = settings.arguments as User;
                return HomePage(_serverController);
              case "/register":
                return RegisterPage(_serverController, context,
                    userToEdit: settings.arguments as User);
              case "/favorites":
                return MyFavorites(_serverController);
              case "/my_recipes":
                return MyRecipes(_serverController);
              case "/details":
                Recipe recipe = settings.arguments;
                return DetailsPage(
                  recipe: recipe,
                  serverController: _serverController,
                );
              case "/add_recipe":
                return AddRecipePage(
                  _serverController,
                );
              case "/edit_recipe":
                return AddRecipePage(
                  _serverController,
                  recipe: settings.arguments as Recipe,
                );
              default:
                return LoginPage(_serverController, context);
            }
          },
        );
      },
    );
  }
}
