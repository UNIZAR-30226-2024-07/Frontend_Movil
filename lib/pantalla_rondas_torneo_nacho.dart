import 'package:flutter/material.dart';
import 'package:get/get_connect/connect.dart';

import 'Usuario.dart';
import 'colores.dart';

class TournamentRoundsScreenNacho extends StatefulWidget {
  final User user;
  final String idTorneo;

  const TournamentRoundsScreenNacho(this.user, this.idTorneo, {super.key});

  @override
  _TournamentRoundsScreenNachoState createState() => _TournamentRoundsScreenNachoState();
}

class _TournamentRoundsScreenNachoState extends State<TournamentRoundsScreenNacho> {
  bool _userInTournament = true;
  int ronda = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final isInTournament = await _isUserInTournament(widget.idTorneo);
    if (!isInTournament) {
      setState(() {
        _userInTournament = false;
      });
    } else {
      final r = await _getRoundInTournament(widget.idTorneo);
      setState(() {
        ronda = r;
        print("Se guarda la ronda: ");
        print(ronda);
      });
    }
  }

  Future<bool> _isUserInTournament(String idTorneo) async {
    try {
      final getConnect = GetConnect();
      final response = await getConnect.get(
        '${EnlaceApp.enlaceBase}/api/tournament/isUserInTournament/$idTorneo',
        headers: {
          "Authorization": widget.user.token,
        },
      );
      return response.body['status'] == "success";
    } catch (e) {
      print('Failed to load round data: $e');
      return false;
    }
  }

  Future<int> _getRoundInTournament(String idTorneo) async {
    try {
      final getConnect = GetConnect();
      final response = await getConnect.get(
        '${EnlaceApp.enlaceBase}/api/tournament/roundInTournament/$idTorneo',
        headers: {
          "Authorization": widget.user.token,
        },
      );
      return response.body['round'];
    } catch (e) {
      print('Failed to load round data: $e');
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColoresApp.fondoPantallaColor,
      appBar: AppBar(
        backgroundColor: ColoresApp.cabeceraColor,
        elevation: 2,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/logo.png',
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
      ),
      body: _userInTournament
          ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              crearImagen('assets/fotoRonda.jpeg', 'OCTAVOS', 100, 100, ronda < 8, ronda == 8),
              const Icon(Icons.arrow_right_alt, color: Colors.black, size: 50),
              crearImagen('assets/fotoRonda.jpeg', 'CUARTOS', 100, 100, ronda < 4, ronda == 4),
              const Icon(Icons.arrow_right_alt, color: Colors.black, size: 50),
              crearImagen('assets/fotoRonda.jpeg', 'SEMIFINAL', 100, 100, ronda < 2, ronda == 2),
              const Icon(Icons.arrow_right_alt, color: Colors.black, size: 50),
              crearImagen('assets/trofeo.png', 'FINAL', 120, 200, ronda < 1, ronda == 1),
            ],
          ),
        ],
      )
          : const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            '¡Has sido eliminado del torneo!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 40.0, bottom: 10.0),
            child: FloatingActionButton(
              onPressed: () {
                // Acción al presionar el botón de volver
              },
              backgroundColor: Colors.blue.shade300,
              child: const Icon(Icons.arrow_back),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
            child: FloatingActionButton(
              onPressed: () {

              },
              backgroundColor: Colors.red.shade300,
              child: const Icon(Icons.arrow_forward),
            ),
          ),
        ],
      ),
    );
  }

  Widget crearImagen(String imagePath, String text, double width, double height, bool completed, bool currentRound) {
    print("Se guarda la rondaAAAA: ");
    print(ronda);
    if (completed) {
      width -=10;
      height -=10;
    }
    else if (currentRound && ronda != 1) {
      width +=20;
      height +=20;
    }
    return Column(
      children: [
        Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13),
                border: Border.all(
                  color: completed ? Colors.green : (currentRound ? ColoresApp.segundoColor : Colors.transparent), // Borde verde si está completado, azul si es la ronda actual
                  width: 3,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  imagePath,
                  width: width,
                  height: height,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            if (completed)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            Positioned(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
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
        ),
      ],
    );
  }








}

void main() {
  runApp(MaterialApp(
    home: TournamentRoundsScreenNacho(
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
      '', // idTorneo
    ),
  ));
}
