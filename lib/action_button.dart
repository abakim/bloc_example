import 'package:flutter/material.dart';

/*
  Button Widget para contador
*/

class ActionButton extends StatelessWidget {
  final IconData iconData;
  final VoidCallback onPressed;

  const ActionButton({Key key, @required this.iconData, @required this.onPressed }): super(key:key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      heroTag: null, // no se le asigna etiqueta a heroTag porque puede dar error
      child: Icon(iconData),
      );
  }
}