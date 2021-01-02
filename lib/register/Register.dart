import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:productos/home/Home.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final Color _primaryColor = Color(0xff18203d);
  final Color _secondaryColor = Color(0xff232c51);
  final Color _logoGreen = Color(0xff25bcbb);

  FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _scaffKey = GlobalKey<ScaffoldState>();
  bool isProcessingQuery = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Center(
          child: Text(
            'Registrate',
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
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  _buildField(
                      _fullNameController, Icons.person, 'Nombre Completo'),
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
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
                              Text('Registrarme',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16)),
                            ],
                          )
                        : Text('Registrarme',
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                    onPressed: () {
                      if (_formKey.currentState.validate() &&
                          !isProcessingQuery) {
                        print('Empezando consulta');
                        setState(() {
                          isProcessingQuery = true;
                        });
                        _registerAccount();
                      }
                    },
                  ),
                ],
              ),
            )),
      ),
    );
  }

  _buildField(TextEditingController controller, IconData icon, String labelText,
      {bool obscureText = false,
      TextInputType keyboardType = TextInputType.text}) {
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

  void _registerAccount() async {
    try {
      User user = (await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      ))
          .user;
      await user.updateProfile(displayName: _fullNameController.text.trim());
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => Home(
            user: _auth.currentUser,
          ),
        ),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password')
        _showMessage(
            'La contraseña es debil. Escriba una mezclando letras y numeros.');
      else if (e.code == 'email-already-in-use')
        _showMessage(
            'Ya existe una cuenta registrada con este email. Escriba otro emial');
      else if (e.code == 'invalid-email')
        _showMessage(
            'La dirección email no tiene un formato valido. Debe de contener "@"');
      else if (e.code == 'unknown')
        _showMessage(
            'No se pudo establecer conexión con el servidor. Compruebe su conexión a Internet.');
      else
        _showMessage('Mensaje: ${e.message}. Codigo: ${e.code}');
    } catch (e) {
      _showMessage('Error desconocido');
      print(e);
    } finally {
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
