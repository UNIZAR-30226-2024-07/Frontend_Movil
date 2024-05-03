import 'package:flutter/material.dart';
import 'package:get/get_connect/connect.dart';
import 'package:psoft_07/Usuario.dart';
import 'package:psoft_07/pantalla_principal.dart';
import 'colores.dart';

class SelectSkinsScreen extends StatefulWidget {
  late final User user;
  final getConnect = GetConnect();

  SelectSkinsScreen(this.user, {Key? key}) : super(key: key);

  @override
  _SelectSkinsState createState() => _SelectSkinsState();

  Future<List<dynamic>> _getAllAvatars() async {
    try {
      final getConnect = GetConnect();
      final response = await getConnect.get(
        '${EnlaceApp.enlaceBase}/api/avatar/getAllMyAvatars',
        headers: {
          "Authorization": user.token,
        },
      );
      return response.body['avatars'];
    } catch (e) {
      throw Exception('Failed to load avatar data');
    }
  }

  Future<List<dynamic>> _getAllRugs() async {
    try {
      final getConnect = GetConnect();
      final response = await getConnect.get(
        '${EnlaceApp.enlaceBase}/api/rug/getAllMyRugs',
        headers: {
          "Authorization": user.token,
        },
      );
      return response.body['rugs'];
    } catch (e) {
      throw Exception('Failed to load rug data');
    }
  }

  Future<List<dynamic>> _getAllCards() async {
    try {
      final getConnect = GetConnect();
      final response = await getConnect.get(
        '${EnlaceApp.enlaceBase}/api/card/getAllMyCards',
        headers: {
          "Authorization": user.token,
        },
      );
      return response.body['cards'];
    } catch (e) {
      throw Exception('Failed to load card data');
    }
  }


}

class _SelectSkinsState extends State<SelectSkinsScreen> {
  bool isAvatarListEmpty = true;

  @override
  void initState() {
    super.initState();
    _checkAvatarList();
  }

  Future<void> _checkAvatarList() async {
    try {
      final avatarsResponse = await widget._getAllAvatars();
      setState(() {
        isAvatarListEmpty = avatarsResponse.isEmpty;
      });
    } catch (e) {
      print('Error al cargar la lista de avatares: $e');
    }
  }

  Future<void> _changeItem(String item, String itemName) async {
    try {
      String itemAux = item.toLowerCase();
      String url = '${EnlaceApp.enlaceBase}/api/user/change$item';
      final getConnect = GetConnect();
      final response = await getConnect.put(
        url,
        {"${itemAux}Name": itemName},
        headers: {
          "Authorization": widget.user.token,
        },
      );
      // Después de cambiar el elemento, actualiza la pantalla
      _checkAvatarList();
    } catch (e) {
      throw Exception('Failed to buy item');
    }
  }

  Widget _buildRoundedImage(String imageUrl, double width, double height) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget mostrarCategoria(
      String title, Future<List<dynamic>> Function() fetchDataFunction) {
    String itemCambio = "";
    if (title == "Avatares") {
      itemCambio = "Avatar";
    } else if (title == "Tapetes") {
      itemCambio = "Rug";
    } else if (title == "Cartas") {
      itemCambio = "Card";
    }
    return Column(
      children: [
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            width: 150,
            decoration: BoxDecoration(
              color: ColoresApp.segundoColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        FutureBuilder<List<dynamic>>(
          future: fetchDataFunction(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final itemList = snapshot.data!;
              if (itemList.isEmpty) {
                return const Center(child: Text('No hay elementos disponibles'));
              } else {
                return SizedBox(
                  height: 80,
                  width: MediaQuery.of(context).size.width - 100,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: itemList.length,
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        width: 20.0,
                        child: VerticalDivider(
                          color: Colors.white,
                          thickness: 5,
                          indent: 10,
                          endIndent: 10,
                        ),
                      );
                    },
                    itemBuilder: (context, index) {String urlImagen =
                          "${EnlaceApp.enlaceBase}/images/" +
                              itemList[index]['imageFileName'];
                      return GestureDetector(
                        onTap: () {
                          _changeItem(itemCambio, itemList[index]['image']);
                        },
                        child: Stack(
                          children: [
                            _buildRoundedImages(
                              urlImagen,
                              80,
                              80,
                              itemCambio,
                              itemList[index]['image'],
                            ),
                            if (itemList[index]['current'] == true)
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
                          ],
                        ),
                      );
                    },
                  ),
                );
              }
            }
          },
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  GestureDetector _buildRoundedImages(String imageUrl, double width, double height, String itemCambio, String nombreImagen) {
    double c = 0.0;
    if(itemCambio == "Avatar") {
      c = 50.0;
    }
    else if(itemCambio == "Card"){
      c = 12.0;
    }
    else if(itemCambio == "Rug"){
      c = 12.0;
    }
    return GestureDetector(
      onTap: () {
        // Acción a realizar al hacer clic en la imagen
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(c),
        child: Material(
          color: Colors.transparent,
          child: Ink.image(
            image: NetworkImage(imageUrl),
            width: width,
            height: height,
            fit: BoxFit.cover,
            child: InkWell(
              onTap: () {
                _changeItem(itemCambio, nombreImagen);
              },
              splashColor: Colors.white.withOpacity(0.5), // Color del efecto de salpicadura
              highlightColor: Colors.transparent, // Color del efecto de resaltado
              borderRadius: BorderRadius.circular(12.0), // Radio de borde
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async  {
          actualizarUsuario(context, widget.getConnect, widget.user);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Principal(widget.user)),
          );
          return true;
        },
        child: Scaffold(
          backgroundColor: ColoresApp.fondoPantallaColor,
          appBar: AppBar(
            backgroundColor: ColoresApp.cabeceraColor,
            elevation: 2,
            leading: GestureDetector(
              onTap: () {
                actualizarUsuario(context, widget.getConnect, widget.user);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Principal(widget.user)),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/logo.png', // Ruta de la imagen
                  width: 50, // Ancho de la imagen
                  height: 50, // Altura de la imagen
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      mostrarCategoria('Tapetes', widget._getAllRugs),
                      mostrarCategoria('Cartas', widget._getAllCards),
                      mostrarCategoria('Avatares', widget._getAllAvatars),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: SelectSkinsScreen(
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
