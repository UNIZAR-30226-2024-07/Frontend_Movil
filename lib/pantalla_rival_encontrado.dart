import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Importa el paquete get
import 'Usuario.dart';
import 'colores.dart';

class RivalFoundScreen extends StatelessWidget {
  final String userId;
  final User user;

  const RivalFoundScreen({required this.user, required this.userId, Key? key});


  Future<Map<String, dynamic>> _fetchUserData() async {
    try {
      final getConnect = GetConnect(); // Crear una instancia de GetConnect

      final response = await getConnect.get(
        'https://backend-uf65.onrender.com/api/user/userById/$userId',
        headers: {
          "Authorization": user.token,
        },
      );
      return response.body;
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
          "Authorization": user.token,
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

  Future<String> _getAvatar(String _userId) async {
    try {
      final getConnect = GetConnect();
      final response = await getConnect.get(
        '${EnlaceApp.enlaceBase}/api/avatar/currentAvatarById/$_userId',
        headers: {
          "Authorization": user.token,
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
    return FutureBuilder<Map<String, dynamic>>(
      future: _fetchUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final userData = snapshot.data!;
          final userName = userData['user']['name'];
          print("El nombre del usuario es: ");
          print("${userName}");

          // Llama a _getStatByUserAndName para obtener el número de victorias
          return FutureBuilder<int>(
            future: _getStatByUserAndName(userId, 'Torneos ganados'),
            builder: (context, statSnapshot) {
              if (statSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (statSnapshot.hasError) {
                return Center(child: Text('Error: ${statSnapshot.error}'));
              } else {
                final victories = statSnapshot.data!;
                return FutureBuilder<String>(
                  future: _getAvatar(userId),
                  builder: (context, avatarSnapshot) {
                    if (avatarSnapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (avatarSnapshot.hasError) {
                      return Center(child: Text('Error: ${avatarSnapshot.error}'));
                    } else {
                      final avatarFileName = avatarSnapshot.data!;
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
                        body: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 10),
                              SizedBox(
                                height: 35,
                                width: 200,
                                child: SizedBox(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: ColoresApp.segundoColor,
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        '¡¡Rival Encontrado!!',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50), // Radio del borde circular
                                child: Image.network(
                                  avatarFileName,
                                  width: 110,
                                  height: 110,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Container(
                                height: 70,
                                width: 200,
                                decoration: BoxDecoration(
                                  color: ColoresApp.segundoColor,
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      userData['user']['name'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const Divider(color: Colors.white, thickness: 2),
                                    Text(
                                      'Nº Victorias: $victories',
                                      style: const TextStyle(
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
                        ),
                      );
                    }
                  },
                );
              }
            },
          );
        }
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: RivalFoundScreen(user:User(
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
        userId: ''),
  ));
}
