import 'package:flutter/material.dart';

import 'colores.dart';


class JoinPrivateMatchScreen extends StatelessWidget {
  const JoinPrivateMatchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController nombreController = TextEditingController();
    final TextEditingController contrasenaController = TextEditingController();

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
                // Acción para el primer botón
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
  runApp(const MaterialApp(
    home: JoinPrivateMatchScreen(),
  ));
}
