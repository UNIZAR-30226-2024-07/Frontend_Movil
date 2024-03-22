import 'package:flutter/material.dart';
import 'package:get/get_connect/connect.dart';
import 'colores.dart';

class FriendsScreen extends StatelessWidget {
  final String userId;

  const FriendsScreen({Key? key, required this.userId}) : super(key: key);

  Future<Map<String, dynamic>> _fetchUserData() async {
    try {
      final getConnect = GetConnect();

      final res = await getConnect.post(
        'https://backend-uf65.onrender.com/api/user/login',
        {
          "nick": 'Usuario1',
          "password": 'Usuario1'
        },
      );
      final response = await getConnect.get(
        'https://backend-uf65.onrender.com/api/friend/getAllFriends?_id=$userId',
      );
      return response.body;
    } catch (e) {
      throw Exception('Failed to load user data');
    }
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
        future: _fetchUserData(),
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
            // Aquí puedes trabajar con los datos obtenidos en snapshot.data
            final userData = snapshot.data;
            // Por ejemplo, si tienes una lista de amigos, podrías mostrarla aquí
            // List<dynamic> friendsList = userData['friends'];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 10),
                SizedBox(
                  height: 35,
                  width: 100,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 260),
                    decoration: BoxDecoration(
                      color: ColoresApp.segundoColor,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: const Center(
                      child: Text(
                        'Lista de amigos',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20), // Ajusta el espacio vertical entre el cuadro de texto y el botón
              ],
            );
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 10.0, top: 80.0),
        child: FloatingActionButton(
          onPressed: () {
            // Acción al presionar el botón flotante
          },
          backgroundColor: ColoresApp.segundoColor,
          child: Icon(Icons.person_add, color: Colors.white),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: FriendsScreen(userId: '65f19bd94daf856b024c86dc'),
  ));
}
