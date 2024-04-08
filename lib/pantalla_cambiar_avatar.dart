import 'package:flutter/material.dart';
import 'package:get/get_connect/connect.dart';
import 'package:psoft_07/Usuario.dart';
//import 'package:psoft_07/funcionesAvatar.dart';
import 'package:psoft_07/pantalla_buscar_amigos.dart';
import 'package:psoft_07/pantalla_solicitudes_recibidas.dart'; // Importa la pantalla de FriendRequestsScreen
import 'colores.dart';

class ChangeAvatar extends StatefulWidget {
  //final FuncionesAvatar fAvatar = FuncionesAvatar();
  final User user;


  ChangeAvatar(this.user, {super.key});

  @override
  _ChangeAvatarState createState() => _ChangeAvatarState();
}

class _ChangeAvatarState extends State<ChangeAvatar> {

  List<dynamic>? publicGamesData;
  Future<List<dynamic>> _getAllPublicGames() async {
    try {
      final getConnect = GetConnect();
      final response = await getConnect.get(
        '${EnlaceApp.enlaceBase}/api/publicBoardType/getAll',
        headers: {
          "Authorization": widget.user.token,
        },
      );
      final mesas = List<dynamic>.from(response.body['publicBoardTypes']);
      return mesas;
    } catch (e) {
      throw Exception('Failed to load user data');
    }
  }


  String dificultadMesa (mesa){
    switch(mesa["bankLevel"]) {
      case 'beginner':
        return "Dificultad: Principiante";
      case 'medium':
        return "Dificultad: Medio";
      case 'expert':
        return "Dificultad: Experto";
      default:
        return "error";
    }

  }

  @override
  Widget build(BuildContext context) {
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
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _getAllPublicGames(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            publicGamesData = snapshot.data;

            WidgetsBinding.instance!.addPostFrameCallback((_) {
              if (publicGamesData!.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'No se encontraron mesas publicas',
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
              }
            });

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration:  BoxDecoration(
                        color: ColoresApp.segundoColor, // Color de fondo
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Mesas Publicas',
                        style: TextStyle(
                          fontSize: 16, // Tamaño del texto
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.user.avatars.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(widget.user.avatars[index].avatar),
                        ),
                        title: Text(widget.user.avatars[index].current.toString()),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ChangeAvatar(
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