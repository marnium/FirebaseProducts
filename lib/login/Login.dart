import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:productos/home/Home.dart';
import 'package:productos/register/Register.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final Color _primaryColor = Color(0xff18203d);
  final Color _secondaryColor = Color(0xff232c51);
  final Color _logoGreen = Color(0xff25bcbb);

  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _scaffKey = GlobalKey<ScaffoldState>();

  bool isProcessingQuery = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Center(
          child: Text(
            'Login',
            style: TextStyle(
              fontSize: 28,
              color: Colors.white,
            ),
          ),
        ),
      ),
      backgroundColor: _primaryColor,
      body: Form(
        key: _formKey,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                _buildField(_emailController, Icons.email, 'Email',
                    keyboardType: TextInputType.emailAddress),
                SizedBox(
                  height: 20,
                ),
                _buildField(_passwordController, Icons.lock, 'Contraseña',
                    obscureText: true),
                SizedBox(
                  height: 40,
                ),
                MaterialButton(
                  minWidth: double.maxFinite,
                  height: 50,
                  color: _logoGreen,
                  child: isProcessingQuery
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              backgroundColor: Colors.white,
                            ),
                            SizedBox(
                              width: 20.0,
                            ),
                            Text('Acceder',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16)),
                          ],
                        )
                      : Text('Acceder',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                  onPressed: () {
                    if (_formKey.currentState.validate() &&
                        !isProcessingQuery) {
                      print('Empezando consulta');
                      setState(() {
                        isProcessingQuery = true;
                      });
                      _signInWithEmailAndPassword();
                    }
                  },
                ),
                SizedBox(height: 20),
                MaterialButton(
                  minWidth: double.maxFinite,
                  height: 50,
                  color: Colors.blue,
                  child: Text('Crear nueva cuenta',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  onPressed: isProcessingQuery
                      ? null
                      : () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => Register()));
                        },
                  onLongPress: null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildField(TextEditingController controller, IconData icon, String labelText,
      {TextInputType keyboardType = TextInputType.text,
      bool obscureText = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: _secondaryColor, border: Border.all(color: Colors.blue)),
      child: TextFormField(
        keyboardType: keyboardType,
        obscureText: obscureText,
        controller: controller,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            labelText: labelText,
            labelStyle: TextStyle(color: Colors.white),
            icon: Icon(
              icon,
              color: Colors.white,
            ),
            border: InputBorder.none),
        validator: (value) {
          if (value.trim().isEmpty) {
            return 'Escribe tu $labelText';
          }
          return null;
        },
      ),
    );
  }

  _signInWithEmailAndPassword() async {
    try {
      UserCredential user = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => Home(
          user: user.user,
        ),
      ));
    } on FirebaseAuthException catch (e) {
      print('Datos incorrectos...');
      if (e.code == 'invalid-email')
        _showMessage(
            'La dirección email no tiene un formato valido. Debe de contener "@"');
      else if (e.code == 'user-not-found')
        _showMessage(
            'Nose encontro ninguna cuenta registrada con este email. Verifique su email');
      else if (e.code == 'wrong-password')
        _showMessage('La contraseña es incorrecta');
      else if (e.code == 'too-many-requests')
        _showMessage('Demasiados intentos fallidos. Intentar mas tarde');
      else if (e.code == 'unknown')
        _showMessage(
            'No se pudo establecer conexión con el servidor. Compruebe su conexión a Internet.');
      else
        _showMessage('Mensaje: ${e.message}. Codigo: ${e.code}');
    } catch (e) {
      _showMessage('Error desconocido');
      print(e);
    } finally {
      print('Fin consulta');
      setState(() {
        isProcessingQuery = false;
      });
    }
  }

  void _showMessage(String msg) {
    _scaffKey.currentState.hideCurrentSnackBar();
    _scaffKey.currentState.showSnackBar(SnackBar(
      duration: Duration(seconds: 15),
      backgroundColor: Colors.amberAccent,
      content: Text(
        msg,
        style: TextStyle(
          fontSize: 20,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    ));
  }
}
