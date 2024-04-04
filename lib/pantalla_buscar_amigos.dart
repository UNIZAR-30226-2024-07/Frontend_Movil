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
        'https://backend-uf65.onrender.com/api/user/getAllUsers',
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

  Future<String> _getFriendAvatar(String avatarId) async {
    try {
      final getConnect = GetConnect();
      final response = await getConnect.get(
        'https://backend-uf65.onrender.com/api/avatar/avatarById/$avatarId',
        headers: {
          "Authorization": user.token,
        },
      );
      return response.body['avatar']['imageFileName'];
    } catch (e) {
      throw Exception('Failed to load user data');
    }
  }

  Future<String> _getImageUrl(String avatarId) async {
    final imageName = await _getFriendAvatar(avatarId);
    return "https://backend-uf65.onrender.com/images/$imageName";
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
        'https://backend-uf65.onrender.com/api/friend/add/$friendId',
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

  String currentAvatar(List<dynamic> avatars) {
    String avatarId = '660316f09ea0caeffda7def9';
    for (var avatar in avatars) {
      if (avatar['current']) {
        avatarId = avatar['avatar'];
        break;
      }
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
                      final avatarId = user['avatars'].isEmpty
                          ? '6603f0690c9c5706f2ebfb32'
                          : currentAvatar(user['avatars']);
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
                              future: widget._getImageUrl(avatarId),
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
                                if (!isFriend) {
                                  _addFriend(user['_id']);
                                } else {
                                  // Do something if already a friend
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: isFriend ? Colors.grey : ColoresApp.segundoColor,
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
