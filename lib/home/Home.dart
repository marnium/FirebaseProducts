import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:productos/debouncer/Debouncer.dart';
import 'package:productos/home/CreateComponent.dart';
import 'package:productos/addProduct/addProduct.dart';
import 'package:productos/models/Product.dart';
import 'package:productos/services/FirestoreService.dart';

class Home extends StatefulWidget {
  final User user;
  Home({this.user});

  @override
  _HomeState createState() => _HomeState();
}

// ignore: camel_case_types
class _HomeState extends State<Home> {
  FirestoreService firestoreService = FirestoreService();
  //bool _isSearching = false;
  //String valNew = "";
  //TextEditingController ContentSearch = TextEditingController();

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

  /*Widget _getAppBarNotSearching(String title) {
    return AppBar(
      title: Text(title),
      backgroundColor: Colors.purple,
      iconTheme: IconThemeData(color: Colors.white),
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              _startSearching();
            }),
      ],
    );
  }

  Widget _getAppBarSearching() {
    final debouncer = Debouncer();
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.purple,
      iconTheme: IconThemeData(color: Colors.white),
      leading: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            _cancelSearching();
          }),
      title: Padding(
        padding: const EdgeInsets.only(bottom: 0, right: 10),
        child: TextField(
          controller: ContentSearch,
          onChanged: (String val) {
            if (_isSearching) {
              debouncer.run(() {
                setState(() {
                  valNew = val;
                });
              });
            }
          },
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
          cursorColor: Colors.white,
          autofocus: true,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            focusColor: Colors.white,
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
          ),
        ),
      ),
    );
  }

  void _startSearching() {
    setState(() {
      _isSearching = true;
      ContentSearch.clear();
    });
  }

  void _cancelSearching() {
    setState(() {
      _isSearching = false;
      valNew = "";
      ContentSearch.clear();
    });
  }*/

  void callbackDelete(String id) {
    setState(() {
      firestoreService.deleteProduct(id);
    });
  }

  void callbackInsert(Map<String, dynamic> data) {
    setState(() {
      firestoreService.addProduct(data);
      /*if (_isSearching) {
        valNew = "";
        _isSearching = false;
      }*/
    });
  }

  void callbackUpdate(Product data) {
    setState(() {
      firestoreService.updateProduct(data);
      /*if (_isSearching) {
        valNew = "";
        _isSearching = false;
      }*/
    });
  }

  /*_showList(BuildContext context) {
    return FutureBuilder(
      future: db.getSpecifiedList(valNew),
      initialData: List<Product>(),
      builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
        if (snapshot.hasData && snapshot.data.length != 0) {
          return ListView(
            padding: EdgeInsets.all(15.0),
            children: [
              for (Task task in snapshot.data)
                CreateComponent(
                  dataComponent: _convertToMap(
                      task.id, task.name, task.price, task.detail, task.amount),
                  db: db,
                  callbackDelete: callbackDelete,
                  callbackUpdate: callbackUpdate,
                ),
            ],
          );
        } else {
          return (_isSearching)
              ? Center(child: Text("Sin resultados"))
              : Center(child: Text("Agregue un producto"));
        }
      },
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.displayName),
        actions: [
          IconButton(icon: Text('Cerrar'), onPressed: () {}),
        ],
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection('productos').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData && snapshot.data.size != 0) {
              List<DocumentSnapshot> docs = snapshot.data.docs;
              return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> data = {
                      'id': docs[index].id,
                      ...docs[index].data()
                    };
                    return CreateComponent(
                      dataComponent: data,
                      callbackDelete: callbackDelete,
                      callbackUpdate: callbackUpdate,
                    );
                  });
            } else {
              return Center(child: Text('No se encontraron productos'));
            }
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
