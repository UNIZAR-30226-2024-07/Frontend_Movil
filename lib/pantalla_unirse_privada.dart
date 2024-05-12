import 'package:flutter/material.dart';
import 'package:psoft_07/pantalla_principal.dart';
import 'package:psoft_07/pantalla_privada_juego.dart';

import 'Usuario.dart';
import 'colores.dart';


class JoinPrivateMatchScreen extends StatelessWidget {
  final User user;

  JoinPrivateMatchScreen(this.user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final TextEditingController nombreController = TextEditingController();
    final TextEditingController contrasenaController = TextEditingController();
    String _name = '';
    String _password = '';

    return Scaffold(
      backgroundColor: ColoresApp.fondoPantallaColor,
      appBar: AppBar(
        backgroundColor: ColoresApp.cabeceraColor,
        elevation: 2, // Ajusta el valor según el tamaño de la sombra que desees
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Principal(user)),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/logo.png', // Ruta de la imagen
              width: 50, // Ancho de la imagen
              height: 50, // Altura de la imagen
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 200),
              child: Row(
                children: [
                  const Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 45, // Ajustar el tamaño aquí
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: TextField(
                        controller: nombreController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: 'Nombre',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.only(left: 15, top: 0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20), // Espacio entre los campos de texto
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 200),
              child: Row(
                children: [
                  const Icon(
                    Icons.lock,
                    color: Colors.black,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 45, // Ajustar el tamaño aquí
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: TextField(
                        controller: contrasenaController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Contraseña',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.only(left: 15, top: 0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30), // Espacio entre los campos de texto y el botón
            ElevatedButton(
              onPressed: () {
                if (nombreController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("El nombre no es válido"),
                    ),
                  );
                } else if (contrasenaController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("La contraseña no es válida"),
                    ),
                  );
                } else {
                  // Lógica para crear la partida
                  Map<String, dynamic> body = {
                    'body': {
                      'name': '',
                      'password': '',
                      'bankLevel': '',
                      'numPlayers': '',
                      'bet': '',
                      'userId': '',
                    }
                  };
                  Map<String, dynamic> bodyUnirse = {
                    'body': {
                      'name': nombreController.text,
                      'password': contrasenaController.text,
                      'userId': user.id,
                    }
                  };
                  print("BODY UNIRSEEEEEEEEEEEEE");
                  print(bodyUnirse);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PrivateGameScreen("", user, body, bodyUnirse, false)),
                  );
                }
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: ColoresApp.segundoColor,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: const Text(
                'UNIRSE A LA PARTIDA',
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
  runApp(MaterialApp(
    home: JoinPrivateMatchScreen(
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
        token: "",
      ),
    ),
  ));
}
