import 'package:flutter/material.dart';
import 'package:get/get_connect/connect.dart';
import 'package:psoft_07/pantalla_carga.dart';
import 'Usuario.dart';
import 'colores.dart';

class TournamentRoundsScreenBackup extends StatelessWidget {
  final User user;
  final dynamic torneo;

  const TournamentRoundsScreenBackup(this.user, this.torneo,  {super.key});

  Future<Map<String, dynamic>> _getTournamentInfoForUser(User user, dynamic tournament) async {
    final getConnect = GetConnect();
    final response = await getConnect.get(
      '${EnlaceApp.enlaceBase}/api/tournament/isUserInTournament',
      headers: {
        "Authorization": user.token,
        "id": tournament["_id"],
      },
    );

    bool isError = response.statusCode != 200;
    String status = isError ? 'error' : 'success';

    Map<String, dynamic> responseData = {
      'status': status,
      'tournament': response.body['tournament'],
      'round': response.body['round'],
    };

    return responseData;
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildImageWithText('assets/fotoRonda.jpeg', 'OCTAVOS', 100, 100),
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
              _buildImageWithText('assets/fotoRonda.jpeg', 'CUARTOS', 100, 100),
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
              _buildImageWithText('assets/fotoRonda.jpeg', 'SEMIFINAL', 100, 100),
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
              _buildImageWithText('assets/trofeo.png', 'FINAL', 120, 200),
            ],
          ),
        ],
      ),
      floatingActionButton: Row(
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
      alignment: Alignment.topCenter, // Alinea el contenido al principio del Stack (parte superior)
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10), // Ajusta el radio de borde según tu preferencia
          child: Image.asset(
            imagePath,
            width: width,
            height: height,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          child: Padding(
            padding: const EdgeInsets.all(8.0), // Ajusta el espacio entre el texto y los bordes del contenedor
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  height: -3
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
