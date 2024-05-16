import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/connect.dart';
import 'package:psoft_07/colores.dart';
import 'package:psoft_07/Usuario.dart';
import 'package:psoft_07/pantalla_crear_privada.dart';
import 'package:psoft_07/pantalla_partida_publica.dart';
import 'package:psoft_07/pantalla_principal.dart';
import 'package:psoft_07/pantalla_unirse_privada.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:tuple/tuple.dart';
import 'package:psoft_07/pantalla_pausa.dart' as pause;
import 'Mano.dart';

class PrivateGameScreen extends StatefulWidget {
  final String idMesa;
  final User user;
  final Map<String, dynamic> bodyCrear;
  final Map<String, dynamic> bodyUnirse;
  final bool esCrear;
  final getConnect = GetConnect();
  bool socketConectado = false;
  bool hecho = false;

  bool UImesa = false;
  bool resultadosRonda = false;
  bool isChatActive = false;
  bool split = false;

  String boardId = "";
  String currentcard = "";
  String currentRug = "";


  //List<(String,String)> mensajes = [];
  List<Tuple3<String, String, String>> mensajes = [];
  TextEditingController mensajeUsuario = TextEditingController();

  List<Mano> myHand = [];
  ResultadosMano myResultadosHand = ResultadosMano();

  List<Mano> otherHand = [];
  List<ResultadosMano> otherResultadosHand = [];

  Mano bankHand = Mano();
  ResultadosMano bankResultadosHand = ResultadosMano();


  IO.Socket socket = IO.io(EnlaceApp.enlaceBase, <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false
  });

  //Variables chatWidget
  late Widget _chatWidget;
  bool _chatVisible = false;
  Map<String, String> urlAvatares = {};

  //Variables pauseWidget
  late Widget _pauseWidget;
  bool _pauseVisible = false;

  late int _secondsRemaining;
  late Timer? _timer;

  PrivateGameScreen(this.idMesa, this.user, this.bodyCrear, this.bodyUnirse, this.esCrear, {super.key});

  @override
  _PrivateGameScreenState createState() => _PrivateGameScreenState();
}

class _PrivateGameScreenState extends State<PrivateGameScreen> {
  double _progressValue = 0.0;
  TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Simulación de carga de datos
    print("LLEGO A INITSTATE");
    _simulateLoading();
  }

  void _startCountdown() {
    // Inicia un temporizador que actualiza el contador cada segundo
    widget._timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (widget._secondsRemaining == 0) {
          widget._timer?.cancel();
        } else {
          widget._secondsRemaining--;
        }
      });
    });
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
        setState(() {
          widget.currentRug = response.body['rug']['imageFileName'];
        });
      }
    } catch (e) {
      print(e);
      widget.currentRug = "d04b37e8-e508-4ba7-a087-3fe0d5e505ed-1711535889700.png";
    }
  }

  Future<bool> conexionBoardId(boardId) async {
    try {
      final response = await widget.getConnect.get(
        '${EnlaceApp.enlaceBase}/api/privateBoard/boardById/$boardId',
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

  Widget crearContador() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.access_time, color: ColoresApp.segundoColor),
          SizedBox(width: 8.0),
          Text(
            widget._secondsRemaining.toString(),
            style: TextStyle(fontSize: 24.0, color: ColoresApp.segundoColor),
          ),
        ],
      ),
    );
  }

  void conectarPartida() async {
    print("LLEGO A CONECTARPARTIDA");
    bool kDebugMode = true;

    setState(() {
      widget.socket.connect();
      widget.socketConectado = true;
      getCurrentCard();
      getCurrentRug();

    });

    widget.socket?.on("connect", (data) {
      if (kDebugMode) {
        print("Socket Connect Done");
      }
      emitEntrar();

    });

    widget.socket?.on("starting private board", (boardId) async {
      if (kDebugMode) {
        print("starting private board RECIBIDO :) --------------------");
      }

      widget.boardId = boardId;

      if(await conexionBoardId(boardId)) {

        Map<String, dynamic> body = {
          'body': {
            'boardId': boardId,
          }
        };
        print("SE ha emitidoooooooooooooooooooo");
        widget.socket.emit("players private ready", body);
      }
    });

    widget.socket?.on("play hand", (data) {
      print(data);
      if (data != null) {
        setState(() {
          myHand(data); // Cartas del Usuario
          bankHand(data);
          othersHand(data);
          widget.UImesa = true;
          widget.split = false;
          widget.resultadosRonda = false;
          widget._secondsRemaining = 30;
          _startCountdown();
        });
      }

    });

    widget.socket?.on("hand results", (data) {
      print(data);
      if (data != null) {
        setState(() {
          myResultadosHand(data);
          bankResultadosHand(data);
          othersResutadosHand(data);
          widget.user.coins = widget.myResultadosHand.currentCoins;
          widget.resultadosRonda = true;
        });
      }
    });

    Future<void> actualizarEstado(dynamic mensaje) async {
      if (widget.urlAvatares[mensaje['userId']] == null) {
        String avatarUrl = await getAvatar(mensaje['userId']);
        widget.urlAvatares[mensaje['userId']] = avatarUrl;
      }

      setState(() {
        if (mensaje['userId'] == widget.user.id) {
          widget.mensajes.add(Tuple3("Yo", mensaje['message'], mensaje['userId']));
          print("Yo envio el mensaje");
        } else {
          print("Me envian el mensaje");
          widget.mensajes.add(Tuple3(mensaje['name'], mensaje['message'], mensaje['userId']));
        }
        widget._chatWidget = crearChat(widget.mensajes);
      });
    }

    widget.socket?.on("new message", (mensaje) {
      if (mensaje != null) {
        actualizarEstado(mensaje);
      }
    });


    widget.socket?.on("players deleted", (data) {
      print(data);

      for (var usuario in data) {
        if (widget.user.id == usuario) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Ha sido expulsado de la partida por inactividad",
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
          setState(() {
            widget.socket.disconnect();
          });
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Principal(widget.user)),
          );
        }
      }


    });

    widget.socket?.on("finish board", (data) {
      print(data);

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
        setState(() {
          widget.socket.disconnect();
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Principal(widget.user)),
        );


    });


    widget.socket?.on("error", (data) {
      if (kDebugMode) {
        String mensaje = "";
        switch (data['message']) {
          case 'No hay ninguna partida empezada con el nombre proporcionado':
            mensaje = 'El nombre o la contraseña son incorrectos';
            break;
          case 'El usuario ya estaba esperando a jugar una partida':
            mensaje = 'No puede comenzar otra partida, ya tiene una empezada';
            break;
          default:
            mensaje = 'Se produjo un error, vuelva a intentarlo más tarde';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              mensaje,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            duration: Duration(seconds: 2),
          ),
        );
        setState(() {
          widget.socket.disconnect();
        });

        if (widget.esCrear) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreatePrivateGameScreen(widget.user)),
          );
        }
        else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => JoinPrivateMatchScreen(widget.user)),
          );
        }
      }
    });

  }

  Future emitEntrar() async {
    if (!widget.hecho) {
      try {
        widget.hecho = true;

        /*Map<String, dynamic> body = {
          'body': {
            'typeId': widget.idMesa,
            'userId': widget.user.id,
          }
        };*/
        print("LLEGO A EMITENTRAR");
        if (!widget.esCrear) {
          widget.socket?.emit('enter private board', widget.bodyUnirse);
        } else {
          widget.socket?.emit('create private board', widget.bodyCrear);
        }
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

  void othersHand (data) {
    widget.otherHand = [];
    int i = 0;
    for (var mano in data) {
      if (mano['userId'] != widget.user.id
          && mano['userId'] != "Bank") {
        widget.otherHand.add(Mano());
        widget.otherHand[i].initMano(mano['userId'], mano['cards'], mano['totalCards'], false, false, mano['blackJack'], true);
        i++;
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

  void othersResutadosHand (data) {
    widget.otherResultadosHand = [];
    int i = 0;
    for (var mano in data) {
      if (mano['userId'] != widget.user.id
          && mano['userId'] != "Bank") {
        widget.otherResultadosHand.add(ResultadosMano());
        widget.otherResultadosHand[i].initResultadoMano(mano['userId'], mano['userNick'], mano['cards'], mano['total'], mano['coinsEarned'], mano['currentCoins']);
        i++;
      }
    }
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  void funcionPlantarse (int mano) async {
    try {
      final response = await widget.getConnect.put(
        '${EnlaceApp.enlaceBase}/api/privateBoard/stick',
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
        '${EnlaceApp.enlaceBase}/api/privateBoard/drawCard',
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
        '${EnlaceApp.enlaceBase}/api/privateBoard/double',
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
            content: Text("Has doblado apuesta", textAlign: TextAlign.center,),
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
        '${EnlaceApp.enlaceBase}/api/privateBoard/split',
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
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Has dividido cartas", textAlign: TextAlign.center,),
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



  Widget crearChat(List<Tuple3<String, String, String>> mensajes) {
    return SizedBox(
      width: 250,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: mensajes.length,
                itemBuilder: (context, index) {
                  return crearChatAux(
                    usuario: mensajes[index].item1,
                    contenido: mensajes[index].item2,
                    urlAvatar: widget.urlAvatares[mensajes[index].item3]!.toString(),
                  );
                },
              ),
            ),
            campoMensaje(),
          ],
        ),
      ),
    );
  }


  Widget campoMensaje() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  hintText: 'Escribe un mensaje...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _sendMessage();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ColoresApp.segundoColor,
            ),
            child: const Text(
              'Enviar',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget crearChatAux({required String usuario, required String contenido, required String urlAvatar}) {
    bool esUsuarioActual = usuario == widget.user.id;
    print("La url es:");
    print(urlAvatar);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(urlAvatar),
            radius: 15,
          ),
          SizedBox(width: 5),
          Expanded(
            child: Column(
              crossAxisAlignment: esUsuarioActual ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  usuario,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 3),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: esUsuarioActual ? Colors.blue[100] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Text(contenido),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    String message = _messageController.text;
    if (message.isNotEmpty) {
      Map<String, dynamic> body = {
        'body': {
          'boardId': widget.boardId,
          'userId': widget.user.id,
          'message': message,
        }
      };
      print("El body enviado es:");
      print(body);
      widget.socket.emit("new private message", body);

      _messageController.clear();
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
        if(widget.isChatActive)
          Column(
            children: [

              Expanded(
                child: ListView.builder(
                  itemCount: widget.mensajes.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(widget.mensajes[index] as String),
                      // Puedes personalizar el estilo de cada mensaje aquí
                    );
                  },
                ),
              ),


              Row(
                children: [
                  TextField(
                    controller: widget.mensajeUsuario,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      hintText: 'Mensaje',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Map<String, dynamic> body = {
                          'body': {
                            'boardId': widget.boardId,
                            'userId': widget.user.id,
                            'message': widget.mensajeUsuario.text,
                          }
                        };
                        widget.socket.emit("new private message", body);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColoresApp.segundoColor,
                        fixedSize: Size(10, 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5), // Ajusta el radio de esquinas según sea necesario
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 5,
                        ),
                      )
                  ),
                ],
              )
            ],
          )
      ],
    );
  }

  funcionAbandonar() async {
    final res = await widget.getConnect.put(
      '${EnlaceApp.enlaceBase}/api/privateBoard/leaveBoard/${widget.boardId}',
      headers: {
        "Authorization": widget.user.token,
      },
      {}, //Esto sería el body pero en este caso no lo usamos
    );
    if (res.body['status'] == 'error') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res.body['message'], textAlign: TextAlign.center,),
        ),
      );
    }

    setState(() {
      widget.socket.disconnect();
    });

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Principal(widget.user)), // ir a la pantalla principal
    );
  }

  funcionPausa() async {
    final resPausa = await widget.getConnect.put(
      '${EnlaceApp.enlaceBase}/api/privateBoard/pause/${widget.boardId}',
      headers: {
        "Authorization": widget.user.token,
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

    setState(() {
      widget.socket.disconnect();
    });

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Principal(widget.user)), // ir a la pantalla principal
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
        Spacer(), // Espaciador flexible para empujar el contador al centro
        crearContador(), // Widget crearContador() en el medio
        Spacer(),
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
            //Mostrar menú de pausa de forma dinámica (flotando)
            funcionPausa();
          },
          icon: const Icon(Icons.pause, color: Colors.white,),
        ),
        IconButton(
          onPressed: () {
            print("Lista de mensajes antes de llamar a la funcion");
            print(widget.mensajes);
            setState(() {
              widget._chatWidget = crearChat(widget.mensajes);
              widget._chatVisible = !widget._chatVisible;
            });
          },
          icon: const Icon(Icons.chat, color: Colors.white,),
        ),
        IconButton(
          onPressed: () {
            //Abandonar partida (leaveBoard) y redirigir a principal
            funcionAbandonar();
          },
          icon: const Icon(Icons.logout, color: Colors.white,),
        ),
      ],
    );
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    //variables internas de este widget
    print("LLEGO A BUILD");
    Widget chatWidget = widget._chatVisible ? Expanded(child: widget._chatWidget) : SizedBox();
    Widget pauseWidget = widget._pauseVisible ? Expanded(child: widget._pauseWidget) : SizedBox();
    //codigo
    if (widget.resultadosRonda) {
      return Scaffold(
        backgroundColor: ColoresApp.fondoPantallaColor,
        appBar: barra(),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            chatWidget,
            pauseWidget,
            if(widget.otherResultadosHand != [])
              for (var mano in widget.otherResultadosHand)
                Column(   //Cartas Resto Jugadores
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Usuario: ${mano.userNick}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                      ),
                    ),
                    for (var i = 0; i < mano.cartas.length; i++)
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (mano.cartas[i].length !=0)
                            Text(
                              'Total: ${mano.total[i]}. Monedas ganadas: ${mano.coinsEarned[i]}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14
                              ),
                            ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for (var j = 0; j < mano.cartas[i].length; j++)
                                Image.asset(
                                  'assets/valoresCartas/' + mano.cartas[i][j]['value'].toString() + '-' + mano.cartas[i][j]['suit'] + '.png',
                                  width: 50, // Establece un tamaño máximo solo para el ancho
                                  fit: BoxFit.scaleDown, // Ajusta automáticamente la altura según la proporción original de la imagen
                                ),
                            ],
                          ),
                        ],
                      ),
                  ],
                ),
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
      if (!(widget.hecho || widget.socketConectado)) {
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
        backgroundColor: ColoresApp.fondoPantallaColor,
        appBar: barra(),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            chatWidget,
            pauseWidget,
            Column(   //Cartas Resto Jugadores
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(widget.otherHand != [])
                  for (var mano in widget.otherHand)

                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var card in mano.cartas)
                          Image.network(
                            '${EnlaceApp.enlaceBase}/images/${widget.currentcard}',
                            width: 50, // Establece un tamaño máximo solo para el ancho
                            fit: BoxFit.scaleDown, // Ajusta automáticamente la altura según la proporción original de la imagen
                          ),
                      ],
                    )
              ],
            ),

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
      );
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: PrivateGameScreen(
      "",
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
      const {},
      const {},
      false,
    ),
  ));
}
