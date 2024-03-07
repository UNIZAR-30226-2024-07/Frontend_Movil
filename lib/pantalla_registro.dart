import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

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
                      height: 310,
                      decoration: BoxDecoration(
                        color: Colors.red[800],
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 250,
                              height: 40,
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Nombre y Apellidos',
                                  icon: Icon(Icons.person),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            const SizedBox(
                              width: 250,
                              height: 40,
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Nombre de usuario',
                                  icon: Icon(Icons.person),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            const SizedBox(
                              width: 250,
                              height: 40,
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Correo',
                                  icon: Icon(Icons.email),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            const SizedBox(
                              width: 250,
                              height: 40,
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Contraseña',
                                  icon: Icon(Icons.lock),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                obscureText: true,
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            const SizedBox(
                              width: 250,
                              height: 40,
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Repita la contraseña',
                                  icon: Icon(Icons.lock),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                obscureText: true,
                              ),
                            ),
                            const SizedBox(height: 0.0),
                            ElevatedButton(
                              onPressed: () {
                                // Implementar la lógica de registro aquí
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0), // Ajusta el relleno del botón
                                minimumSize: Size(50.0, 5.0), // Define el tamaño mínimo del botón
                              ),
                              child: const Text(
                                'Enviar',
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
    home: RegisterScreen(),
  ));
}
