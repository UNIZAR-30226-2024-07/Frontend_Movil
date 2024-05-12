import 'package:flutter/material.dart';
import 'package:psoft_07/pantalla_principal.dart';
import 'package:psoft_07/pantalla_privada_juego.dart';
import 'Usuario.dart';
import 'colores.dart';

enum Difficulty { beginner, medium, extreme }

class CreatePrivateGameScreen extends StatefulWidget {
  final User user;

  const CreatePrivateGameScreen(this.user, {Key? key}) : super(key: key);

  @override
  _CreatePrivateGameScreenState createState() => _CreatePrivateGameScreenState();
}

class _CreatePrivateGameScreenState extends State<CreatePrivateGameScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _name = '';
  String _password = '';
  Difficulty _bankLevel = Difficulty.beginner;
  int _numPlayers = 2;
  double _bet = 100;

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColoresApp.cabeceraColor,
        elevation: 2,
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Principal(widget.user)),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/logo.png',
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      body: Container(
        color: ColoresApp.fondoPantallaColor,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 250,
                  height: 33,
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
                            controller: _nameController,
                            onChanged: (value) {
                              setState(() {
                                _name = value;
                              });
                            },
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
                const SizedBox(height: 5),
                SizedBox(
                  width: 250,
                  height: 33,
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
                            controller: _passwordController,
                            onChanged: (value) {
                              setState(() {
                                _password = value;
                              });
                            },
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
                const SizedBox(height: 5),
                SizedBox(
                  width: 250,
                  height: 33,
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
                              value: _bankLevel,
                              dropdownColor: Colors.white,
                              onChanged: (value) {
                                setState(() {
                                  _bankLevel = value!;
                                });
                              },
                              items: [
                                DropdownMenuItem(
                                  value: Difficulty.beginner,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 15.0, top: 7.0),
                                        child: Text(
                                          'Beginner',
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
                                  value: Difficulty.medium,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 15.0, top: 7.0),
                                        child: Text(
                                          'Medium',
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
                                  value: Difficulty.extreme,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 15.0, top: 7.0),
                                        child: Text(
                                          'Expert',
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
                const SizedBox(height: 5),
                SizedBox(
                  width: 250,
                  height: 33,
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
                              value: _numPlayers,
                              onChanged: (value) {
                                setState(() {
                                  _numPlayers = value!;
                                });
                              },
                              items: [2, 3, 4].map<DropdownMenuItem<int>>((int value) {
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
                const SizedBox(height: 5.0),
                SizedBox(
                  width: 250,
                  height: 33,
                  child: Row(
                    children: [
                      const Icon(Icons.monetization_on, color: Colors.black),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                _bet = double.tryParse(value) ?? 0.0;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'Apuesta',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.only(left: 15, top: 0),
                            ),
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5.0),
                ElevatedButton(
                  onPressed: () {
                    if(_name == '') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("El nombre no es válido"),
                        ),
                      );
                    }
                    else if(_password == '') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("La contraseña no es válida"),
                        ),
                      );
                    }
                    else {
                      Map<String, dynamic> body = {
                        'body': {
                          'name': _name,
                          'password': _password,
                          'bankLevel': _bankLevel.toString().split('.').last,
                          'numPlayers': _numPlayers,
                          'bet': _bet,
                          'userId': widget.user.id,
                        }
                      };
                      Map<String, dynamic> bodyUnirse = {
                        'body': {
                          'name': '',
                          'password': '',
                          'userId': widget.user.id,
                        }
                      };
                      print("El body es:");
                      print(body);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PrivateGameScreen("", widget.user, body, bodyUnirse, true)),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColoresApp.segundoColor,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                    minimumSize: const Size(150, 25),
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
  runApp(MaterialApp(
    home: CreatePrivateGameScreen(
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
    ),
  ));
}
