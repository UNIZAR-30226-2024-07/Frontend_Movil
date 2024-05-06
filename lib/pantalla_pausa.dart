import 'package:flutter/material.dart';

  Widget crearPantallaPausa(BuildContext context) {
    return FractionallySizedBox(
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
            );
  }