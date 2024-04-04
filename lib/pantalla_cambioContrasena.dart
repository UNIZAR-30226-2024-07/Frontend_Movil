import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:psoft_07/colores.dart';
import 'package:get/get.dart';

import 'package:psoft_07/pantalla_victoria_partida.dart';


class changePasswordScreen extends StatelessWidget {

  changePasswordScreen({super.key});


  TextEditingController passwdActual = TextEditingController();
  TextEditingController passwdNueva = TextEditingController();
  TextEditingController passwdNuevaConfirmar = TextEditingController();
  final getConnect = GetConnect();

  void _cambioPasswd(String nombreActual, String nuevoNombre, String confirmarNuevoNombre) async {
    // Comprobar si nombreActual es igual a nuevoNombre
    if (nombreActual == nuevoNombre) {
      // Mostrar mensaje de error para nombreActual igual a nuevoNombre
      mostrarError("El nuevo nombre debe ser diferente al actual");
      return;
    }

    // Comprobar si nuevoNombre y confirmarNuevoNombre son iguales
    if (nuevoNombre != confirmarNuevoNombre) {
      // Mostrar mensaje de error para nuevoNombre diferente a confirmarNuevoNombre
      mostrarError("Los campos de nuevo nombre no coinciden");
      return;
    }

    // Ambas condiciones son correctas, realizar la petición a la API
    final res = await getConnect.post('https://backend-uf65.onrender.com/api/user/login', {
      "nick": nombreActual,
      "password": nuevoNombre // Utilizamos nuevoNombre para la prueba, puedes cambiarlo según sea necesario
    });

    // Manejar la respuesta de la API según sea necesario
  }

  void mostrarError(String mensaje) {
    // Aquí puedes implementar la lógica para mostrar un pop-up con el mensaje de error
    // Por ejemplo, utilizando showDialog o ScaffoldMessenger.of(context).showSnackBar
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
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Cambio de Contraseña',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 25
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          SizedBox(
                            width: 300,
                            height: 40,
                            child: TextField(
                              controller: passwdActual,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                hintText: 'Contraseña actual',
                                icon: Icon(
                                  Icons.lock,
                                  color: Colors.white,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          SizedBox(
                            height: 40,
                            width: 300,
                            child: TextField(
                              controller: passwdNueva,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                hintText: 'Nueva contraseña',
                                icon: Icon(
                                  Icons.password,
                                  color: Colors.white,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          SizedBox(
                            height: 40,
                            width: 300,
                            child: TextField(
                              controller: passwdNuevaConfirmar,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                hintText: 'Confirmar contraseña',
                                icon: Icon(
                                  Icons.password,
                                  color: Colors.white,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          ElevatedButton(
                            onPressed: () {
                              _cambioPasswd(passwdActual.text, passwdNueva.text, passwdNuevaConfirmar.text);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColoresApp.segundoColor,
                            ),
                            child: const Text(
                              'Cambiar Contraseña',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),

                            ),
                          ),
                          const SizedBox(height: 5.0),
                          const SizedBox(height: 10.0),
                        ],
                      ),
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
    home: changePasswordScreen(),
  ));
}
