import 'package:flutter/material.dart';
import 'package:productos/updateProduct/FormUpdate.dart';

// ignore: must_be_immutable
class UpdateProduct extends StatefulWidget {
  final Map<String, dynamic> dataMainPage;
  Function callbackUpdate;
  UpdateProduct({
    Key key,
    this.dataMainPage,
    this.callbackUpdate,
  }) : super(key: key);

  @override
  _UpdateProductState createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text('Actualizar producto'),
          backgroundColor: Colors.purple,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: SafeArea(
          child:
              ListView(padding: EdgeInsets.symmetric(vertical: 8.0), children: [
            FormUpdate(
              dataArticle: widget.dataMainPage,
              callbackUpdate: widget.callbackUpdate,
            ),
          ]),
        ));
  }
}
