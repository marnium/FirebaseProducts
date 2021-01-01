import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:productos/home/CreateComponent.dart';
import 'package:productos/addProduct/addProduct.dart';
import 'package:productos/login/Login.dart';
import 'package:productos/models/Product.dart';
import 'package:productos/services/FirestoreService.dart';

class Home extends StatefulWidget {
  final User user;
  Home({this.user});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirestoreService firestoreService = FirestoreService();

  Route _handleNavigationPressed() {
    return PageRouteBuilder(
      transitionDuration: const Duration(
        milliseconds: 500,
      ),
      pageBuilder: (context, animation, secondaryAnimation) => AddProduct(
        callbackInsert: callbackInsert,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var tween = Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset.zero)
            .chain(CurveTween(curve: Curves.ease));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  void callbackDelete(String id) {
    setState(() {
      firestoreService.deleteProduct(id);
    });
  }

  void callbackInsert(Map<String, dynamic> data) {
    setState(() {
      firestoreService.addProduct(data);
    });
  }

  void callbackUpdate(Product data) {
    setState(() {
      firestoreService.updateProduct(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(widget.user.displayName),
        ),
        actions: [
          DropdownButton<String>(
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
            dropdownColor: Color(0xff18203d),
            icon: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            items: <String>['Cerrar Sesión']
                .map<DropdownMenuItem<String>>((e) => DropdownMenuItem<String>(
                      child: Text(e),
                      value: e,
                    ))
                .toList(),
            onChanged: (value) {
              if (value == 'Cerrar Sesión') {
                FirebaseAuth.instance.signOut().then((value) =>
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => Login())));
              }
            },
          )
        ],
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection('productos').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              if (snapshot.data.size != 0) {
                List<DocumentSnapshot> docs = snapshot.data.docs;
                return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      return CreateComponent(
                        dataComponent: <String, dynamic>{
                          'id': docs[index].id,
                          ...docs[index].data()
                        },
                        callbackDelete: callbackDelete,
                        callbackUpdate: callbackUpdate,
                      );
                    });
              }
              return Center(child: Text('No se han agregado datos.'));
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(_handleNavigationPressed());
        },
        backgroundColor: Colors.pink[600],
        tooltip: 'Agregar producto',
        child: Icon(Icons.add),
      ),
    );
  }
}
