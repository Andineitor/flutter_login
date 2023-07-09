import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import './firebase_options.dart';
import './home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const MultiAuth(),
  );
}

class MultiAuth extends StatelessWidget {
  const MultiAuth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scrolling Infinity',
      home: MultiAuthPage(),
    );
  }
}

class MultiAuthPage extends StatefulWidget {
  const MultiAuthPage({Key? key}) : super(key: key);

  @override
  _MultiAuthPageState createState() => _MultiAuthPageState();
}

class _MultiAuthPageState extends State<MultiAuthPage> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final StreamSubscription _firebaseStreamEvents;
  String _loginMessage = '';

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _firebaseStreamEvents =
        FirebaseAuth.instance.authStateChanges().listen((user) {
      print(user);
      if (user != null) {
        user.sendEmailVerification();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _firebaseStreamEvents.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Color.fromARGB(255, 139, 228, 236),
      body: Center(
        
        // Espaciado de 16 píxeles en todos los lados
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(
                  16.0), // Espaciado interno de 16 píxeles en todos los lados
              child: TextField(
                controller: _emailController,
             
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
            ),

            // Espacio vertical de 16 píxeles entre los campos de texto
            Padding(
              
              padding: EdgeInsets.all(
                  16.0), // Espaciado interno de 16 píxeles en todos los lados
             
             
             
              child: TextField(
                
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  
                ),
              ),
            ),

            SizedBox(
                height:
                    16.0), // Espacio vertical de 16 píxeles entre el segundo campo de texto y el botón
            ElevatedButton(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: _emailController.text.trim(),
                    password: _passwordController.text.trim(),
                  );
                  setState(() {
                    _loginMessage = 'Inicio de Sesión Exitoso';
                  });
                } on FirebaseAuthException catch (e) {
                  if (e.message!.contains('auth/user-not-found') ||
                      e.message!.contains('auth/wrong-password')) {
                    setState(() {
                      _loginMessage =
                          'Credenciales de inicio de sesión incorrectas';
                    });
                  } else {
                    setState(() {
                      _loginMessage = 'Error >>>> Credenciales incorrectas';
                    });
                  }
                } catch (e) {
                  setState(() {
                    _loginMessage = 'Print >>> ${e}';
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan, // Cambiar color del botón a cian
              ),
              child: const Text("Ingresar"),
            ),
            SizedBox(height: 16.0),
            Text(
              _loginMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
