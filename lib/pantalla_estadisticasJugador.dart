import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:psoft_07/colores.dart';
import 'package:get/get.dart';
import 'Usuario.dart';

class estadisticasJugador extends StatelessWidget {

  final User user;
  estadisticasJugador(this.user, {super.key});

  final getConnect = GetConnect();

  void mostrarError(String mensaje, BuildContext context) {
    // Aquí puedes implementar la lógica para mostrar un pop-up con el mensaje de error
    // Por ejemplo, utilizando showDialog o ScaffoldMessenger.of(context).showSnackBar
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(mensaje),
      duration: Duration(seconds: 3),
    ));
  }

  Future<String> _getImageUrl() async {
    try {
      final response = await getConnect.get(
        '${EnlaceApp.enlaceBase}/api/avatar/currentAvatar',
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
      final getConnect = GetConnect();
      final response = await getConnect.get(
        '${EnlaceApp.enlaceBase}/api/stat/getAllUserStats',
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
      backgroundColor: ColoresApp.fondoPantallaColor,
      body: Center(
        child: Row( //Fila donde habrá dos columnas; una para foto perfil y otra para el texto de la segunda mitad de la pantalla
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
              ]
            ),
            SizedBox(height: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FutureBuilder<List<dynamic>>(
                  future: _getAllUserStats(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Mientras se espera la respuesta del servidor
                      return CircularProgressIndicator(); // Por ejemplo, puedes mostrar un indicador de carga
                    } else if (snapshot.hasError) {
                      // Si hay un error durante la solicitud
                      return Text('Error: ${snapshot.error}');
                    } else {
                      // Si la solicitud fue exitosa y se obtuvieron los datos
                      final List<dynamic> userStats = snapshot.data!;

                      // Aquí puedes usar userStats para construir tu interfaz de usuario
                      // Por ejemplo, si deseas mostrar los elementos en dos columnas:
                      return Column(
                        children: [
                          // Columna 1
                          Column(
                            children: userStats.map<Widget>((stat) {
                              // Aquí construyes los widgets para la primera columna
                              // Por ejemplo:
                              return Text(stat['nombre']); // Suponiendo que 'nombre' es un campo en tus estadísticas
                            }).toList(),
                          ),
                          // Columna 2
                          Column(
                            children: userStats.map<Widget>((stat) {
                              // Aquí construyes los widgets para la segunda columna
                              // Por ejemplo:
                              return Text(stat['valor'].toString()); // Suponiendo que 'valor' es un campo en tus estadísticas
                            }).toList(),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 20),

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
            token: "")
    ),
  ));
}
