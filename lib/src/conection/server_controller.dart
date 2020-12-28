import 'package:fake_backend/fake_backend.dart' as server;
import 'package:fake_backend/models.dart';
import 'package:flutter/cupertino.dart';

class ServerController {
  User loggerUser;

  void init(BuildContext context) {
    server.generateData(context);
  }

  Future<User> login(String userName, String password) async =>
      await server.backendLogin(userName, password);

  Future<bool> addUser(User user) async => await server.addUser(user);

  Future<List<Recipe>> getRecipesList() async => await server.getRecipes();

  Future<bool> getIsFavorite(Recipe recipeToCheck) async =>
      await server.isFavorite(recipeToCheck);

  Future<Recipe> addFavorite(Recipe nFavorite) async =>
      await server.addFavorite(nFavorite);

  Future<bool> deleteFavorite(Recipe favoriteRecipe) async =>
      await server.deleteFavorite(favoriteRecipe);

  Future<bool> updateUser(User user) async {
    loggerUser = user;
    return await server.updateUser(user);
  }

  Future<List<Recipe>> getFavoritesList() async => await server.getFavorites();

  Future<List<Recipe>> getUserRecipesList() async =>
      await server.getUserRecipes(loggerUser);

  Future<Recipe> addRecipe(Recipe nRecipe) async =>
      await server.addRecipe(nRecipe);

  Future<bool> updateRecipe(Recipe recipe) async =>
      await server.updateRecipe(recipe);
}
