import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:psoft_07/colores.dart';
import 'package:get/get.dart';
import 'package:psoft_07/pantalla_cambioNombre.dart';
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
      backgroundColor: ColoresApp.fondoPantallaColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 400,
                    height: 300,
                    decoration: BoxDecoration(
                      color: ColoresApp.cabeceraColor,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Acción para la primera opción
                          },
                          child: Text(
                            'Cambiar avatar',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            // Acción para la segunda opción
                          },
                          child: Text(
                            'Cambiar nombre usuario',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            // Acción para la tercera opción
                          },
                          child: Text(
                            'Cambiar contraseña',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            // Acción para la tercera opción
                          },
                          child: Text(
                            'Ver estadísticas',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0),
                ],
              ),


            ],
          ),
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
