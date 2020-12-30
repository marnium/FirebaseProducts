import 'package:flutter/material.dart';
import 'FormAdd.dart';

// ignore: must_be_immutable
class AddProduct extends StatelessWidget {
  Function callbackInsert;
  AddProduct({
    Key key,
    this.callbackInsert,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text('Agregar producto'),
          backgroundColor: Colors.purple,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: SafeArea(
          child:
              ListView(padding: EdgeInsets.symmetric(vertical: 8.0), children: [
            FormAdd(callbackInsert: callbackInsert),
          ]),
        ));
  }
}
