import 'package:flutter/material.dart';
import 'package:get/get_connect/connect.dart';
import 'package:psoft_07/colores.dart';
import 'package:psoft_07/pantalla_ajustes.dart';
import 'package:psoft_07/pantalla_amigos.dart';
import 'package:psoft_07/pantalla_partida_publica.dart';
import 'package:psoft_07/pantalla_principal_partida_privada.dart';

import 'Usuario.dart';

class Principal extends StatelessWidget {

  final User user;

  Principal(this.user, {super.key});

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
        actions: [
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
              // Acción para el botón de Ranking
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
        ],
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FutureBuilder<String>(
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
                ),
                Text(
                  user.nick,
                  style: const TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                  ),
                )

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
                    MaterialPageRoute(builder: (context) => const PrivateMatchScreen()),
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
                  // Acción para el botón de Torneo
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
                ElevatedButton(
                    onPressed: () {

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
                const Text(
                  "Tienda",
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                  ),
                )
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
