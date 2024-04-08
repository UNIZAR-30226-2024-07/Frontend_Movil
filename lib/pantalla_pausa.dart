import 'package:flutter/material.dart';
import 'Usuario.dart';

class PauseScreen extends StatelessWidget {
  final User user;

  PauseScreen(this.user, {super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[800],
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 0.0, bottom: 0.0),
          child: Image.asset(
            'assets/logo.png',
            width: 40,
            height: 40,
            fit: BoxFit.cover,
          ),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Widget para mostrar el fondo de la pantalla anterior
          // Supongamos que este es el Widget de la pantalla anterior
          Container(
            color: Colors.blue, // Cambiar al color de fondo deseado
            child: Center(
              child: Text(
                'Contenido de la pantalla anterior',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
          ),
          // Cuadrado blanco con bordes redondeados y efecto de relieve
          Center(
            child: FractionallySizedBox(
              widthFactor: 0.8,
              heightFactor: 0.8,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20), // Bordes redondeados
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3), // Color y opacidad de la sombra
                      spreadRadius: 5, // Radio de esparcimiento de la sombra
                      blurRadius: 7, // Radio de difuminado de la sombra
                      offset: Offset(0, 3), // Desplazamiento de la sombra
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Logo.png ajustado porcentualmente
                    Container(
                      width: MediaQuery.of(context).size.width * 0.2, // 10% del ancho del row
                      height: MediaQuery.of(context).size.width * 0.2, // 10% del ancho del row
                      child: Image.asset(
                        'assets/logo.png',
                        fit: BoxFit.contain, // Ajustar la imagen al contenedor
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Acción para la primera opción
                          },
                          child: Text(
                            'Abandonar Partida',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            // Acción para la segunda opción
                          },
                          child: Text(
                            'Ver Jugadores',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            // Acción para la tercera opción
                          },
                          child: Text(
                            'Reanudar partida',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                    // Segunda logo.png ajustado porcentualmente
                    Container(
                      width: MediaQuery.of(context).size.width * 0.2, // 10% del ancho del row
                      height: MediaQuery.of(context).size.width * 0.2, // 10% del ancho del row
                      child: Image.asset(
                        'assets/logo.png',
                        fit: BoxFit.contain, // Ajustar la imagen al contenedor
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PauseScreen(
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
    debugShowCheckedModeBanner: false,
  ));
}