import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:psoft_07/colores.dart';
import 'package:get/get.dart';
import 'package:psoft_07/pantalla_inicio.dart';
import 'package:psoft_07/pantalla_principal.dart';
import 'package:psoft_07/pantalla_victoria_partida.dart';

import 'Usuario.dart';


class changePasswordScreen extends StatelessWidget {
  final User user;
  changePasswordScreen(this.user, {super.key});

  TextEditingController passwdNueva = TextEditingController();
  TextEditingController passwdNuevaConfirmar = TextEditingController();
  final getConnect = GetConnect();

  void _cambioPasswd(String passwdNueva, String passwdNuevaConfirmar, BuildContext context) async {
    // Comprobar si nombreActual es igual a nuevoNombre

    // Comprobar si nuevoNombre y confirmarNuevoNombre son iguales
    if (passwdNueva != passwdNuevaConfirmar) {
      // Mostrar mensaje de error para nuevoNombre diferente a confirmarNuevoNombre
      mostrarMsg(context, "Los campos de nueva contraseña no coinciden");
      return;
    }
    bool contrasenaValida = true;
    // Verificar la longitud mínima
    if (passwdNueva.length < 6) {
      contrasenaValida = false;
    }
    // Verificar al menos una mayúscula
    else if (!passwdNueva.contains(RegExp(r'[A-Z]'))) {
      contrasenaValida = false;
    }
    // Verificar al menos una minúscula
    else if (!passwdNueva.contains(RegExp(r'[a-z]'))) {
      contrasenaValida = false;
    }
    // Verificar al menos un número
    else if (!passwdNueva.contains(RegExp(r'[0-9]'))) {
      contrasenaValida = false;
    }

    //Si alguna de estas falla, mostrar mensaje de condiciones contraseña
    if(!contrasenaValida){
      mostrarMsg(context, "La contraseña debe tener al menos 6 caracteres, una mayúscula, una minúscula y un número.");
      return;
    }

    // Ambas condiciones son correctas, realizar la petición a la API
    try {
      // Realizar la petición a la API
      final res = await getConnect.put(
        '${EnlaceApp.enlaceBase}/api/user/update',
        headers: {
          'Authorization': user.token,
        },
        {
          "password": passwdNueva,
        },
      );

      // Verificar si la llamada a la API fue exitosa
      if (res.statusCode == 200) {
        // Mostrar mensaje de éxito
        mostrarMsg(context, "Contraseña actualizada correctamente");
        //volver a hacer login con la nueva contraseña
        final res = await getConnect.post('${EnlaceApp.enlaceBase}/api/user/login', {
          "nick":user.nick,
          "password":passwdNueva,
          "rol": "user",
        });

        if (res.body['status'] == 'error') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(res.body['message'], textAlign: TextAlign.center,),
            ),
          );
        }
        else {
        // Redirigr a la pantalla principal (no tiene sentido quedarnos aquí si se ha cambiado le nombre)
        Navigator.push(
          context, //Es seguro pasar el context? en principio sí, no hay info del usuario
          MaterialPageRoute(builder: (context) => WelcomeScreen()),
        );
        }
      } else {
        // Mostrar mensaje de error
        mostrarMsg(context, "Error al actualizar la contraseña. Por favor, inténtalo de nuevo.");
      }
    } catch (e) {
      // Mostrar mensaje de error si ocurre un error durante la llamada a la API
      mostrarMsg(context, "Error al conectar con el servidor. Por favor, verifica tu conexión a internet.");
    }
}

void mostrarMsg(BuildContext context, String mensaje) {
  // Aquí puedes implementar la lógica para mostrar un pop-up con el mensaje de error
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(mensaje), // Se debe envolver el mensaje en un widget Text
    ),
  );
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
                              _cambioPasswd(passwdNueva.text, passwdNuevaConfirmar.text, context);
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
    home: changePasswordScreen(
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
