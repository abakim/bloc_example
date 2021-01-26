import 'package:flutter/material.dart';
import 'action_button.dart';

class CounterScreenWithLocalState extends StatefulWidget {
  CounterScreenWithLocalState({Key key }) : super(key:key);

  @override
  _CounterScreenWithLocalStateState createState() => _CounterScreenWithLocalStateState();
}

class _CounterScreenWithLocalStateState extends State<CounterScreenWithLocalState> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Counter - Local State'),
      ),
      body: Center(
        child: Text(
          '0',
          style: TextStyle(
            fontSize: 100,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      // Centra los botones en el floating action button
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          // agrega el mismo espacio en cada widget
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
          children: <Widget>[
            ActionButton(
             iconData: Icons.add, 
             onPressed: null,
            ),
            ActionButton(
             iconData: Icons.remove, 
             onPressed: null,
            ),
            ActionButton(
             iconData: Icons.replay, 
             onPressed: null,
            ),
          ],
        ),
      ),
    );
  }
}