import 'package:flutter/material.dart';
import 'package:get/get_connect/connect.dart';
import 'Usuario.dart';
import 'colores.dart';

class SearchFriendsScreen extends StatefulWidget {
  final User user;
  final List<dynamic> friendList;

  const SearchFriendsScreen(this.user, this.friendList, {super.key});

  Future<List<dynamic>> _getAllUsers(String searchText) async {
    try {
      final getConnect = GetConnect();
      final response = await getConnect.get(
        '${EnlaceApp.enlaceBase}/api/user/getAllUsers',
        headers: {
          "Authorization": user.token,
        },
      );
      final List<dynamic> usersData = response.body['user'];

      // Filtrar los usuarios cuyo nick coincida con la búsqueda
      final List<dynamic> filteredUsers = usersData
          .where((userData) =>
          (userData['nick'] as String)
              .toLowerCase()
              .contains(searchText.toLowerCase()))
          .toList();

      return filteredUsers;
    } catch (e) {
      throw Exception('Failed to load user data');
    }
  }


  @override
  _SearchFriendsScreenState createState() => _SearchFriendsScreenState();
}

class _SearchFriendsScreenState extends State<SearchFriendsScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  bool _showResults = false;
  final Map<String, bool> _sentRequests = {};

  Future<void> _addFriend(String friendId) async {
    try {
      final getConnect = GetConnect();
      final response = await getConnect.post(
        '${EnlaceApp.enlaceBase}/api/friend/add/$friendId',
        '',
        headers: {
          "Authorization": widget.user.token,
        },
      );

      setState(() {
        // Marcar la solicitud como enviada
        _sentRequests[friendId] = true;
      });
    } catch (e) {
      throw Exception('Failed to send friend request');
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 250.0),
            child: TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                hintText: 'Introduzca el nombre:',
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.transparent),
                ),

                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: IconButton(
                    icon: const Icon(Icons.search),
                    color: Theme.of(context).primaryColor, // Cambia al color principal de tu tema
                    onPressed: () {
                      setState(() {
                        _showResults = true;
                      });
                    },
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),
          Expanded(
            child: _showResults
                ? FutureBuilder<List<dynamic>>(
              future: widget._getAllUsers(_textEditingController.text),
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
                  final List<dynamic> users = snapshot.data!;
                  if (users.isEmpty) {
                    WidgetsBinding.instance?.addPostFrameCallback((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'No se encontraron resultados',
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
                    });
                  }
                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      final isFriend = widget.friendList.any((friend) => friend['_id'] == user['_id']);
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            leading: FutureBuilder<String>(
                              future: _getAvatar(user['_id']),
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
                              user['nick'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: ElevatedButton(
                              onPressed: () {
                                if (!isFriend && _sentRequests[user['_id']] != true) {
                                  _addFriend(user['_id']);
                                } else {
                                  // Do something if already a friend
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: isFriend || _sentRequests[user['_id']] == true ? Colors.grey : ColoresApp.segundoColor,
                              ),
                              child: Text(
                                isFriend ? 'Ya es tu amigo' : (_sentRequests[user['_id']] == true ? 'Solicitud enviada' : 'Enviar Solicitud'),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            )
                : Container(),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: SearchFriendsScreen(
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
      [], // Aquí deberías pasar la lista de amigos
    ),
  ));
}
