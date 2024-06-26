import 'package:flutter/material.dart';
import 'package:get/get_connect/connect.dart';
import 'package:psoft_07/pantalla_principal.dart';
import 'Usuario.dart';
import 'colores.dart';

  Widget crearPantallaPausa(BuildContext context, String tipoPartida, String boardID, User user, socket) {
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
                          onPressed: () async {
                            //Hagamos lo que hagmaos, al abandonar guardar la partida en el servidor para que se pueda reanudar desde otro dispositivo
                            final getConnect = GetConnect();

                            // Abandonar de una forma u otra ne función del tipo d epartida
                            if (tipoPartida == "partidaPublica"){
                              final res = await getConnect.put(
                                '${EnlaceApp.enlaceBase}/api/publicBoard/leaveBoard/$boardID',
                                headers: {
                                  "Authorization": user.token,
                                },
                                {}, //Esto sería el body pero en este caso no lo usamos

                              );

                              int a = 1;
                            } else if (tipoPartida == "partidaPrivada") {
                              final res = await getConnect.put(
                                '${EnlaceApp.enlaceBase}/api/privateBoard/leaveBoard/$boardID',
                                headers: {
                                  "Authorization": user.token,
                                },
                                {}, //Esto sería el body pero en este caso no lo usamos
                              );
                              int a = 0;
                            } else if (tipoPartida == "partidaPractica") {
                              //esperar respuesta compis para ver cómo gestionar esto
                            } else if (tipoPartida == "partidaTorneo") { ///api/tournamentBoard/leaveBoard
                              final res = await getConnect.put(
                                '${EnlaceApp.enlaceBase}/api/tournamentBoard/leaveBoard/$boardID',
                                headers: {
                                  "Authorization": user.token,
                                },
                                {}, //Esto sería el body pero en este caso no lo usamos
                              );

                              socket.disconnect();


                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Principal(user)), // ir a la pantalla principal
                            );
                          },
                          child: Text(
                            'Abandonar Partida',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final getConnect = GetConnect();
                            if (tipoPartida == "partidaPublica"){
                              final resPausa = await getConnect.put(
                                '${EnlaceApp.enlaceBase}/api/publicBoard/pause/$boardID',
                                headers: {
                                  "Authorization": user.token,
                                },
                                {}, //Esto sería el body pero en este caso no lo usamos
                              );
                              if (resPausa.body['status'] == 'error') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(resPausa.body['message'], textAlign: TextAlign.center,),
                                  ),
                                );
                              }
                            }
                            else if (tipoPartida == "partidaPrivada") {
                              final res = await getConnect.put(
                                '${EnlaceApp.enlaceBase}/api/privateBoard/pause/$boardID',
                                headers: {
                                  "Authorization": user.token,
                                },
                                {}, //Esto sería el body pero en este caso no lo usamos
                              );
                              int a = 0;
                            }
                            else if (tipoPartida == "partidaPractica") {
                              //esperar respuesta compis para ver cómo gestionar esto
                            }
                            else if (tipoPartida == "partidaTorneo") {
                              final resPausa = await getConnect.put(
                                '${EnlaceApp.enlaceBase}/api/tournamentBoard/pause/$boardID',
                                headers: {
                                  "Authorization": user.token,
                                },
                                {}, //Esto sería el body pero en este caso no lo usamos
                              );
                            }
                            socket.disconnect();

                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Principal(user)), // ir a la pantalla principal
                            );
                          },
                          child: Text(
                            'Pausar Partida',
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
                            //El navigator es una pila de pantallas en el orden en el que se llaman.
                            //Haciendo pop, volvemos a la nterior
                            //Context en este caso es el sizedboc del menú pausa, que desaparecerá
                            Navigator.pop(context);
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