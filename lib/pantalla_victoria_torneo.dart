import 'package:flutter/material.dart';
import 'colores.dart';

class VictoryScreen extends StatelessWidget {
  const VictoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final int coinsEarned = 100; // Aquí habrá que poner el número de monedas que se gana

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
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/medalla.png', // Imagen de la estrella a la izquierda
                        width: 120,
                        height: 120,
                      ),
                      const SizedBox(width: 20),
                      Column(
                        children: [
                          Text(
                            '¡Enhorabuena!',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  blurRadius: 3.0,
                                  color: Colors.black.withOpacity(0.5),
                                  offset: const Offset(2.0, 2.0),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10), // Ajusta el radio según tu preferencia
                            child: Image.asset(
                              'assets/trofeo.png',
                              width: 100,
                              height: 160,
                            ),
                          )

                        ],
                      ),
                      const SizedBox(width: 20),
                      Image.asset(
                        'assets/medalla.png', // Imagen de la estrella a la derecha
                        width: 120,
                        height: 120,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '¡Has ganado el torneo!',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 3.0,
                          color: Colors.black.withOpacity(0.5),
                          offset: const Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red, // Color de fondo del contenedor
                borderRadius: BorderRadius.circular(8), // Borde redondeado
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 9,
                    offset: const Offset(0, 3), // Cambiar la posición de la sombra
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.monetization_on, // Icono de moneda
                    color: Colors.white,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '+$coinsEarned',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 10,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: -8,
                    blurRadius: 6,
                    offset: const Offset(0, 0), // Cambiar la posición de la sombra
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.chat,
                  color: Colors.white, // Cambia el color del icono
                ),
                onPressed: () {
                  // Agrega aquí la lógica para lo que sucede cuando se presiona el botón de chat
                },
                iconSize: 50,
                splashColor: Colors.grey, // Cambia el color de la onda al presionar
                tooltip: 'Abrir chat', // Agrega un mensaje de ayuda
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Agrega aquí la lógica para lo que sucede cuando se presiona el botón de "Aceptar y Continuar"
        },
        backgroundColor: Colors.red.shade300,
        child: Icon(Icons.arrow_forward), // Color de fondo del botón
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // Posición del botón flotante
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: VictoryScreen(),
  ));
}
