import 'package:flutter/material.dart';
import 'package:psoft_07/pantalla_crear_privada.dart';
import 'package:psoft_07/pantalla_modo_practica.dart';
import 'package:psoft_07/pantalla_principal.dart';
import 'package:psoft_07/pantalla_unirse_privada.dart';
import 'Usuario.dart';
import 'colores.dart';

class PracticeModeElection extends StatelessWidget {
  final User user;

  const PracticeModeElection(this.user, {super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: ColoresApp.fondoPantallaColor,
      appBar: AppBar(
        backgroundColor: ColoresApp.cabeceraColor,
        elevation: 2, // Ajusta el valor según el tamaño de la sombra que desees
        leading: GestureDetector(
          onTap: () {
            // Coloca aquí el código que deseas ejecutar cuando se haga tap en la imagen
            // Por ejemplo, puedes navegar a otra pantalla, mostrar un diálogo, etc.
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
        child:
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration:  BoxDecoration(
                color: ColoresApp.segundoColor, // Color de fondo
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Nivel de dificultad',
                style: TextStyle(
                  fontSize: 16, // Tamaño del texto
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/valoresCartas/Ace-Clubs.png',
                      width: 90, // Establece un tamaño máximo solo para el ancho
                      fit: BoxFit.scaleDown, // Ajusta automáticamente la altura según la proporción original de la imagen
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PracticeMode("beginner", user)),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: ColoresApp.segundoColor
                      ),
                      child: const Text(
                        'Beginner',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/valoresCartas/2-Clubs.png',
                      width: 90, // Establece un tamaño máximo solo para el ancho
                      fit: BoxFit.scaleDown, // Ajusta automáticamente la altura según la proporción original de la imagen
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PracticeMode("medium", user)),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: ColoresApp.segundoColor
                      ),
                      child: const Text(
                        'Medium',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/valoresCartas/3-Clubs.png',
                      width: 90, // Establece un tamaño máximo solo para el ancho
                      fit: BoxFit.scaleDown, // Ajusta automáticamente la altura según la proporción original de la imagen
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PracticeMode("expert", user)),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: ColoresApp.segundoColor
                      ),
                      child: const Text(
                        'Expert',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
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
  runApp(MaterialApp(
    home: PracticeModeElection(
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
