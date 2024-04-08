import 'package:flutter/material.dart';
import 'package:get/get_connect/connect.dart';
import 'package:psoft_07/Usuario.dart';
//import 'package:psoft_07/funcionesAvatar.dart';
import 'package:psoft_07/pantalla_buscar_amigos.dart';
import 'package:psoft_07/pantalla_solicitudes_recibidas.dart';
import 'colores.dart';

class FriendRequestsScreen extends StatefulWidget {
  //final FuncionesAvatar fAvatar = FuncionesAvatar();
  final User user;

  FriendRequestsScreen(this.user, {super.key});

  @override
  _FriendRequestsScreenState createState() => _FriendRequestsScreenState();
}

class _FriendRequestsScreenState extends State<FriendRequestsScreen> {
  Future<Map<String, dynamic>> _getAllReceivedRequests() async {
    try {
      final getConnect = GetConnect();
      final response = await getConnect.get(
        '${EnlaceApp.enlaceBase}/api/friend/getAllReceivedFriends',
        headers: {
          "Authorization": widget.user.token,
        },
      );
      return response.body;
    } catch (e) {
      throw Exception('Failed to load user data');
    }
  }

  Future<String> _getFriendAvatar(String avatarId) async {
    try {
      final getConnect = GetConnect();
      final response = await getConnect.get(
        '${EnlaceApp.enlaceBase}/api/avatar/avatarById/$avatarId',
        headers: {
          "Authorization": widget.user.token,
        },
      );
      return response.body['avatar']['imageFileName'];
    } catch (e) {
      throw Exception('Failed to load user data');
    }
  }

  Future<String> _getImageUrl(String avatarId) async {
    final imageName = await _getFriendAvatar(avatarId);
    return "${EnlaceApp.enlaceBase}/images/$imageName";
  }

  Future<void> _acceptFriendRequest(String friendId) async {
    try {
      final getConnect = GetConnect();
      await getConnect.put(
        '${EnlaceApp.enlaceBase}/api/friend/accept/$friendId',
        '',
        headers: {
          "Authorization": widget.user.token,
        },
      );
      setState(() {});
    } catch (e) {
      throw Exception('Failed to accept friend request');
    }
  }

  Future<void> _rejectFriendRequest(String friendId) async {
    try {
      final getConnect = GetConnect();
      await getConnect.put(
        '${EnlaceApp.enlaceBase}/api/friend/reject/$friendId',
        '',
        headers: {
          "Authorization": widget.user.token,
        },
      );
      setState(() {});
    } catch (e) {
      throw Exception('Failed to reject friend request');
    }
  }

  String currentAvatar(List<dynamic> avatars) {
    int i = 0;
    String avatarId = '660316f09ea0caeffda7def9';
    bool encontrado = false;

    while (i < avatars.length && !encontrado) {
      if (avatars[i]['current']) {
        avatarId = avatars[i]['avatar'];
        encontrado = true;
      }
      i++;
    }
    return avatarId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColoresApp.fondoPantallaColor,
      appBar: AppBar(
        toolbarHeight: 45,
        backgroundColor: ColoresApp.cabeceraColor,
        elevation: 2,
        leading: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Image.asset(
            'assets/logo.png',
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _getAllReceivedRequests(),
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
            final userData = snapshot.data;

            WidgetsBinding.instance!.addPostFrameCallback((_) {
              if (userData?['friend'].isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'No se encontraron solicitudes de amistad',
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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 270),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    width: 170, // Anchura del contenedor
                    decoration:  BoxDecoration(
                      color: ColoresApp.segundoColor, // Color de fondo
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people, // Icono de personas
                          size: 20, // Tamaño del icono
                          color: Colors.white, // Color del icono
                        ),
                        SizedBox(width: 5), // Espacio entre el icono y el texto
                        Text(
                          'Solicitudes Recibidas',
                          style: TextStyle(
                            fontSize: 16, // Tamaño del texto
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: userData?['friend'].length,
                    itemBuilder: (BuildContext context, int index) {
                      final friend = userData?['friend'][index];
                      String avatarId;
                      if (friend['avatars'].isEmpty) {
                        avatarId = '6603f0690c9c5706f2ebfb32'; // avatar default
                      } else {
                        avatarId = currentAvatar(friend['avatars']);
                      }
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            leading: FutureBuilder<String>(
                              future: _getImageUrl(avatarId),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return const Icon(Icons.error);
                                } else {
                                  final imageUrl = snapshot.data!;
                                  return CircleAvatar(
                                    backgroundImage: NetworkImage(imageUrl),
                                    radius: 25, // Tamaño deseado del CircleAvatar
                                  );
                                }
                              },
                            ),
                            title: Text(
                              friend['nick'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 108, // Ancho deseado del botón "Aceptar"
                                  height: 40,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _acceptFriendRequest(friend['_id']);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      fixedSize: Size(100, 50), // Tamaño deseado del botón "Aceptar"
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.green[900],
                                    ),
                                    child: Text('Aceptar'),
                                  ),
                                ),
                                const SizedBox(width: 8), // Espacio entre botones
                                SizedBox(
                                  width: 108, // Ancho deseado del botón "Rechazar"
                                  height: 40,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _rejectFriendRequest(friend['_id']);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      fixedSize: const Size(100, 50), // Tamaño deseado del botón "Rechazar"
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.red[900],
                                    ),
                                    child: const Text('Rechazar'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
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
    home: FriendRequestsScreen(
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
