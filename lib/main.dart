// main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pantalla_inicio.dart';
import 'pantalla_registro.dart';
import 'pantalla_login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    // Se fija orientación horizontal
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    return MaterialApp(
      title: 'Login Horizontal',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WelcomeScreen(), // Utiliza la pantalla de inicio de sesión como widget principal
      debugShowCheckedModeBanner: false,
    );
  }
}

