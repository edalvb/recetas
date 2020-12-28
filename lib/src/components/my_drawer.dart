import 'package:flutter/material.dart';
import 'package:recetas/src/conection/server_controller.dart';

class MyDrawer extends StatelessWidget {
  final ServerController serverController;

  const MyDrawer({
    @required ServerController serverController,
    Key key,
  })  : this.serverController = serverController,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
                image: DecorationImage(
                  // image: NetworkImage(
                  //   "https://backgrounddownload.com/wp-content/uploads/2018/09/navigation-header-background-image-android-1.jpg",
                  // ),
                  image: FileImage(serverController.loggerUser.photo),
                  fit: BoxFit.cover,
                ),
                color: Colors.black),
            accountName: Text(
              serverController.loggerUser.nickname,
              style: TextStyle(color: Colors.white),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage: FileImage(serverController.loggerUser.photo),
            ),
            onDetailsPressed: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed("/register",
                  arguments: serverController.loggerUser);
            },
          ),
          ListTile(
            title: Text(
              "Mis Recetas",
              style: TextStyle(fontSize: 18),
            ),
            leading: Icon(
              Icons.book,
              color: Colors.green,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed("/my_recipes");
            },
          ),
          ListTile(
            title: Text(
              "Mis Favoritos",
              style: TextStyle(fontSize: 18),
            ),
            leading: Icon(
              Icons.favorite,
              color: Colors.red,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed("/favorites");
            },
          ),
          ListTile(
            title: Text(
              "Cerrar Sesión",
              style: TextStyle(fontSize: 18),
            ),
            leading: Icon(
              Icons.power_settings_new,
              color: Colors.cyan,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, "/");
            },
          ),
        ],
      ),
    );
  }
}
