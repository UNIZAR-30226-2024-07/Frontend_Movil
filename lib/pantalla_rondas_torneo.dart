import 'package:flutter/material.dart';
import 'package:get/get_connect/connect.dart';
import 'package:psoft_07/pantalla_carga.dart';
import 'Usuario.dart';
import 'colores.dart';

class TournamentRoundsScreen extends StatelessWidget {
  final User user;
  final dynamic torneo;

  const TournamentRoundsScreen(this.user, this.torneo,  {super.key});

  Future<Map<String, dynamic>> _getTournamentInfoForUser(User user, dynamic tournament) async {
    final getConnect = GetConnect();
    final response = await getConnect.get(
      '${EnlaceApp.enlaceBase}/api/tournament/isUserInTournament',
      headers: {
        "Authorization": user.token,
        "id": tournament["_id"],
      },
    );

    if (response.statusCode == 200){ //si hay respuesta poner params del server
      int round = int.tryParse(response.body['round']) ?? 0 ; //mirar si lo que devuelve el server es stirng o entero
      Map<String, dynamic> responseData = {
        'empezado': true,
        'tournament': response.body['tournament'],
        'round': round,
      };
      return responseData;
    }
    else { //si no hay respuesta asumimos que no está en el torneo
      Map<String, dynamic> responseData = {
        'empezado': true,
        'tournament': response.body['tournament'],
        'round': "0",
      };
      return responseData;
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
        title: Center(
          child: Text(
            torneo["name"],
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28, // Tamaño del texto
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    body: FutureBuilder<Map<String, dynamic>>(
      future: _getTournamentInfoForUser(user, torneo),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Muestra un indicador de carga mientras se espera la respuesta.
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // Muestra un mensaje de error si hay algún problema.
        } else {
        String lastRound = snapshot.data?['round'] ?? "0";

        // Decidir qué imagen y texto mostrar según el valor del último round.
        String imagePathoctavos, imagePathCuartos, imagePathSemi, imagePathFinal;

        switch (lastRound){
          case "1":
            imagePathoctavos = 'assets/octavos.png';
            imagePathCuartos = 'assets/cuartos.png';
            imagePathSemi = 'assets/semifinal.png';
            imagePathFinal = 'assets/final.png';
          break;
          case "2":
            imagePathoctavos = 'assets/victoria.png';
            imagePathCuartos = 'assets/cuartos.png';
            imagePathSemi = 'assets/semifinal.png';
            imagePathFinal = 'assets/final.png';
          break;
          case "3":
            imagePathoctavos = 'assets/victoria.png';
            imagePathCuartos = 'assets/victoria.png';
            imagePathSemi = 'assets/semifinal.png';
            imagePathFinal = 'assets/final.png';
          break;
          case "4":
            imagePathoctavos = 'assets/victoria.png';
            imagePathCuartos = 'assets/victoria.png';
            imagePathSemi = 'assets/victoria.png';
            imagePathFinal = 'assets/final.png';
          break;
          default:
            imagePathoctavos = 'assets/octavos.png';
            imagePathCuartos = 'assets/cuartos.png';
            imagePathSemi = 'assets/semifinal.png';
            imagePathFinal = 'assets/final.png'; // Otra imagen por defecto si el round no coincide con ninguna de las opciones anteriores.
          break;
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildImageWithText(imagePathoctavos, "OCTAVOS", 100, 100),
            const Icon(Icons.arrow_right_alt,
              color: Colors.black,
              size: 50,
              shadows: [
                Shadow(
                  color: Colors.white,
                  offset: Offset(0, 0),
                  blurRadius: 5,
                ),
              ],
            ),
            _buildImageWithText(imagePathCuartos, "CUARTOS", 100, 100),
            const Icon(Icons.arrow_right_alt,
              color: Colors.black,
              size: 50,
              shadows: [
                Shadow(
                  color: Colors.white,
                  offset: Offset(0, 0),
                  blurRadius: 5,
                ),
              ],
            ),
            _buildImageWithText(imagePathSemi, "SEMIFINAL", 100, 100),
            const Icon(Icons.arrow_right_alt,
              color: Colors.black,
              size: 50,
              shadows: [
                Shadow(
                  color: Colors.white,
                  offset: Offset(0, 0),
                  blurRadius: 5,
                ),
              ],
            ),
            _buildImageWithText(imagePathFinal, "FINAL", 100, 100),
          ],
        );
        }
      },
    ),
      floatingActionButton: Row( //fila con los botones de volver hacia atrás y jugar
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 40.0, bottom: 10.0),
            child: FloatingActionButton(
              onPressed: () {
                // Acción al presionar el botón de volver
                //Simplemente vuelve a pantalla principal poruqe no está buscando partida
                Navigator.pop(context);
              },
              backgroundColor: Colors.blue.shade300,
              child: const Icon(Icons.arrow_back),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
            child: FloatingActionButton(
              onPressed: () {
                // Acción al presionar el botón de siguiente
                // Por hacer: Navegar a la siguiente pantalla o ejecutar alguna acción
                // En este caso, el botón de continuar implica buscar una nueva partida de torneo, por lo que vamos a la página correspondiente
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoadingScreen("idinventado", user)),//mesa['_id'], widget.user)),
                );
              },
              backgroundColor: Colors.red.shade300,
              child: const Icon(Icons.arrow_forward),
            ),
          ),
        ],
      ),
    );
  }
    Widget _buildImageWithText(String imagePath, String text, double width, double height) {
      return Stack(
        alignment: Alignment.topCenter, // Alinea el contenido al principio del Stack (parte superior).
          children: [
            ClipRRect(
            borderRadius: BorderRadius.circular(10), // Ajusta el radio de borde según tu preferencia.
            child: Image.asset(
            imagePath,
            width: width,
            height: height,
            fit: BoxFit.cover,
            ),
            ),
            Positioned(
            child: Padding(
            padding: const EdgeInsets.all(8.0), // Ajusta el espacio entre el texto y los bordes del contenedor.
            child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            height: -3,
            ),
            ),
            ),
          ),
        ],
      );
    }
}

void main() {
}
