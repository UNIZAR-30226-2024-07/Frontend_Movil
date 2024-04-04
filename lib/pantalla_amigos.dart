import 'package:flutter/material.dart';
import 'package:get/get_connect/connect.dart';
import 'package:psoft_07/Usuario.dart';
import 'package:psoft_07/funcionesAvatar.dart';
import 'package:psoft_07/pantalla_buscar_amigos.dart';
import 'package:psoft_07/pantalla_solicitudes_recibidas.dart'; // Importa la pantalla de FriendRequestsScreen
import 'colores.dart';

class FriendsScreen extends StatefulWidget {
  final FuncionesAvatar fAvatar = FuncionesAvatar();
  final User user;

  FriendsScreen(this.user, {super.key});

  @override
  _FriendsScreenState createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  List<dynamic>? userData;
  Future<List<dynamic>> _getAllFriends() async {
    try {
      final getConnect = GetConnect();
      final response = await getConnect.get(
        '${EnlaceApp.enlaceBase}/api/friend/getAllFriends',
        headers: {
          "Authorization": widget.user.token,
        },
      );
      final friends = List<dynamic>.from(response.body['friend']);
      return friends;
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

  void _refreshFriendsList() {
    setState(() {
      // Coloca aquí el código necesario para actualizar la lista de amigos
      // Esto se ejecutará cuando se regrese de la pantalla de FriendRequestsScreen
    });
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
      body: FutureBuilder<List<dynamic>>(
        future: _getAllFriends(),
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
                      'No se encontraron amigos',
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
                            'Lista de amigos',
                            style: TextStyle(
                              fontSize: 16, // Tamaño del texto
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
                            trailing: ElevatedButton(
                              onPressed: () {
                                // Elimina el amigo y actualiza la lista
                                // _deleteFriend(friend['_id']);
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.red[900],
                              ),
                              child: const Text('Eliminar'),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],
            );
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 10.0, top: 70.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: 50, // Ancho deseado del botón flotante
              height: 50, // Alto deseado del botón flotante
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FriendRequestsScreen(widget.user)),
                  ).then((value) {
                    // Cuando se regresa de FriendRequestsScreen, actualiza la lista de amigos
                    _refreshFriendsList();
                  });
                },
                backgroundColor: ColoresApp.segundoColor,
                child: const Icon(Icons.notification_add, color: Colors.white),
              ),
            ),
            const SizedBox(width: 15),
            SizedBox(
              width: 50, // Ancho deseado del botón flotante
              height: 50, // Alto deseado del botón flotante
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchFriendsScreen(widget.user, userData!)),
                  );
                },
                backgroundColor: ColoresApp.segundoColor,
                child: const Icon(Icons.person_add, color: Colors.white),
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
    home: FriendsScreen(
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
