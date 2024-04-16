import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Importa el paquete get
import 'colores.dart';

class RivalFoundScreen extends StatelessWidget {
  final String userId;

  const RivalFoundScreen({super.key, required this.userId});

  Future<Map<String, dynamic>> _fetchUserData() async {
    try {
      print("El id del usuario es: ");
      print("${userId}");

      final getConnect = GetConnect(); // Crear una instancia de GetConnect

      final res = await getConnect.post(
        'https://backend-uf65.onrender.com/api/user/login',
        {
          "nick": 'Usuario1',
          "password": 'Usuario1'
        },
      );
      print(res.body['status']);

      final response = await getConnect.get(
        'https://backend-uf65.onrender.com/api/user/userById?_id=$userId',
      );
      //print(response.body['status']);
      print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
      print(response.body);
      final userName = response.body['name'];
      print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
      print("El nombre del usuario es: ");
      print("$userName");
      return response.body;
    } catch (e) {
      throw Exception('Failed to load user data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _fetchUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final userData = snapshot.data!;
          final userName = userData['name'];
          print("El nombre del usuario es: ");
          print("${userName}");
          return Scaffold(
            backgroundColor: ColoresApp.fondoPantallaColor,
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
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 35,
                    width: 200,
                    child: SizedBox(
                      child: Container(
                        decoration: BoxDecoration(
                          color: ColoresApp.segundoColor,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: const Center(
                          child: Text(
                            '¡¡Rival Encontrado!!',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Image.asset(
                    'assets/logo.png',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 70,
                    width: 200,
                    decoration: BoxDecoration(
                      color: ColoresApp.segundoColor,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          userData['name'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Divider(color: Colors.white, thickness: 2),
                        Text(
                          'Nº Victorias: ${userData['victories']}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: RivalFoundScreen(userId: '65f1911d1111a1410368a691'),
  ));
}
