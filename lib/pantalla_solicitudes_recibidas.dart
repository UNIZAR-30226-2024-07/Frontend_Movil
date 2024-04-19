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
      await getConnect.delete(
        '${EnlaceApp.enlaceBase}/api/friend/reject/$friendId',
        headers: {
          "Authorization": widget.user.token,
        },
      );
      setState(() {});
    } catch (e) {
      throw Exception('Failed to reject friend request');
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
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/logo.png', // Ruta de la imagen
            width: 50, // Ancho de la imagen
            height: 50, // Altura de la imagen
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
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            leading: FutureBuilder<String>(
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
