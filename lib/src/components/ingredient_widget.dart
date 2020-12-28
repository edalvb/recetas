import 'package:flutter/material.dart';

typedef OnIngredientCallback = void Function(int index);

class IngredientWidget extends StatelessWidget {
  final int index;
  final String ingredientName;
  final OnIngredientCallback onIngredientDeleteCallback;
  final OnIngredientCallback onIngredientEditCallback;

  const IngredientWidget({
    Key key,
    this.index,
    this.ingredientName,
    this.onIngredientDeleteCallback,
    this.onIngredientEditCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backColor = Colors.white;
    if ((index % 2) == 1) {
      backColor = Colors.grey[300];
    }

    return DecoratedBox(
      decoration: BoxDecoration(color: backColor),
      child: ListTile(
        leading: Text(
          "${index + 1}",
          style: TextStyle(fontSize: 16),
        ),
        title: Text(
          ingredientName,
          style: TextStyle(fontSize: 16),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  this.onIngredientEditCallback(index);
                }),
            IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  this.onIngredientDeleteCallback(index);
                }),
          ],
        ),
      ),
    );
  }
}
