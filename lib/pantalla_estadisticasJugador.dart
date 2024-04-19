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
      final response = await getConnect.get(
        '${EnlaceApp.enlaceBase}/api/stat/getAllUserStats',
        headers: {
          'Authorization': user.token, // Reemplaza con tu token de autorización
        },
      );
      if (response.statusCode == 200) {
        // Si la respuesta es exitosa, devuelve directamente la lista de estadísticas de usuario
        return List<dynamic>.from(response.body['userStats']);
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
              children:[
                FutureBuilder(future: _getAllUserStats(), builder: builder)
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
