import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:psoft_07/colores.dart';
import 'package:get/get.dart';
import 'package:psoft_07/pantalla_principal.dart';
import 'Usuario.dart';

class changeNameScreen extends StatelessWidget {

  final User user;

  changeNameScreen(this.user, {super.key});
  TextEditingController nuevoNombre = TextEditingController();
  TextEditingController confirmacionNuevoNombre = TextEditingController();
  final getConnect = GetConnect();

  void _comprobarCampos(BuildContext context, String nuevoNombre, String confirmarNuevoNombre) async {
    // Comprobar si nuevoNombre y confirmarNuevoNombre son iguales
    if (nuevoNombre != confirmarNuevoNombre) {
      // Mostrar mensaje de error para nuevoNombre diferente a confirmarNuevoNombre
      mostrarMsg(context, "Los campos de nuevo nombre no coinciden");
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
          "nick": nuevoNombre,
        },
      );

      // Verificar si la llamada a la API fue exitosa
      if (res.statusCode == 200) {
        // Mostrar mensaje de éxito
        mostrarMsg(context, "Nombre actualizado correctamente");
        // Cambiar el nombre del usuario en local
        user.nick = nuevoNombre;
        // Redirigr a la pantalla principal (no tiene sentido quedarnos aquí si se ha cambiado le nombre)
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Principal(user)),
        );
      } else {
        // Mostrar mensaje de error4
        mostrarMsg(context, "Error al actualizar el nombre. Por favor, inténtalo de nuevo.");
      }
    } catch (e) {
      // Mostrar mensaje de error si ocurre un error durante la llamada a la API
      mostrarMsg(context, "Error al conectar con el servidor. Por favor, verifica tu conexión a internet.");
    }
  }

  void mostrarMsg(BuildContext context, String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center( // Centra horizontalmente el contenido
          child: Text(mensaje),
        ),
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
                            'Cambio de Nombre',
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
                              controller: nuevoNombre,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                hintText: 'Nuevo nombre',
                                icon: Icon(
                                  Icons.person_add_rounded,
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
                              controller: confirmacionNuevoNombre,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                hintText: 'Confirmar Nuevo nombre',
                                icon: Icon(
                                  Icons.person_add_rounded,
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
                              _comprobarCampos(context ,nuevoNombre.text, confirmacionNuevoNombre.text);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColoresApp.segundoColor,
                            ),
                            child: const Text(
                              'Cambiar Nombre',
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
