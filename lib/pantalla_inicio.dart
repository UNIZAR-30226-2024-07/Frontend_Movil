import 'package:flutter/material.dart';
import 'package:psoft_07/pantalla_login.dart';
import 'package:psoft_07/pantalla_registro.dart';

import 'colores.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColoresApp.fondoPantallaColor,
      body: Center(
        child: Row (
          mainAxisAlignment: MainAxisAlignment.spaceAround,

          children: [
            Image.asset(
              'assets/logo.png', // Ruta de la imagen
              width: 200, // Ancho de la imagen
              height: 200, // Altura de la imagen
              fit: BoxFit.cover,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: ColoresApp.segundoColor,
                      minimumSize: const Size(300, 50)
                  ),
                  child: const Text(
                    'Iniciar Sesion',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColoresApp.segundoColor,
                    minimumSize: const Size(300, 50)
                  ),
                  child: const Text(
                    'Registrarse',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                    ),
                  ),

                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: WelcomeScreen(),
  ));
}
