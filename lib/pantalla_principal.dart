import 'package:flutter/material.dart';
import 'package:get/get_connect/connect.dart';
import 'package:psoft_07/colores.dart';
import 'package:psoft_07/pantalla_ajustes.dart';
import 'package:psoft_07/pantalla_amigos.dart';
import 'package:psoft_07/pantalla_carga.dart';
import 'package:psoft_07/pantalla_cargaYTablero_torneo.dart';
import 'package:psoft_07/pantalla_eleccion_skins.dart';
import 'package:psoft_07/pantalla_inicio.dart';
import 'package:psoft_07/pantalla_partida_publica.dart';
import 'package:psoft_07/pantalla_principal_partida_privada.dart';
import 'package:psoft_07/pantalla_privada_reanudar.dart';
import 'package:psoft_07/pantalla_ranking.dart';
import 'package:psoft_07/pantalla_tienda.dart';
import 'package:psoft_07/pantalla_torneo.dart';
import 'package:psoft_07/pantalla_torneo_reanudar.dart';
import 'package:psoft_07/partida_publica_reanudar.dart';

import 'Usuario.dart';

class Principal extends StatelessWidget {

  final User user;
  bool hayRecompensa = false;
  int valorRecompensa = 0;
  bool imagenCargada = false;
  String imagenUrl = "";

  Principal(this.user, {super.key});

  Future hayPartidaPausada(context) async {
    try {
      final getConnect = GetConnect();
      final response = await getConnect.get(
        '${EnlaceApp.enlaceBase}/api/user/getPausedBoard',
        headers: {
          "Authorization": user.token,
        },
      );

      /*if (response.body['status'] == 'error' || response.body['exists'] == false) {
        return false;
      }
      else {
        // decir que hay una partida pausada y que si quiere reanudarla
        return true;
      }*/
      return response.body;
    } catch (e) {
    }
    //return false;
    return {'',''};
  }

  Future<String> _getImageUrl() async {
    try {
      final getConnect = GetConnect();
      final response = await getConnect.get(
        '${EnlaceApp.enlaceBase}/api/avatar/currentAvatar',
        headers: {
          "Authorization": user.token,
        },
      );
      return "${EnlaceApp.enlaceBase}/images/" + response.body['avatar']['imageFileName'];
    } catch (e) {
      return "";
    }
  }

  Future<int> _getCoins() async {
    try {
      final getConnect = GetConnect();
      final res = await getConnect.get('${EnlaceApp.enlaceBase}/api/user/verify',
        headers: {
          "Authorization": user.token,
        },
      );
      return res.body['user']['coins'].toInt();
    } catch (e) {
      return user.coins;
    }
  }

  void apiHayRecompensa(context) async {
    try {
      final getConnect = GetConnect();
      final response = await getConnect.get(
        '${EnlaceApp.enlaceBase}/api/user/coinsDailyReward',
        headers: {
          "Authorization": user.token,
        },
      );
      hayRecompensa = response.body['rewardDisponible'];
      valorRecompensa = response.body['coins'];
      (context as Element).markNeedsBuild();


    } catch (e) {
    }
  }

  void recogerRecompensa(context) async {
    try {
      final getConnect = GetConnect();
      final response = await getConnect.put(
        '${EnlaceApp.enlaceBase}/api/user/getDailyReward',
        '',
        headers: {
          "Authorization": user.token,
        },
      );
      if (response.body['status'] == 'error' || response.body['status'] == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.body['message'], textAlign: TextAlign.center,),
          ),
        );
      }
      user.coins = response.body['user']['coins'];

    } catch (e) {
    }
  }

  Future<void> cargaImagen() async {
    if (!imagenCargada) {
      imagenUrl = await _getImageUrl();
      user.coins = await _getCoins();

    }
  }

  Future<void> cargaCoins() async {
    user.coins = await _getCoins();
  }


  @override
  Widget build(BuildContext context) {
   cargaImagen();
    //cargaCoins();
    apiHayRecompensa(context);
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
          IconButton(
            onPressed: () async {
              /*bool hayPausada = await hayPartidaPausada(context);
              if (hayPausada) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("SIIII hay partidas pausadas", textAlign: TextAlign.center,),
                  ),
                );
              }
              else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("No hay partidas pausadas", textAlign: TextAlign.center,),
                  ),
                );
              }*/

              final respuesta = await hayPartidaPausada(context);
              if (respuesta['status'] == 'error' || respuesta['exists'] == false) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("No hay partidas pausadas", textAlign: TextAlign.center,),
                  ),
                );
              } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('¿Quieres reanudar la partida pausada?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        backgroundColor: ColoresApp.segundoColor,
                        content: const Column(
                          mainAxisSize: MainAxisSize.min,
                        ),
                        actions: <Widget>[
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    if (respuesta['boardType'] == "public") {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => LoadingScreenResume(respuesta['pausedBoard'], user)),
                                      );
                                    }
                                    else if (respuesta['boardType'] == "private") {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => PrivateScreenResume(respuesta['pausedBoard'], user)),
                                      );
                                    }
                                    else if (respuesta['boardType'] == "tournament") {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => TournamentScreenResume(respuesta['pausedBoard'], user)),// aqui iria la de torneo
                                      );
                                    }
                                    else {
                                      print("NO ENTRA NINGUN IF");
                                    }
                                    //Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text('Sí', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                SizedBox(width: 10),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                                    decoration: BoxDecoration(
                                      color: Colors.red[800],
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text('No', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  );

                }


            },
            icon: const Icon(Icons.pause, color: Colors.white,),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FriendsScreen(user)),
              );
            },
            icon: const Icon(Icons.group, color: Colors.white,),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RankingScreen(user)),
              );
            },
            icon: const Icon(Icons.format_list_numbered, color: Colors.white,),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen(user)),
              );
            },
            icon: const Icon(Icons.settings, color: Colors.white,),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WelcomeScreen()),
              );
            },
            icon: const Icon(Icons.logout, color: Colors.white,),
          ),
        ],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 150,),
            Text(
              user.coins.toString(),
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
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /*FutureBuilder<String>(
                  future: _getImageUrl(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return const Icon(Icons.error);
                    } else {
                      final imageUrl = snapshot.data!;
                      return CircleAvatar(
                        backgroundImage: NetworkImage(imageUrl),
                        radius: 50, // Tamaño deseado del CircleAvatar
                      );
                    }
                  },
                ),*/
                CircleAvatar(
                  backgroundImage: NetworkImage(imagenUrl),
                  radius: 50, // Tamaño deseado del CircleAvatar
                ),
                Text(
                  user.nick,
                  style: const TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 5),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SelectSkinsScreen(user)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColoresApp.segundoColor,
                  ),
                  child: const Text(
                    'Aspectos',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PublicGames(user)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColoresApp.segundoColor,
                ),
                child: const Text(
                    "Partida Publica",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PrivateMatchScreen(user)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColoresApp.segundoColor,
                ),
                child: const Text(
                    'Partida Privada',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TournamentGames(user)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColoresApp.segundoColor,
                ),
                child: const Text(
                    'Torneo',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Tienda",
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ShopScreen(user)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColoresApp.segundoColor,
                      fixedSize: Size(100, 100),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), // Ajusta el radio de esquinas según sea necesario
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.white,
                        size: 50,
                      ),
                    )
                ),

                if (hayRecompensa)
                  ElevatedButton(
                    onPressed: () {

                        hayRecompensa = false;
                        recogerRecompensa(context);
                        (context as Element).markNeedsBuild();


                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColoresApp.segundoColor,
                    ),
                    child: const Text(
                      'Recompensa',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}

void main() {
  runApp(MaterialApp(
    home: Principal(
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
  ));
}
