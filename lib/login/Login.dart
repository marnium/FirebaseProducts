import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:productos/home/Home.dart';
import 'package:productos/register/Register.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final _controllerEmail = TextEditingController();
  final _controllerPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Login'),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: 8.0, bottom: 8.0, left: 16.0, right: 16.0),
              child: TextFormField(
                validator: (value) {
                  if (value.trim().isEmpty) {
                    return 'Escribe tu email';
                  }
                  return null;
                },
                controller: _controllerEmail,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    icon: Icon(Icons.email), labelText: 'Email'),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: 8.0, bottom: 16.0, left: 16.0, right: 16.0),
              child: TextFormField(
                validator: (value) {
                  if (value.trim().isEmpty) {
                    return 'Escribe tu contraseña';
                  }
                  return null;
                },
                obscureText: true,
                controller: _controllerPassword,
                decoration: InputDecoration(
                    icon: Icon(Icons.security), labelText: 'Contraseña'),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  child: Text('Acceder'),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _signInWithEmailAndPassword();
                    }
                  },
                ),
                ElevatedButton(
                  child: Text('Crear nueva cuenta'),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => Register()));
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  _signInWithEmailAndPassword() async {
    /*try {
      _auth
          .signInWithEmailAndPassword(
              email: _controllerEmail.text.trim(),
              password: _controllerPassword.text.trim())
          .then(
        (_) {
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) => Home()));
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: [Text(e.message)],
          );
        },
      );
    }
  }*/
    try {
      final User user = (await _auth.signInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      ))
          .user;
      /*if (!user.emailVerified) {
        await user.sendEmailVerification();
      }*/
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => Home(
                user: user,
              )));
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: [Text(e.message)],
          );
        },
      );
    }
  }
}
