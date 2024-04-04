import 'package:flutter/material.dart';
import 'colores.dart';

class DefeatScreen extends StatelessWidget {
  const DefeatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final int coinsEarned = 0; // Aquí habrá que poner el número de monedas que se gana

    return Scaffold(
      backgroundColor: ColoresApp.fondoPantallaColor,
      appBar: AppBar(
        toolbarHeight: 45,
        backgroundColor: ColoresApp.cabeceraColor,
        elevation: 2,
        leading: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Image.asset(
            'assets/logo.png',
            width: 50,
            height: 50,
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
                  Text(
                    '¡Lástima!',
                    style: TextStyle(
                      fontSize: 32,
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
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/calavera.png',
                        width: 100,
                        height: 100,
                      ),
                      const SizedBox(width: 50),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10), // Ajusta el radio según tu preferencia
                        child: Image.asset(
                          'assets/derrota.png',
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 50),
                      Image.asset(
                        'assets/calavera.png',
                        width: 100,
                        height: 100,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '¡Has quedado eliminado!',
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
        child: const Icon(Icons.arrow_forward), // Color de fondo del botón
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // Posición del botón flotante
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: DefeatScreen(),
  ));
}
