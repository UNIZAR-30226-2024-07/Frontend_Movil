import 'package:flutter/material.dart';
import 'package:psoft_07/colores.dart';

import 'Usuario.dart';

class Principal extends StatelessWidget {

  final User user;

  Principal(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColoresApp.fondoPantallaColor,
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
        actions: [
          IconButton(
            onPressed: () {
              // Acción para el botón de Amigos
            },
            icon: const Icon(Icons.group, color: Colors.white,),
          ),
          IconButton(
            onPressed: () {
              // Acción para el botón de Ranking
            },
            icon: const Icon(Icons.format_list_numbered, color: Colors.white,),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Acción para el botón de Partida Pública
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColoresApp.segundoColor,
              ),
              child: const Text(
                  "Partida Publica",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Acción para el botón de Partida Privada
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColoresApp.segundoColor,
              ),
              child: const Text(
                  'Partida Privada',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Acción para el botón de Torneo
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColoresApp.segundoColor,
              ),
              child: const Text(
                  'Torneo',
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

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}

void main() {
  runApp(MaterialApp(
    home: Principal(
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
