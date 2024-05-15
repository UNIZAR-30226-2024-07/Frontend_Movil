import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/connect.dart';
import 'package:psoft_07/colores.dart';
import 'package:psoft_07/Usuario.dart';
import 'package:psoft_07/pantalla_partida_publica.dart';
import 'package:psoft_07/pantalla_principal.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:tuple/tuple.dart';
import 'package:psoft_07/pantalla_pausa.dart' as pause;
import 'Mano.dart';
import 'dart:async';

class PracticeMode extends StatefulWidget {
  final String bankLevel;
  final User user;
  final getConnect = GetConnect();
  bool hecho = false;

  bool UImesa = false;
  bool resultadosRonda = false;
  bool split = false;

  String boardId = "";
  String currentcard = "";
  String currentRug = "";

  List<Mano> myHand = [];
  ResultadosMano myResultadosHand = ResultadosMano();

  Mano bankHand = Mano();
  ResultadosMano bankResultadosHand = ResultadosMano();

  IO.Socket socket = IO.io(EnlaceApp.enlaceBase, <String, dynamic>{
  'transports': ['websocket'],
  'autoConnect': false
  });

  PracticeMode(this.bankLevel, this.user, {super.key});

  @override
  _PracticeModeState createState() => _PracticeModeState();
}

class _PracticeModeState extends State<PracticeMode> {
  double _progressValue = 0.0;

  Future<String> getAvatar(String _userId) async {
    try {
      final getConnect = GetConnect();
      final response = await getConnect.get(
        '${EnlaceApp.enlaceBase}/api/avatar/currentAvatarById/$_userId',
        headers: {
          "Authorization": widget.user.token,
        },
      );
      String image = response.body['avatar']['imageFileName'];
      return "${EnlaceApp.enlaceBase}/images/$image";
    } catch (e) {
      throw Exception('Failed to load user data');
    }
  }

  void getCurrentCard() async {
    try {
      final response = await widget.getConnect.get(
        '${EnlaceApp.enlaceBase}/api/card/currentCard',
        headers: {
          "Authorization": widget.user.token,
        },
      );

      if (response.body['status'] == 'error') {
        widget.currentcard = "13f36eb4-be1e-488d-8d5e-b2d45fb70203-1711535331655.png";
      } else {
        widget.currentcard = response.body['imageFileName'];
      }
    } catch (e) {
      widget.currentcard = "13f36eb4-be1e-488d-8d5e-b2d45fb70203-1711535331655.png";
    }
  }

  void getCurrentRug() async {
    try {
      final response = await widget.getConnect.get(
        '${EnlaceApp.enlaceBase}/api/rug/currentRug',
        headers: {
          "Authorization": widget.user.token,
        },
      );

      if (response.body['status'] == 'error') {
        widget.currentRug = "d04b37e8-e508-4ba7-a087-3fe0d5e505ed-1711535889700.png";
      } else {
        widget.currentRug = response.body['imageFileName'];
      }
    } catch (e) {
      print(e);
      widget.currentRug = "d04b37e8-e508-4ba7-a087-3fe0d5e505ed-1711535889700.png";
    }
  }



  void conexionBoardId(boardId) async {
    try {
      final response = await widget.getConnect.get(
        '${EnlaceApp.enlaceBase}/api/singleBoard/boardById/$boardId',
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

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error en la peticion de boardId", textAlign: TextAlign.center,),
        ),
      );
    }
  }

  void leaveBoard(boardId) async {
    try {
      final response = await widget.getConnect.put(
        '${EnlaceApp.enlaceBase}/api/singleBoard/leaveBoard/$boardId',
        {

        },
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
      } else {
        setState(() {
          widget.socket.disconnect();
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Principal(widget.user)),
        );
      }

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error en la peticion de boardId", textAlign: TextAlign.center,),
        ),
      );
    }
  }

  void conectarPartida() async {

    bool kDebugMode = true;

    setState(() {
      widget.socket.connect();
    });

    widget.socket?.on("connect", (data) {
      if (kDebugMode) {
        print("Socket Connect Done");
      }
      emitEntrar();

    });

    widget.socket?.on("starting single board", (boardId) async {
      if (kDebugMode) {
        print("starting single board RECIBIDO :) --------------------");
      }

      widget.boardId = boardId;
      getCurrentCard();

      conexionBoardId(boardId);

      Map<String, dynamic> body = {
        'body': {
          'boardId': boardId,
        }
      };
      print("SE ha emitidoooooooooooooooooooo");
      widget.socket.emit("players single ready", body);

    });

    widget.socket?.on("play hand", (data) {
      print(data);
      if (data != null) {
        setState(() {
          myHand(data); // Cartas del Usuario
          bankHand(data);
          widget.UImesa = true;
          widget.split = false;
          widget.resultadosRonda = false;
        });
      }


    });

    widget.socket?.on("hand results", (data) {
      print(data);
      if (data != null) {
        setState(() {
          myResultadosHand(data);
          bankResultadosHand(data);
          widget.resultadosRonda = true;
        });
      }
    });

    widget.socket?.on("finish board", (data) {
      print(data);
      if (data != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Ha terminado la partida",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            duration: Duration(seconds: 2),
          ),
        );
        widget.socket.disconnect();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Principal(widget.user)),
        );

      }
    });


    widget.socket?.on("error", (data) {
      if (kDebugMode) {
        print("Socket error");
        print(data);
      }
    });

  }

  Future emitEntrar() async {
    if (!widget.hecho) {
      try {
        widget.hecho = true;

        Map<String, dynamic> body = {
          'body': {
            'bankLevel': widget.bankLevel,
            'userId': widget.user.id,
          }
        };

        print("JODEER");

        widget.socket?.emit('enter single board', body);
      }catch (err) {
        if (true) {
          print(err);
        }
      }
    }
  }

  void myHand (data) {
    widget.myHand = [];
    for (var mano in data) {
      if (mano['userId'] == widget.user.id) {
        widget.myHand.add(Mano());
        widget.myHand[0].initMano(mano['userId'], mano['cards'], mano['totalCards'], false, false, mano['blackJack'], true);
      }
    }
  }

  void bankHand (data) {
    for (var mano in data) {
      if (mano['userId'] == "Bank") {
        widget.bankHand.initMano(mano['userId'], mano['cards'], mano['totalCards'], false, false, mano['blackJack'], true);
      }
    }
  }

  void myResultadosHand (data) {
    for (var mano in data) {
      if (mano['userId'] == widget.user.id) {
        widget.myResultadosHand.initResultadoMano(mano['userId'], mano['userNick'], mano['cards'], mano['total'], mano['coinsEarned'], mano['currentCoins']);
      }
    }
  }

  void bankResultadosHand (data) {
    for (var mano in data) {
      if (mano['userId'] == "Bank") {
        widget.bankResultadosHand.initResultadoManoBanca(mano['userId'], mano['userNick'], mano['cards'], mano['total']);
      }
    }
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  void funcionPlantarse (int mano) async {
    try {
      final response = await widget.getConnect.put(
        '${EnlaceApp.enlaceBase}/api/singleBoard/stick',
        {
          "boardId": widget.boardId,
          "cardsOnTable": widget.myHand[mano].cartas,
          "handIndex": mano,
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
            duration: Duration(seconds: 1),
          ),
        );
        setState(() {
          widget.myHand[mano].cartas = response.body['cardsOnTable'];
          widget.myHand[mano].plantado = true;
          widget.myHand[mano].firstHand = false;

        });
      }
    } catch (e) {
    }
  }

  void funcionPedirCarta (int mano) async {
    try {
      final response = await widget.getConnect.put(
        '${EnlaceApp.enlaceBase}/api/singleBoard/drawCard',
        {
          "boardId": widget.boardId,
          "cardsOnTable": widget.myHand[mano].cartas,
          "handIndex": mano,
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
            duration: Duration(seconds: 1),

          ),
        );
        setState(() {
          widget.myHand[mano].cartas = response.body['cardsOnTable'];
          widget.myHand[mano].totalCards = response.body['totalCards'];
          widget.myHand[mano].myBlackjack = response.body['blackJack'];
          widget.myHand[mano].myDefeat = response.body['defeat'];
          widget.myHand[mano].firstHand = false;
        });
      }
    } catch (e) {
    }
  }

  bool cartasIguales(){
    return (widget.myHand[0].cartas[0]['value'] == widget.myHand[0].cartas[1]['value']);

  }

  void funcionDoblar (int mano) async {
    try {
      final response = await widget.getConnect.put(
        '${EnlaceApp.enlaceBase}/api/singleBoard/double',
        {
          "boardId": widget.boardId,
          "cardsOnTable": widget.myHand[mano].cartas,
          "handIndex": mano,
        },
        headers: {
          "Authorization": widget.user.token,
        },
      );
      if (response.body['status'] == 'error' || response.body['status'] == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.body['message'], textAlign: TextAlign.center,),
            duration: Duration(seconds: 1),

          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Has doblado apuesta", textAlign: TextAlign.center,),
            duration: Duration(seconds: 1),

          ),
        );
        setState(() {
          widget.myHand[mano].cartas = response.body['cardsOnTable'];
          widget.myHand[mano].totalCards = response.body['totalCards'];
          widget.myHand[mano].myBlackjack = response.body['blackJack'];
          widget.myHand[mano].myDefeat = response.body['defeat'];
          widget.myHand[mano].plantado = true;
          widget.myHand[mano].firstHand = false;

        });
      }
    } catch (e) {
    }
  }

  void funcionSplit () async {
    try {
      final response = await widget.getConnect.put(
        '${EnlaceApp.enlaceBase}/api/singleBoard/split',
        {
          "boardId": widget.boardId,
          "cardsOnTable": widget.myHand[0].cartas,
        },
        headers: {
          "Authorization": widget.user.token,
        },
      );
      if (response.body['status'] == 'error' || response.body['status'] == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.body['message'], textAlign: TextAlign.center,),
            duration: Duration(seconds: 1),

          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Has dividido cartas", textAlign: TextAlign.center,),
            duration: Duration(seconds: 1),

          ),
        );
        setState(() {
          widget.myHand[0].cartas = response.body['cardsOnTableFirst'];
          widget.myHand[0].totalCards = response.body['totalCardsFirst'];
          widget.myHand[0].myBlackjack = response.body['blackJackFirst'];
          widget.myHand[0].myDefeat = response.body['defeatFirst'];
          widget.myHand[0].plantado = false;
          widget.myHand[0].firstHand = true;

          widget.myHand.add(Mano());

          widget.myHand[1].cartas = response.body['cardsOnTableSecond'];
          widget.myHand[1].totalCards = response.body['totalCardsSecond'];
          widget.myHand[1].myBlackjack = response.body['blackJackSecond'];
          widget.myHand[1].myDefeat = response.body['defeatSecond'];
          widget.myHand[1].plantado = false;
          widget.myHand[1].firstHand = true;

          widget.split = true;

        });
      }
    } catch (e) {
      print("ERRROOOOOR EN SPLIT" + e.toString());
    }
  }

  Widget botones(int mano) {
    return Column(   // Botones de Interacción
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if(!(!widget.myHand[mano].firstHand || widget.split || widget.myHand[mano].myBlackjack))
          if(cartasIguales())
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      funcionSplit();
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
        if(!(widget.myHand[mano].myBlackjack || !widget.myHand[mano].firstHand))
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    funcionDoblar(mano);
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
        if(!(widget.myHand[mano].myBlackjack || widget.myHand[mano].myDefeat || widget.myHand[mano].plantado))

          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    funcionPedirCarta(mano);
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
        if(!(widget.myHand[mano].myBlackjack || widget.myHand[mano].myDefeat || widget.myHand[mano].plantado))
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              ElevatedButton(
                  onPressed: () {
                    funcionPlantarse(mano);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColoresApp.segundoColor,
                    fixedSize: const Size(40, 50),
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
    );
  }

  AppBar barra() {
    return AppBar(
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
        IconButton(
          onPressed: () {
          //Abandonar partida (leaveBoard) y redirigir a principal
            leaveBoard(widget.boardId);
          },
          icon: const Icon(Icons.logout, color: Colors.white,),
        ),
      ],
    );
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {

    getCurrentRug();
    //codigo
    if (widget.resultadosRonda) {
      return Scaffold(
        backgroundColor: ColoresApp.fondoPantallaColor,
        appBar: barra(),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column (
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column (  // Cartas Banca
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Banca: ${widget.bankResultadosHand.totalBanca}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var card in widget.bankResultadosHand.cartas)
                          Image.asset(
                            'assets/valoresCartas/' + card['value'].toString() + '-' + card['suit'] + '.png',
                            width: 60, // Establece un tamaño máximo solo para el ancho
                            fit: BoxFit.scaleDown, // Ajusta automáticamente la altura según la proporción original de la imagen
                          ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    if (widget.split)
                      ...[
                        Column (  // Cartas Jugador
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Total: ${widget.myResultadosHand.total[1]}. Monedas ganadas: ${widget.myResultadosHand.coinsEarned[1]}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                for (var card in widget.myResultadosHand.cartas[1])
                                  Image.asset(
                                    'assets/valoresCartas/' + card['value'].toString() + '-' + card['suit'] + '.png',
                                    width: 90, // Establece un tamaño máximo solo para el ancho
                                    fit: BoxFit.scaleDown, // Ajusta automáticamente la altura según la proporción original de la imagen
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    if (widget.split)
                      const Row(
                        children: [
                          SizedBox(width: 10)
                        ],
                      ),
                    Column (  // Cartas Jugador
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Total: ${widget.myResultadosHand.total[0]}. Monedas ganadas: ${widget.myResultadosHand.coinsEarned[0]}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (var card in widget.myResultadosHand.cartas[0])
                              Image.asset(
                                'assets/valoresCartas/' + card['value'].toString() + '-' + card['suit'] + '.png',
                                width: 90, // Establece un tamaño máximo solo para el ancho
                                fit: BoxFit.scaleDown, // Ajusta automáticamente la altura según la proporción original de la imagen
                              ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    }
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
      return Scaffold(
        appBar: barra(),
        body: Stack (
          children: [
            // Imagen de fondo
            Positioned.fill(
            child: Image.network(
              '${EnlaceApp.enlaceBase}/images/${widget.currentRug}',
              fit: BoxFit.fitWidth,
            ),
          ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if(widget.split)
              botones(1),
            Column (
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column (  // Cartas Banca
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Banca: ${widget.bankHand.totalCards}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var card in widget.bankHand.cartas)
                          Image.asset(
                            'assets/valoresCartas/' + card['value'].toString() + '-' + card['suit'] + '.png',
                            width: 60, // Establece un tamaño máximo solo para el ancho
                            fit: BoxFit.scaleDown, // Ajusta automáticamente la altura según la proporción original de la imagen
                          ),
                      ],
                    )
                  ],
                ),
                Row(
                  children: [
                    if (widget.split)
                      Column (  // Cartas Jugador
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Total: ${widget.myHand[1].totalCards}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for (var card in widget.myHand[1].cartas)
                                Image.asset(
                                  'assets/valoresCartas/' + card['value'].toString() + '-' + card['suit'] + '.png',
                                  width: 90, // Establece un tamaño máximo solo para el ancho
                                  fit: BoxFit.scaleDown, // Ajusta automáticamente la altura según la proporción original de la imagen
                                ),
                            ],
                          )
                        ],
                      ),
                    if (widget.split)
                      Row(
                        children: [
                          SizedBox(width: 5,),
                          Container(
                            width: 1.0,
                            color: Colors.white,
                          ),
                          SizedBox(width: 5,),
                        ],
                      ),
                    Column (  // Cartas Jugador
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Total: ${widget.myHand[0].totalCards}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (var card in widget.myHand[0].cartas)
                              Image.asset(
                                'assets/valoresCartas/' + card['value'].toString() + '-' + card['suit'] + '.png',
                                width: 90, // Establece un tamaño máximo solo para el ancho
                                fit: BoxFit.scaleDown, // Ajusta automáticamente la altura según la proporción original de la imagen
                              ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
            botones(0),
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
    home: PracticeMode( "",
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