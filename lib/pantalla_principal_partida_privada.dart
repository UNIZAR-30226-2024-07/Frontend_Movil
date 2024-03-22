import 'package:flutter/material.dart';
import 'package:psoft_07/pantalla_crear_privada.dart';
import 'package:psoft_07/pantalla_unirse_privada.dart';
import 'colores.dart';

class PrivateMatchScreen extends StatelessWidget {
  const PrivateMatchScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: ColoresApp.fondoPantallaColor,
      appBar: AppBar(
        backgroundColor: ColoresApp.cabeceraColor,
        elevation: 2,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/logo.png',
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreatePrivateGameScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColoresApp.segundoColor
              ),
              child: const Text(
                  'Crear Partida',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => JoinPrivateMatchScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: ColoresApp.segundoColor
              ),
              child: const Text(
                'Unirse a Partida',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                // Acción para el primer botón
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: ColoresApp.segundoColor
              ),
              child: const Text(
                'Modo Práctica',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: PrivateMatchScreen(),
  ));
}
