import 'package:flutter/material.dart';
import 'package:get/get_connect/connect.dart';
import 'package:psoft_07/Usuario.dart';
import 'package:psoft_07/pantalla_buscar_amigos.dart';
import 'package:psoft_07/pantalla_estadisticasJugador.dart';
import 'package:psoft_07/pantalla_principal.dart';
import 'package:psoft_07/pantalla_solicitudes_recibidas.dart'; // Importa la pantalla de FriendRequestsScreen
import 'colores.dart';

class FriendsScreen extends StatefulWidget {
  //final FuncionesAvatar fAvatar = FuncionesAvatar();
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

  _getUserFromMapString( Map friend, User userForToken){
    User amiguito = User(
        id: friend['_id'],
        nick: friend['nick'],
        name: friend['name'],
        surname: friend['surname'],
        email: friend['email'],
        password: friend['password'],
        rol: friend['rol'],
        tournaments: [],
        coins: friend['coins'].toInt(),
        avatars: [],
        rugs: [],
        cards: [],
        token: userForToken.token);

    return amiguito;
  }

  void _refreshFriendsList() {
    setState(() {
      // Coloca aquí el código necesario para actualizar la lista de amigos
      // Esto se ejecutará cuando se regrese de la pantalla de FriendRequestsScreen
    });
  }

  Future<void> _deleteFriend(String friendId) async {
    try {
      final getConnect = GetConnect();
      await getConnect.delete(
        '${EnlaceApp.enlaceBase}/api/friend/eliminateFriend/$friendId',
        headers: {
          "Authorization": widget.user.token,
        },
      );
    } catch (e) {
      throw Exception('Failed to delete friend');
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

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            onTap: () {
                              User amigoBuscado = _getUserFromMapString(friend, widget.user);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => estadisticasJugador(amigoBuscado)),
                              );
                            },
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
                            trailing: ElevatedButton(
                              onPressed: () {
                                // Elimina el amigo y actualiza la lista después de que se complete la eliminación
                                _deleteFriend(friend['_id']).then((_) {
                                  _refreshFriendsList();
                                }).catchError((error) {
                                  // Maneja cualquier error que pueda ocurrir durante la eliminación
                                  print('Error al eliminar amigo: $error');
                                });
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
