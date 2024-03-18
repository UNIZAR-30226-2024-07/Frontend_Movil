import 'package:flutter/material.dart';
import 'package:psoft_07/pantalla_login.dart';
import 'package:psoft_07/pantalla_registro.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40.0),
        child: AppBar(
        backgroundColor: Colors.brown[600],
          leading: Padding (
            padding: const EdgeInsets.only(left: 8.0, bottom: 5.0),
            child: Image.asset(
            'assets/logo.png',
            width: 30,
            height: 30,
            ),
          ),
        ),
      ),
        body: Center(
            child: Column (
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                ),
                child: const Text(
                  'Cambiar avatar',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ), // Cambia el color del texto si es necesario
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.white),

                ),
                child: const Text(
                  'Cambiar nombre usuario',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ), // Cambia el color del texto si es necesario
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.white),

                ),
                child: const Text(
                  'Cambiar contraseña',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ), // Cambia el color del texto si es necesario
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.white),

                ),
                child: const Text(
                  'Ver estadisticas',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ), // Cambia el color del texto si es necesario
                ),
              ),
            ],
          )
        ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: WelcomeScreen(),
  ));
}
