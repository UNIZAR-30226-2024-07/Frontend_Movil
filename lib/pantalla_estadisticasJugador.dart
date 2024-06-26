import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:psoft_07/colores.dart';
import 'package:get/get.dart';
import 'package:psoft_07/pantalla_principal.dart';
import 'Usuario.dart';

class estadisticasJugador extends StatelessWidget {

  final User user;
  final bool misEstadisticas;
  final User otroUser;


  estadisticasJugador(this.user, this.misEstadisticas, this.otroUser, {super.key});

  final getConnect = GetConnect();
  void mostrarError(String mensaje, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 3),
        content: Center( // Centra horizontalmente el contenido
          child: Text(mensaje),
        ),
      ),

    );
  }

  Future<String> _getImageUrl() async {
    try {
      String url;
      if (misEstadisticas) {
        url = '${EnlaceApp.enlaceBase}/api/avatar/currentAvatarById/${user.id}';
      } else {
        url = '${EnlaceApp.enlaceBase}/api/avatar/currentAvatarById/${otroUser.id}';
      }
      final response = await getConnect.get(
        url,
        headers: {
          "Authorization": user.token,
        },
      );
      return "${EnlaceApp.enlaceBase}/images/" +
          response.body['avatar']['imageFileName'];
    } catch (e) {
      return "";
    }
  }


  Future<List<dynamic>> _getAllUserStats() async {
    try {
      String url;
      if (misEstadisticas) {
        url = "${EnlaceApp.enlaceBase}/api/stat/getAllStatsByUser/${user.id}";
      } else {
        url = "${EnlaceApp.enlaceBase}/api/stat/getAllStatsByUser/${otroUser.id}";
      }
      final getConnect = GetConnect();
      final response = await getConnect.get(
        url,
        headers: {
          'Authorization': user.token, // Reemplaza con tu token de autorización
        },
      );

      if (response.statusCode == 200) {
        // Si la respuesta es exitosa, devuelve directamente la lista de estadísticas de usuario
        final stats = List<dynamic>.from(response.body['userStats']);
        return stats;
      } else {
        // Manejar casos de error de la solicitud HTTP
        throw Exception('Error al obtener las estadísticas del usuario: ${response.statusCode}');
      }
    } catch (e) {
      // Manejar errores de conexión o decodificación JSON
      throw Exception('Error en la solicitud: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColoresApp.cabeceraColor,
        elevation: 2, // Ajusta el valor según el tamaño de la sombra que desees
        leading: GestureDetector(
          onTap: () {
            // Coloca aquí el código que deseas ejecutar cuando se haga tap en la imagen
            // Por ejemplo, puedes navegar a otra pantalla, mostrar un diálogo, etc.
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Principal(user)),
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
      backgroundColor: ColoresApp.fondoPantallaColor,
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
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Icon(Icons.error);
                    } else {
                      final imageUrl = snapshot.data!;
                      return CircleAvatar(
                        backgroundImage: NetworkImage(imageUrl),
                        radius: 50,
                      );
                    }
                  },
                ),
                if (misEstadisticas)
                  Text(
                    user.nick,
                    style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                if (!misEstadisticas)
                  Text(
                    otroUser.nick,
                    style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                    ),
                  ),
              ],
            ),
            SizedBox(width: 20), // Añade un espacio entre las columnas
            SingleChildScrollView( // Envuelve solo la segunda columna con SingleChildScrollView
              scrollDirection: Axis.horizontal,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FutureBuilder<List<dynamic>>(
                    future: _getAllUserStats(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else {
                        final statsList = snapshot.data;

                        // Dividir la lista de estadísticas en dos sublistas para hacer 2 rows
                        final int halfLength = (statsList!.length / 2).ceil();
                        final List<List<dynamic>> dividedStats = [
                          statsList.sublist(0, halfLength),
                          statsList.sublist(halfLength),
                        ];

                        return Row(
                          children: dividedStats.map<Widget>((statsSublist) {
                            return Column(
                              children: statsSublist.map<Widget>((statsMap) {
                                final name = statsMap['name'];
                                final value = statsMap['value'];
                                return Container(
                                  margin: EdgeInsets.all(5),
                                  padding: EdgeInsets.all(10),
                                  width: MediaQuery.of(context).size.width * 0.4,
                                  decoration: BoxDecoration(
                                    color: ColoresApp.cabeceraColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '$name',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        '$value',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),
                ],
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
    home: estadisticasJugador(
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
            token: ""),
      true,
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
          token: ""),
    ),
  ));
}
