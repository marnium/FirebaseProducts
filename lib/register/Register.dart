import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:productos/home/Home.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _controllerFullName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    _controllerFullName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Registrate'),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _controllerFullName,
                decoration: const InputDecoration(
                    labelText: 'Nombre Completo',
                    icon: Icon(
                      Icons.person,
                    )),
                validator: (String value) {
                  if (value.trim().isEmpty) {
                    return 'Escribe tu nombre completo';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _controllerEmail,
                decoration: const InputDecoration(
                    labelText: 'Email', icon: Icon(Icons.email)),
                validator: (String value) {
                  if (value.trim().isEmpty) {
                    return 'Escribe tu email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _controllerPassword,
                decoration: const InputDecoration(
                    labelText: 'Contraseña', icon: Icon(Icons.security)),
                validator: (String value) {
                  if (value.trim().isEmpty) {
                    return 'Escribe tu contraseña';
                  }
                  return null;
                },
                obscureText: true,
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                alignment: Alignment.center,
                child: ElevatedButton(
                  child: Text("Registrar"),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _registerAccount();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _registerAccount() async {
    /*final User user = (await _auth.createUserWithEmailAndPassword(
      email: _controllerEmail.text,
      password: _controllerPassword.text,
    ))
        .user;

    if (user != null) {
      if (!user.emailVerified) {
        await user.sendEmailVerification();
      }
      await user.updateProfile(displayName: _controllerFullName.text);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => Home(
                user: user,
              )));
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: [Text('No se pudo registrar. Intentelo de nuevo')],
          );
        },
      );
    }*/
    try {
      User user = (await _auth.createUserWithEmailAndPassword(
              email: _controllerEmail.text.trim(),
              password: _controllerPassword.text.trim()))
          .user;

      await user.updateProfile(displayName: _controllerFullName.text.trim());
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => Home(
                user: _auth.currentUser,
              )));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print(
            'La contraseña es debil. Escriba una mezclando letras y numeros.');
      } else if (e.code == 'email-already-in-use') {
        print('Ya existe una cuenta para este emial. Escriba otro emial');
      } else if (e.code == 'invalid-email') {
        print('El email no es valido');
      }
    } catch (e) {
      print(e);
    }
  }
}
