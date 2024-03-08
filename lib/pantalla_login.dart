import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:psoft_07/pantalla_registro.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/tapete_fondo_pantalla.jpg'),
            fit: BoxFit.cover,
          ),
        ),
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
                        color: Colors.red[800],
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Inicio Sesion',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            const SizedBox(
                              width: 300,
                              height: 40,
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Usuario',
                                  icon: Icon(
                                      Icons.person,
                                      color: Colors.white,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            const SizedBox(
                              height: 40,
                              width: 300, // Ajusta el tamaño del cuadro de texto de la contraseña para que coincida con el de usuario
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Contraseña',
                                  icon: Icon(
                                    Icons.lock,
                                    color: Colors.white,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                obscureText: true,

                              ),
                            ),
                            const SizedBox(height: 10.0),
                            ElevatedButton(
                              onPressed: () {
                                // Implementar la lógica de inicio de sesión aquí
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                              ),
                              child: const Text(
                                'Iniciar Sesión',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(height: 5.0),

                            Container(
                                height: 1.0,
                                color: Colors.white,
                            ),
                            const SizedBox(height: 10.0),
                            const Text(
                                'Si no tiene cuenta, pulse aquí',
                                style: TextStyle(color: Colors.white),
                            ),

                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,

                              ),
                              child: const Text(
                                'Registrarse',
                                style: TextStyle(color: Colors.white),
                              ),
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
  runApp(const MaterialApp(
    home: LoginScreen(),
  ));
}
