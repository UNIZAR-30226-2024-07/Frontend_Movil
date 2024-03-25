import 'package:flutter/material.dart';

class Principal extends StatelessWidget {


  final String token;

  Principal(this.token, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown[600],
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
            icon: const Icon(Icons.group),
          ),
          IconButton(
            onPressed: () {
              // Acción para el botón de Ranking
            },
            icon: const Icon(Icons.format_list_numbered),
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
              child: Text(token),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Acción para el botón de Partida Privada
              },
              child: const Text('Partida Privada'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Acción para el botón de Torneo
              },
              child: const Text('Torneo'),
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
    home: Principal('Un token'),
  ));
}
