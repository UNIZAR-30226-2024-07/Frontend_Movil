import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_connect/connect.dart';
import 'package:psoft_07/colores.dart';
import 'package:psoft_07/Usuario.dart';
import 'package:psoft_07/pantalla_partida_publica.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class LoadingScreen extends StatefulWidget {
  final String idMesa;
  final User user;
  final getConnect = GetConnect();
  bool hecho = false;
  bool UImesa = false;

  String boardId = "";

  dynamic ronda;

  dynamic myHand;
  bool myDefeat = false;
  bool plantado = false;
  bool myBlackjack = false;
  dynamic bankHand;
  List<dynamic> otherHand = [];

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

  Future<bool> conexionBoardId(boardId) async {
    try {
      final response = await widget.getConnect.get(
        '${EnlaceApp.enlaceBase}/api/publicBoard/boardById/$boardId',
        headers: {
          "Authorization": widget.user.token,
        },
      );

      if (response.body['status'] == 'error') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.body['message'], textAlign: TextAlign.center,),
          ),
        );
      }

      for (var jugador in response.body['board']['players']) {
        if(jugador['player'] == widget.user.id){
          return jugador['guest'];
        }
      }

      return false;



    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error en la peticion de boardId", textAlign: TextAlign.center,),
        ),
      );
      return false;
    }
  }


  void conectarPartida() async {

    bool kDebugMode = true;

    widget.socket?.on("connect", (data) {
      if (kDebugMode) {
        print("Socket Connect Done");
      }
      updateSocketApi();

    });

    widget.socket?.on("starting public board", (boardId) async {
      if (kDebugMode) {
        print("starting public board RECIBIDO :) --------------------");
      }

      widget.boardId = boardId;

      if(await conexionBoardId(boardId)) {

        Map<String, dynamic> body = {
          'body': {
            'boardId': boardId,
          }
        };
        print("SE ha emitidoooooooooooooooooooo");
        widget.socket.emit("players public ready", body);
      }
    });

    widget.socket?.on("play hand", (data) {
        print(data);

        setState(() {
          widget.UImesa = true;
          widget.ronda = data;
          widget.myDefeat = false;
          widget.plantado = false;
          widget.myBlackjack = false;
          widget.otherHand = [];
        });
    });

    widget.socket?.on("error", (data) {
      if (kDebugMode) {
        print("Socket error");
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

void myHand () {
  for (var mano in widget.ronda) {
    if (mano['userId'] == widget.user.id) {
        widget.myHand = mano;
        widget.myBlackjack = mano['blackJack'];
    }
  }
}

  void bankHand () {
    for (var mano in widget.ronda) {
      if (mano['userId'] == "Bank") {
        widget.bankHand = mano;
      }
    }
  }

  void othersHand () {
    widget.otherHand = [];
    for (var mano in widget.ronda) {
      if (mano['userId'] != widget.user.id
      && mano['userId'] != "Bank") {
        widget.otherHand.add(mano);
      }
    }
  }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  void funcionPlantarse () async {
    try {
      final response = await widget.getConnect.put(
        '${EnlaceApp.enlaceBase}/api/publicBoard/stick',
        {
          "boardId": widget.boardId,
          "cardsOnTable": widget.myHand['cards'],
          "handIndex": 0,
        },
        headers: {
          "Authorization": widget.user.token,
        },
      );
      if (response.body['status'] == 'error' || response.body['status'] == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.body['message'], textAlign: TextAlign.center,),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Te has plantado", textAlign: TextAlign.center,),
          ),
        );
        setState(() {
          widget.myHand['cards'] = response.body['cardsOnTable'];
          widget.plantado = true;
        });
      }
    } catch (e) {
    }
}

  void funcionPedirCarta () async {
    try {
      final response = await widget.getConnect.put(
        '${EnlaceApp.enlaceBase}/api/publicBoard/drawCard',
        {
          "boardId": widget.boardId,
          "cardsOnTable": widget.myHand['cards'],
          "handIndex": 0,
        },
        headers: {
          "Authorization": widget.user.token,
        },
      );
      if (response.body['status'] == 'error' || response.body['status'] == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.body['message'], textAlign: TextAlign.center,),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Has pedido una carta", textAlign: TextAlign.center,),
          ),
        );
        setState(() {
          widget.myHand['cards'] = response.body['cardsOnTable'];
          widget.myHand['totalCards'] = response.body['totalCards'];
          widget.myBlackjack = response.body['blackJack'];
          widget.myDefeat = response.body['defeat'];
        });
      }
    } catch (e) {
    }
  }


  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    if (!widget.UImesa) {
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
                      offset: const Offset(
                          0, 3), // Cambia la posición de la sombra
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
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.blue),
                      minHeight: 10,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${(_progressValue * 90.9).toStringAsFixed(
                          1)}% completado',
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
    else {
      myHand(); // Cartas del Usuario
      bankHand();
      othersHand();
      return Scaffold(
        backgroundColor: ColoresApp.fondoPantallaColor,
        appBar: AppBar(
          backgroundColor: ColoresApp.cabeceraColor,
          elevation: 2,
          // Ajusta el valor según el tamaño de la sombra que desees
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
            Text(
              widget.user.coins.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/moneda.png', // Ruta de la imagen
                width: 30, // Ancho de la imagen
                height: 30, // Altura de la imagen
                fit: BoxFit.cover,
              ),
            ),
            IconButton(
              onPressed: () {

              },
              icon: const Icon(Icons.pause, color: Colors.white,),
            ),
            IconButton(
              onPressed: () {

              },
              icon: const Icon(Icons.logout, color: Colors.white,),
            ),
          ],
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(   //Cartas Resto Jugadores
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if(widget.otherHand != [])
                  for (var mano in widget.otherHand)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var card in mano['cards'])
                          Image.asset(
                            'assets/valoresCartas/' + card['value'].toString() + '-' + card['suit'] + '.png',
                            width: 50, // Establece un tamaño máximo solo para el ancho
                            fit: BoxFit.scaleDown, // Ajusta automáticamente la altura según la proporción original de la imagen
                          ),
                      ],
                    )
              ],
            ),
            Column (
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column (  // Cartas Banca
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Banca: ' + widget.bankHand['totalCards'].toString(),
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var card in widget.bankHand['cards'])
                          Image.asset(
                            'assets/valoresCartas/' + card['value'].toString() + '-' + card['suit'] + '.png',
                            width: 200, // Ancho de la imagen
                            height: 100, // Altura de la imagen
                            fit: BoxFit.contain,
                          ),
                      ],
                    )
                  ],
                ),
                Column (  // Cartas Jugador
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Total: ' + widget.myHand['totalCards'].toString(),
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                      ),
                    ),
                    Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (var card in widget.myHand['cards'])
                            Image.asset(
                              'assets/valoresCartas/' + card['value'].toString() + '-' + card['suit'] + '.png',
                              width: 100, // Establece un tamaño máximo solo para el ancho
                              fit: BoxFit.scaleDown, // Ajusta automáticamente la altura según la proporción original de la imagen
                            ),
                      ],
                    )
                  ],
                ),
              ],
            ),
            Column(   // Botones de Interacción
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          /////////////////////////////////////////////////////////////////////////////////////////////////////
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColoresApp.segundoColor,
                          fixedSize: Size(40, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15), // Ajusta el radio de esquinas según sea necesario
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.call_split_outlined,
                            color: Colors.white,
                            size: 25,
                          ),
                        )
                    ),
                    const Text(
                      "Dividir",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          /////////////////////////////////////////////////////////////////////////////////////////////////////
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColoresApp.segundoColor,
                          fixedSize: Size(40, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15), // Ajusta el radio de esquinas según sea necesario
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.clear,
                            color: Colors.white,
                            size: 25,
                          ),
                        )
                    ),
                    const Text(
                      "Doblar",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
                if(!(widget.myBlackjack || widget.myDefeat || widget.plantado))

                  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                      ElevatedButton(
                      onPressed: () {
                        funcionPedirCarta();

                      },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColoresApp.segundoColor,
                            fixedSize: Size(40, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15), // Ajusta el radio de esquinas según sea necesario
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.exposure_plus_1,
                              color: Colors.white,
                              size: 25,
                            ),
                          )
                      ),
                      const Text(
                      "Otra carta",
                      style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                      ),
                    ),
                    ],
                  ),
                if(!(widget.myBlackjack || widget.myDefeat || widget.plantado))
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                        ElevatedButton(
                            onPressed: () {
                              funcionPlantarse();

                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColoresApp.segundoColor,
                              fixedSize: Size(40, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15), // Ajusta el radio de esquinas según sea necesario
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.pan_tool_rounded,
                                color: Colors.white,
                                size: 25,
                              ),
                            )
                        ),
                        const Text(
                          "Plantarse",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                          ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      );
    }
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