import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:psoft_07/colores.dart';
import 'package:psoft_07/Usuario.dart';
import 'package:psoft_07/pantalla_partida_publica.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class LoadingScreen extends StatefulWidget {
  final String idMesa;
  final User user;
  bool hecho = false;

  IO.Socket socket = IO.io(EnlaceApp.enlaceBase, <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': true
  });

  LoadingScreen(this.idMesa, this.user, {super.key});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  double _progressValue = 0.0;

  @override
  void initState() {
    super.initState();
    // Simulación de carga de datos
    _simulateLoading();
  }

  void _simulateLoading() {
    // Simula la carga de datos aumentando el valor de la barra de progreso
    Future.delayed(const Duration(milliseconds: 600), () {
      setState(() {
        _progressValue += 0.1;
      });
      if (_progressValue < 1.0) {
        _simulateLoading();
      } else {
        // Navegar a la siguiente pantalla una vez que la carga haya terminado
        // en este caso, a la pantalla de Partida pública

      }
    });
  }


  void conectarPartida() async {
    /*
    // Dart client
    IO.Socket socket = IO.io(EnlaceApp.enlaceBase);

    Map<String, dynamic> body = {
      'body': {
        'typeId': widget.idMesa,
        'userId': widget.user.id,
      }
    };

    socket.onConnect((_) {
      print('connect');
      socket.emit("enter public board", body);
    });

    socket.emit("enter public board", body);

    socket.on("starting public board", (boardId) {
        print(boardId);

        if (boardId) {
          socket.emit("players public ready", []);
        }
    });

    socket.on("error", (args) {
        print(args);
    });
    */
    /////////////////////////////////



    bool kDebugMode = true;

    widget.socket?.on("connect", (data) {
      if (kDebugMode) {
        print("Socket Connect Done");
      }
      updateSocketApi();

    });

    widget.socket?.on("starting public board", (data) {
      if (kDebugMode) {
        print("starting public board RECIBIDO :) --------------------");
        print(data);
      }


    });

    widget.socket?.on("connect_error", (data) {
      if (kDebugMode) {
        print("Socket connect_error");
        print(data);
      }
    });

    widget.socket?.on("error", (data) {
      if (kDebugMode) {
        print("Socket error");
        print(data);
      }
    });

    widget.socket?.on("UpdateSocket", (data) {
      if (kDebugMode) {
        print("UpdateSocket --------------------");
        print(data);
      }

    });

    widget.socket?.on("disconnect", (data) {
      if (kDebugMode) {
        print("Socket disconnect");
        print(data);
      }
    });
  }

  Future updateSocketApi() async {
    if (!widget.hecho) {
      try {
        widget.hecho = true;

        Map<String, dynamic> body = {
          'body': {
            'typeId': widget.idMesa,
            'userId': widget.user.id,
          }
        };

        print("JODEER");

        widget.socket?.emit('enter public board', body);
      }catch (err) {
        if (true) {
          print(err);
        }
      }
    }
}


  @override
  Widget build(BuildContext context) {
    if (!widget.hecho) {
      conectarPartida();
    }
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 300,
              height: 120,
              padding: const EdgeInsets.all(7.5),
              decoration: BoxDecoration(
                color: Colors.red[800],
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3), // Cambia la posición de la sombra
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'Cargando...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  LinearProgressIndicator(
                    value: _progressValue,
                    backgroundColor: Colors.blue[100],
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                    minHeight: 10,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${(_progressValue * 90.9).toStringAsFixed(1)}% completado',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
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
    home: LoadingScreen( "",
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
      ),),
  ));
}