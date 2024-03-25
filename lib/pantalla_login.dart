import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:psoft_07/colores.dart';
import 'package:psoft_07/Usuario.dart';
import 'package:psoft_07/pantalla_inicio.dart';
import 'package:psoft_07/pantalla_principal.dart';
import 'package:psoft_07/pantalla_registro.dart';
import 'package:get/get.dart';


class LoginScreen extends StatelessWidget {


  LoginScreen({super.key});


  TextEditingController nombre = TextEditingController();
  TextEditingController contrasenya = TextEditingController();
  final getConnect = GetConnect();

  void _login(nombre, contrasenya, context) async {
    final res = await getConnect.post('${EnlaceApp.enlaceBase}/api/user/login', {
      "nick":nombre,
      "password":contrasenya
    });

    if (res.body['status'] == 'error') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res.body['message'], textAlign: TextAlign.center,),
        ),
      );
    }
    else {

      if (res.body['user']['rol'] == 'user') {

        print(res.body['user']['avatars']);


        User user = User(
          id: res.body['user']['_id'],
          nick: res.body['user']['nick'],
          name: res.body['user']['name'],
          surname: res.body['user']['surname'],
          email: res.body['user']['email'],
          password: res.body['user']['password'],
          rol: res.body['user']['rol'],
          tournaments: [],
          coins: res.body['user']['coins'].toInt(),
          avatars: [],
          rugs: [],
          cards: [],
          token: res.body['token']);

        // Bucle para agregar cada avatar a la lista de avatares del usuario
        for (var avatarData in res.body['user']['tournaments']) {
          user.avatars.add(AvatarEntry(
            avatar: avatarData['tournaments'],
            current: avatarData['position'],
          ));
        }

        // Bucle para agregar cada avatar a la lista de avatares del usuario
        for (var avatarData in res.body['user']['avatars']) {
          user.avatars.add(AvatarEntry(
            avatar: avatarData['avatar'],
            current: avatarData['current'],
          ));
        }

        // Bucle para agregar cada avatar a la lista de avatares del usuario
        for (var avatarData in res.body['user']['rugs']) {
          user.avatars.add(AvatarEntry(
            avatar: avatarData['rug'],
            current: avatarData['current'],
          ));
        }

        // Bucle para agregar cada avatar a la lista de avatares del usuario
        for (var avatarData in res.body['user']['cards']) {
          user.avatars.add(AvatarEntry(
            avatar: avatarData['card'],
            current: avatarData['current'],
          ));
        }

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Principal(user)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Usuario no existe", textAlign: TextAlign.center,), // Para poner un mensaje
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColoresApp.fondoPantallaColor,
      body: Center(
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
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Inicio Sesion',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 25
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          SizedBox(
                            width: 300,
                            height: 40,
                            child: TextField(
                              controller: nombre,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
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
                          SizedBox(
                            height: 40,
                            width: 300, // Ajusta el tamaño del cuadro de texto de la contraseña para que coincida con el de usuario
                            child: TextField(
                              controller: contrasenya,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
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
                              _login(nombre.text, contrasenya.text, context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColoresApp.segundoColor,
                            ),
                            child: const Text(
                              'Iniciar Sesión',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),

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
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                              ),
                          ),

                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => RegisterScreen()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColoresApp.segundoColor,

                            ),
                            child: const Text(
                              'Registrarse',
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
                  const SizedBox(height: 10.0),
                ],
              ),


            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: LoginScreen(),
  ));
}
