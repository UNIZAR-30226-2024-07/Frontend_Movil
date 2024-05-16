import 'package:flutter/material.dart';
import 'package:get/get_connect/connect.dart';
import 'package:psoft_07/Usuario.dart';
import 'package:psoft_07/pantalla_principal.dart';
import 'package:psoft_07/pantalla_rondas_torneo.dart';
import 'package:psoft_07/pantalla_rondas_torneo_nacho.dart';
import 'colores.dart';

class TournamentGames extends StatefulWidget {
  //final FuncionesAvatar fAvatar = FuncionesAvatar();
  final User user;
  TournamentGames(this.user, {super.key});

  @override
  _TournamentGamesState createState() => _TournamentGamesState();
}

class _TournamentGamesState extends State<TournamentGames> {

  List<dynamic>? tournamentGamesData;
  Future<List<dynamic>> _getAllTournamentGames() async {
    try {
      final getConnect = GetConnect();
      final response = await getConnect.get(
        '${EnlaceApp.enlaceBase}/api/tournament/getAll',
        headers: {
          "Authorization": widget.user.token,
        },
      );
      List<dynamic> torneos = List<dynamic>.from(response.body['tournaments']);

      torneos.sort((torneo1, torneo2) {
        String bankLevel1 = torneo1['bankLevel'];
        String bankLevel2 = torneo2['bankLevel'];
        int bet1 = torneo1['price'];
        int bet2 = torneo2['price'];

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

      return torneos;

    } catch (e) {
      throw Exception('Failed to load tournament data');
    }
  }
  Future<bool> _isUserInTournament(String idTorneo) async {
    try {
      final getConnect = GetConnect();
      final response = await getConnect.get(
        '${EnlaceApp.enlaceBase}/api/tournament/isUserInTournament/$idTorneo',
        headers: {
          "Authorization": widget.user.token,
        },
      );
      return response.body['status'] == "success";
    } catch (e) {
      print('Failed to load round data: $e');
      return false;
    }
  }


  _enterTournamentForCurrentUser(User user, String tournamentId) async {

    if (!(await _isUserInTournament(tournamentId))) {
      try {
        final getConnect = GetConnect();
        final response = await getConnect.put(
          '${EnlaceApp.enlaceBase}/api/tournament/enterTournament/$tournamentId', //TODO: preguntar si se pone aquí o en cuerpo el toruneamentID
          {
            "id": user.id
          },
          headers: {
            "Authorization": widget.user.token,
          },
        );
        ScaffoldMessenger.of(context).showSnackBar( //mostramos mensaje de error o
          SnackBar(
            duration: Duration(seconds: 3),
            content: Center( // Centra horizontalmente el contenido
              child: Text(response.body["message"]),
            ),
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TournamentRoundsScreenNacho(widget.user, tournamentId)),
        );

      } catch (e) {
        print('Error al enlistar al usuario $user en el torneo con Id: $tournamentId');
        return 0;
      }
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TournamentRoundsScreenNacho(widget.user, tournamentId)),
      );
    }
  }


  String dificultadTorneo (torneo){
    switch(torneo["bankLevel"]) {
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
        future: _getAllTournamentGames(),
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
            tournamentGamesData = snapshot.data;

            WidgetsBinding.instance!.addPostFrameCallback((_) {
              if (tournamentGamesData!.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'No se encontraron torneos',
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
                        'Torneos',
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
                    itemCount: tournamentGamesData?.length,
                    itemBuilder: (BuildContext context, int index) {
                      final torneo = tournamentGamesData?[index];

                      return Row(
                        children: [
                          Container(
                            width: 20,
                            color: ColoresApp.fondoPantallaColor
                          ),
                          Container(
                            height: 215,
                            width: 250,
                            decoration: BoxDecoration(
                              color: ColoresApp.cabeceraColor,
                              borderRadius: BorderRadius.circular(10), // Ajusta el radio de esquinas según sea necesario
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Center(
                                  child: Text(
                                    torneo["name"],
                                    style: const TextStyle(
                                      fontSize: 28, // Tamaño del texto
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  )
                                ),
                                Container(
                                  height: 1.0,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 5),

                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Center(
                                      child: Text(
                                      dificultadTorneo(torneo),
                                      style: const TextStyle(
                                        fontSize: 16, // Tamaño del texto
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        ),
                                      )
                                    ),
                                    Center(
                                      child: Text(
                                      "Precio de entrada: ${torneo["price"]}",
                                      style: const TextStyle(
                                        fontSize: 16, // Tamaño del texto
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        ),
                                      )
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/medalla_ganador.png', // Ruta de la imagen
                                          width: 50, // Ancho de la imagen
                                          height: 50, // Altura de la imagen
                                          fit: BoxFit.contain,
                                        ),
                                        Text(
                                          "${torneo["coins_winner"]}",
                                          style: const TextStyle(
                                            fontSize: 16, // Tamaño del texto
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(width: 40),
                                        Image.asset(
                                          'assets/medalla_segundo.png', // Ruta de la imagen
                                          width: 50, // Ancho de la imagen
                                          height: 50, // Altura de la imagen
                                          fit: BoxFit.contain,
                                        ),
                                        Text(
                                          "${torneo["coins_subwinner"]}",
                                          style: const TextStyle(
                                            fontSize: 16, // Tamaño del texto
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    //Entramos a la pantalla de rondas para ese torneo
                                    //Para cada torneo tenemos nuestro progreso, pudiendo participar en varios torneos simultáneamente
                                    _enterTournamentForCurrentUser(widget.user, torneo['_id']);
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
    home: TournamentGames(
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
