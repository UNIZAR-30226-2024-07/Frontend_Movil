import 'package:flutter/material.dart';
import 'package:get/get_connect/connect.dart';
import 'package:psoft_07/colores.dart';
import 'package:psoft_07/pantalla_principal.dart';
import 'package:psoft_07/pantalla_registro.dart';

import 'Usuario.dart';

class RegisterScreenPassword extends StatelessWidget {

  TextEditingController name;
  TextEditingController surname;
  TextEditingController nickname;

  RegisterScreenPassword(this.name, this.surname, this.nickname, {Key? key}) : super(key: key);

  TextEditingController mail = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController checkPassword = TextEditingController();

  final getConnect = GetConnect();

  void _registrarse(name, surname, nickname, mail,
    password, checkPassword, context) async {
    // Verifica que las contraseñas sean iguales
    if (password != checkPassword) {
      // Si las contraseñas no son iguales, muestra un mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Las contraseñas no coinciden.', textAlign: TextAlign.center),
      ));
      return;
    }

    // Verifica que las contraseñas tengan al menos 6 caracteres de longitud
    if (password.length < 6 || checkPassword.length < 6) {
      // Si la longitud de las contraseñas es menor que 6, muestra un mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Las contraseñas deben tener al menos 6 caracteres.', textAlign: TextAlign.center),
      ));
      return;
    }

    // Verifica que las contraseñas contengan al menos una mayúscula y un número
    if (!password.contains(RegExp(r'[A-Z]')) || !password.contains(RegExp(r'[0-9]')) || !password.contains(RegExp(r'[a-z]'))) {
      // Si las contraseñas no cumplen con los requisitos, muestra un mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Las contraseñas deben contener al menos una mayúscula, una minúscula y un número.', textAlign: TextAlign.center),
      ));
      return;
    }

    final res = await getConnect.post('${EnlaceApp.enlaceBase}/api/user/add', {
      "nick":nickname,
      "name":name,
      "surname":surname,
      "email":mail,
      "password":password
    });

    if (res.body['status'] == 'error') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res.body['message'], textAlign: TextAlign.center,),
        ),
      );
    }
    else {

      User user = User(
          id: res.body['user']['_id'],
          nick: res.body['user']['nick'],
          name: res.body['user']['name'],
          surname: res.body['user']['surname'],
          email: res.body['user']['email'],
          password: res.body['user']['password'],
          rol: res.body['user']['rol'],
          coins: res.body['user']['coins'],
          tournaments: [],
          avatars: [],
          rugs: [],
          cards: [],
          token: res.body['token']);

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
      }
  }

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
                                controller: mail,
                                decoration: const InputDecoration(
                                  hintText: 'Correo',
                                  icon: Icon(Icons.mail, color: Colors.white,),
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
                                controller: password,
                                decoration: const InputDecoration(
                                  hintText: 'Contraseña',
                                  icon: Icon(Icons.lock, color: Colors.white),
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
                                controller: checkPassword,
                                decoration: const InputDecoration(
                                  hintText: 'Repita contraseña',
                                  icon: Icon(Icons.lock, color: Colors.white),
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
                                        MaterialPageRoute(builder: (context) => RegisterScreen()),
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
                                      _registrarse(name.text, surname.text, nickname.text, mail.text,
                                          password.text, checkPassword.text,context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: ColoresApp.segundoColor,
                                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0), // Ajusta el relleno del botón
                                    ),
                                    child: const Text(
                                      'Registrarse',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
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
    home: RegisterScreenPassword(TextEditingController(), TextEditingController(), TextEditingController()),
  ));
}
