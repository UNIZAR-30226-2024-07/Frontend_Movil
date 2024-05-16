import 'package:flutter/material.dart';
import 'package:get/get_connect/connect.dart';
import 'package:psoft_07/Usuario.dart';
import 'package:psoft_07/pantalla_principal.dart';
import 'colores.dart';

class RankingScreen extends StatefulWidget {
  final User user;

  RankingScreen(this.user, {Key? key}) : super(key: key);

  @override
  _RankingScreenState createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  List<dynamic>? userData;
  String estadistica = "Torneos ganados";

  Future<List<dynamic>> _getAllUsers(String stat) async {
    try {
      final getConnect = GetConnect();
      final response = await getConnect.get(
        '${EnlaceApp.enlaceBase}/api/user/getAllUsers',
        headers: {
          "Authorization": widget.user.token,
        },
      );
      final List<dynamic> usersData = response.body['user'];

      var widgetUser = {
        'dailyReward': {},
        '_id': widget.user.id,
        'nick': widget.user.nick,
        'name': widget.user.name,
        'surname': widget.user.surname,
        'email': widget.user.email,
        'password': widget.user.password,
        'rol': widget.user.rol,
        'coins': widget.user.coins,
        'tournaments': [],
        'avatars': [],
        'rugs': [],
        'cards': [],
        'paused_board': [],
        'createdAt': "",
        'updatedAt': "",
        '__v': 0,

      };
      usersData.add(widgetUser);

      List<dynamic> usersWithUserRole = usersData.where((user) => user['rol'] == 'user').toList();



      final List<Future> statFutures = [];
      for (var user in usersWithUserRole) {
        statFutures.add(_getStatByUserAndName(user['_id'], stat).then((value) {
          user['stat'] = value;
        }));
      }

      await Future.wait(statFutures);
      usersWithUserRole.sort((a, b) => b['stat'].compareTo(a['stat']));

      return usersWithUserRole;
    } catch (e) {
      throw Exception('Failed to load user data');
    }
  }



  Future<int> _getStatByUserAndName(String userId, String stat) async {
    try {
      final getConnect = GetConnect();
      final response = await getConnect.get(
        '${EnlaceApp.enlaceBase}/api/stat/statByNameAndUser/$userId/$stat',
        headers: {
          "Authorization": widget.user.token,
        },
      );
      if (response.body['status'] == "error") {
        return 0;
      }
      return response.body['stat']['value'];
    } catch (e) {
      throw Exception('Failed to load stat data: $e');
    }
  }

  Color _getCircleColor(int index) {
    if (index == 0) {
      return Colors.amberAccent; // Dorado para el primero
    } else if (index == 1) {
      return Colors.grey; // Plateado para el segundo
    } else if (index == 2) {
      return Colors.brown; // Bronce para el tercero
    } else {
      return ColoresApp.segundoColor; // Color predeterminado para otros índices
    }
  }

  Future<String> _getAvatar(String _userId) async {
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColoresApp.fondoPantallaColor,
      appBar: AppBar(
        backgroundColor: ColoresApp.cabeceraColor,
        elevation: 2, // Ajusta el valor según el tamaño de la sombra que desees
        leading: GestureDetector(
          onTap: () {
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
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _getAllUsers(estadistica),
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
            userData = snapshot.data;

            WidgetsBinding.instance!.addPostFrameCallback((_) {
              if (userData!.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'No se encontraron usuarios',
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
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      width: 150,
                      decoration: BoxDecoration(
                        color: ColoresApp.segundoColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.format_list_numbered,
                            size: 20,
                            color: Colors.white,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Ranking',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: userData?.length,
                    itemBuilder: (BuildContext context, int index) {
                      final friend = userData?[index];
                      final bool shouldShow = friend['rol'] == "user";
                      return Visibility(
                        visible: shouldShow,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                          child: Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              leading: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _getCircleColor(index),
                                ),
                                child: Center(
                                  child: Text(
                                    '${index + 1}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black, // Color del texto dentro del círculo
                                    ),
                                  ),
                                ),
                              ),
                              title: Row(
                                children: [
                                  FutureBuilder<String>(
                                    future: _getAvatar(friend['_id']),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        return const Icon(Icons.error);
                                      } else {
                                        final imageUrl = snapshot.data!;
                                        return CircleAvatar(
                                          backgroundImage: NetworkImage(imageUrl),
                                          radius: 20,
                                        );
                                      }
                                    },
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              friend['nick'],
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const Spacer(), // Spacer para empujar friend['stat'] hacia la derecha
                                            Text(
                                              '$estadistica: ${friend['stat']}',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 0),
              ],
            );
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 40.0, top: 70.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    estadistica = "Torneos ganados";
                  });
                },
                backgroundColor: ColoresApp.segundoColor,
                child: const Icon(Icons.emoji_events, color: Colors.white),
              ),
            ),
            const SizedBox(width: 15),
            SizedBox(
              width: 50,
              height: 50,
              child: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    estadistica = "Monedas ganadas en partida";
                  });
                },
                backgroundColor: ColoresApp.segundoColor,
                child: const Icon(Icons.monetization_on, color: Colors.white),
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
    home: RankingScreen(
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
