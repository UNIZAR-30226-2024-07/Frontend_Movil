import 'package:flutter/material.dart';
import 'package:get/get_connect/connect.dart';
import 'package:psoft_07/Usuario.dart';
//import 'package:psoft_07/funcionesAvatar.dart';
import 'package:psoft_07/pantalla_buscar_amigos.dart';
import 'package:psoft_07/pantalla_carga.dart';
import 'package:psoft_07/pantalla_principal.dart';
import 'package:psoft_07/pantalla_solicitudes_recibidas.dart'; // Importa la pantalla de FriendRequestsScreen
import 'colores.dart';

class PublicGames extends StatefulWidget {
  //final FuncionesAvatar fAvatar = FuncionesAvatar();
  final User user;


  PublicGames(this.user, {super.key});

  @override
  _PublicGamesState createState() => _PublicGamesState();
}

class _PublicGamesState extends State<PublicGames> {

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
      List<dynamic> mesas = List<dynamic>.from(response.body['publicBoardTypes']);

      mesas.sort((mesa1, mesa2) {
        String bankLevel1 = mesa1['bankLevel'];
        String bankLevel2 = mesa2['bankLevel'];
        int bet1 = mesa1['bet'];
        int bet2 = mesa2['bet'];

        if (bankLevel1 != bankLevel2) { // se ordena por dificultad
          if (bankLevel1 == 'beginner') {
            return -1;
          } else if (bankLevel1 == 'medium') {
            if (bankLevel2 == 'beginner') {
              return 1;
            } else {
              return -1;
            }
          } else {
            return 1;
          }
        } else { // si la dificultad es la misma, se ordena por dinero apostado
          return bet1.compareTo(bet2);
        }
      });

      return mesas;
    } catch (e) {
      throw Exception('Failed to load board data');
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
        leading: GestureDetector(
          onTap: () {
            // Coloca aquí el código que deseas ejecutar cuando se haga tap en la imagen
            // Por ejemplo, puedes navegar a otra pantalla, mostrar un diálogo, etc.
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Principal(widget.user)),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/logo.png', // Ruta de la imagen
              width: 50, // Ancho de la imagen
              height: 50, // Altura de la imagen
              fit: BoxFit.cover,
            ),
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
                    scrollDirection: Axis.horizontal,
                    itemCount: publicGamesData?.length,
                    itemBuilder: (BuildContext context, int index) {
                      final mesa = publicGamesData?[index];

                      return Row(
                        children: [
                          Container(
                            width: 20,
                            color: ColoresApp.fondoPantallaColor
                          ),
                          Container(
                            height: 200,
                            width: 300,
                            decoration: BoxDecoration(
                              color: ColoresApp.cabeceraColor,
                              borderRadius: BorderRadius.circular(10), // Ajusta el radio de esquinas según sea necesario
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Center(
                                  child: Text(
                                    mesa["name"],
                                    style: const TextStyle(
                                      fontSize: 28, // Tamaño del texto
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  )
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Center(
                                      child: Text(
                                      dificultadMesa(mesa),
                                      style: const TextStyle(
                                        fontSize: 16, // Tamaño del texto
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        ),
                                      )
                                    ),
                                    Center(
                                      child: Text(
                                      "Apuesta por mano: ${mesa["bet"]}",
                                      style: const TextStyle(
                                        fontSize: 16, // Tamaño del texto
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        ),
                                      )
                                    ),
                                  ],
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    //Pantalla juego
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => LoadingScreen(mesa['_id'], widget.user)),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: ColoresApp.segundoColor,
                                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0), // Ajusta el relleno del botón
                                  ),
                                  child: const Text(
                                    'Jugar',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ),
                              ],
                            ),
                          ),
                        ],
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
    home: PublicGames(
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
