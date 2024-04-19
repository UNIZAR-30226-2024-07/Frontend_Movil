import 'package:flutter/material.dart';
import 'package:psoft_07/colores.dart';
import 'package:psoft_07/pantalla_inicio.dart';
import 'package:psoft_07/pantalla_login.dart';
import 'package:psoft_07/pantalla_registro_password.dart';


class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);

  TextEditingController name = TextEditingController();
  TextEditingController surname = TextEditingController();
  TextEditingController nickname = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColoresApp.fondoPantallaColor,
      body: Container(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 400,
                      height: 300,
                      decoration: BoxDecoration(
                        color: ColoresApp.cabeceraColor,
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Registro Usuario',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            SizedBox(
                              width: 250,
                              height: 40,
                              child: TextField(
                                controller: name,
                                decoration: const InputDecoration(
                                  hintText: 'Nombre',
                                  icon: Icon(Icons.person, color: Colors.white,),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            SizedBox(
                              width: 250,
                              height: 40,
                              child: TextField(
                                controller: surname,
                                decoration: const InputDecoration(
                                  hintText: 'Apellidos',
                                  icon: Icon(Icons.person, color: Colors.white),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            SizedBox(
                              width: 250,
                              height: 40,
                              child: TextField(
                                controller: nickname,
                                decoration: const InputDecoration(
                                  hintText: 'Nickname',
                                  icon: Icon(Icons.person, color: Colors.white),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: ColoresApp.segundoColor,
                                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0), // Ajusta el relleno del botón
                                      fixedSize: const Size(100.0, 30.0), // Define el tamaño mínimo del botón
                                    ),
                                    child: const Icon(Icons.arrow_back , color: Colors.white,)
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => RegisterScreenPassword(name, surname, nickname)),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: ColoresApp.segundoColor,
                                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0), // Ajusta el relleno del botón
                                      fixedSize: const Size(100.0, 30.0), // Define el tamaño mínimo del botón
                                    ),
                                    child: const Icon(Icons.arrow_forward, color: Colors.white,)
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                  ],
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
    home: RegisterScreen(),
  ));
}
