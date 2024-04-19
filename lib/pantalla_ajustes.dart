import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:psoft_07/colores.dart';
import 'package:get/get.dart';
import 'package:psoft_07/pantalla_cambioContrasena.dart';
import 'package:psoft_07/pantalla_cambioNombre.dart';
import 'package:psoft_07/pantalla_estadisticasJugador.dart';
import 'package:psoft_07/pantalla_victoria_partida.dart';

import 'Usuario.dart';


class SettingsScreen extends StatelessWidget {

  final User user;

  SettingsScreen(this.user, {super.key});
  final getConnect = GetConnect();

  void mostrarError(String mensaje, BuildContext context) {
    // Aquí puedes implementar la lógica para mostrar un pop-up con el mensaje de error
    // Por ejemplo, utilizando showDialog o ScaffoldMessenger.of(context).showSnackBar
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(mensaje),
      duration: Duration(seconds: 3),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: ColoresApp.cabeceraColor,
          elevation: 2, // Ajusta el valor según el tamaño de la sombra que desees
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/logo.png', // Ruta de la imagen
              width: 50, // Ancho de la imagen
              height: 50, // Altura de la imagen
              fit: BoxFit.cover,
            ),
          ),
      ),

      backgroundColor: ColoresApp.fondoPantallaColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => changeNameScreen(user)),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColoresApp.segundoColor,
              ),
              child: const Text(
                'Cambiar nombre usuario',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => changePasswordScreen(user)),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColoresApp.segundoColor,
              ),
              child: const Text(
                'Cambiar contraseña',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Acción para la tercera opción
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => estadisticasJugador(user)),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColoresApp.segundoColor,
              ),
              child: const Text(
                'Ver estadísticas',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
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
  runApp(MaterialApp(
    home: changeNameScreen(
        User(
            id: "",
            nick: "",
            name: "",
            surname: "",
            email: "",
            password: "",
            rol: "",
            coins: 0,
            tournaments: [],
            avatars: [],
            rugs: [],
            cards: [],
            token: "")
    ),
  ));
}
