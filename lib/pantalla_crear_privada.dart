import 'package:flutter/material.dart';
import 'colores.dart';

enum Difficulty { Easy, Medium, Hard }

class CreatePrivateGameScreen extends StatefulWidget {
  const CreatePrivateGameScreen({super.key});

  @override
  _CreatePrivateGameScreenState createState() => _CreatePrivateGameScreenState();
}

class _CreatePrivateGameScreenState extends State<CreatePrivateGameScreen> {
  Difficulty _selectedDifficulty = Difficulty.Easy;
  int _selectedPlayerCount = 1; // Valor predeterminado para el número de jugadores

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: ColoresApp.cabeceraColor,
        elevation: 2,
        leading: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Image.asset(
            'assets/logo.png',
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
      ),
      body: Container(
        color: ColoresApp.fondoPantallaColor, // Fondo verde
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 250,
                  height: 34,
                  child: Row(
                    children: [
                      const Icon(Icons.person, color: Colors.black),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Nombre',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.only(left: 15, top: 0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 250,
                  height: 34,
                  child: Row(
                    children: [
                      const Icon(Icons.lock, color: Colors.black),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Contraseña',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.only(left: 15, top: 0),
                            ),
                            obscureText: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 250,
                  height: 34,
                  child: Row(
                    children: <Widget>[
                      const Icon(Icons.star, color: Colors.black),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<Difficulty>(
                              iconSize: 40.0,
                              value: _selectedDifficulty,
                              dropdownColor: Colors.white,
                              onChanged: (value) {
                                setState(() {
                                  _selectedDifficulty = value!;
                                });
                              },
                              items: [
                                DropdownMenuItem(
                                  value: Difficulty.Easy,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 15.0, top: 7.0),
                                        child: Text(
                                          'Fácil',
                                          style: TextStyle(color: Colors.grey[700]),
                                        ),
                                      ),
                                      Container(
                                        height: 1,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: Difficulty.Medium,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 15.0, top: 7.0),
                                        child: Text(
                                          'Intermedio',
                                          style: TextStyle(color: Colors.grey[700]),
                                        ),
                                      ),
                                      Container(
                                        height: 1,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: Difficulty.Hard,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 15.0, top: 7.0),
                                        child: Text(
                                          'Díficil',
                                          style: TextStyle(color: Colors.grey[700]),
                                        ),
                                      ),
                                      Container(
                                        height: 1,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 250,
                  height: 34,
                  child: Row(
                    children: <Widget>[
                      const Icon(Icons.group, color: Colors.black),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              iconSize: 40.0,
                              value: _selectedPlayerCount,
                              onChanged: (value) {
                                setState(() {
                                  _selectedPlayerCount = value!;
                                });
                              },
                              items: [1, 2, 3, 4].map<DropdownMenuItem<int>>((int value) {
                                return DropdownMenuItem<int>(
                                  value: value,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 15.0, top: 7.0),
                                        child: Text(
                                          value.toString(),
                                          style: TextStyle(color: Colors.grey[700]),
                                        ),
                                      ),
                                      Container(
                                        height: 1,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
                ElevatedButton(
                  onPressed: () {
                    // Implementa la lógica de creación de partida aquí
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColoresApp.segundoColor,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                    minimumSize: const Size(150, 25), // Establece el tamaño mínimo para el botón
                  ),
                  child: const Text(
                    'CREAR PARTIDA',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: CreatePrivateGameScreen(),
  ));
}
