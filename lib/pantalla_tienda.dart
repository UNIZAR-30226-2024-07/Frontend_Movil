import 'package:flutter/material.dart';
import 'package:get/get_connect/connect.dart';
import 'package:psoft_07/Usuario.dart';
//import 'package:psoft_07/funcionesAvatar.dart';
import 'colores.dart';

class ShopScreen extends StatefulWidget {
  //final FuncionesAvatar fAvatar = FuncionesAvatar();
  final User user;

  ShopScreen(this.user, {super.key});

  @override
  _ShopScreenState createState() => _ShopScreenState();

  Future<List<dynamic>> _getAllAvatars() async {
    try {
      final getConnect = GetConnect();
      final response = await getConnect.get(
        '${EnlaceApp.enlaceBase}/api/avatar/getAllAvatars',
        headers: {
          "Authorization": user.token,
        },
      );
      return response.body['avatar'];
    } catch (e) {
      throw Exception('Failed to load user data');
    }
  }

  Future<List<dynamic>> _getAllRugs() async {
    try {
      final getConnect = GetConnect();
      final response = await getConnect.get(
        '${EnlaceApp.enlaceBase}/api/rug/getAllRugs',
        headers: {
          "Authorization": user.token,
        },
      );
      return response.body['rug'];
    } catch (e) {
      throw Exception('Failed to load user data');
    }
  }

  Future<List<dynamic>> _getAllCards() async {
    try {
      final getConnect = GetConnect();
      final response = await getConnect.get(
        '${EnlaceApp.enlaceBase}/api/card/getAllCards',
        headers: {
          "Authorization": user.token,
        },
      );
      return response.body['card']; // Cambiar a 'card' en lugar de 'avatar'
    } catch (e) {
      throw Exception('Failed to load user data');
    }
  }

}

class _ShopScreenState extends State<ShopScreen> {
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

  Future<void> _buyItem(String item, String itemName) async {
    try {
      String url = '${EnlaceApp.enlaceBase}/api/user/buy$item';
      final getConnect = GetConnect();
      final response = await getConnect.put(
        url,
        {"avatarName": itemName},
        headers: {
          "Authorization": widget.user.token,
        },
      );

      // Aquí puedes actualizar cualquier estado necesario
      // Llama a Navigator.pushReplacement para recargar la página
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ShopScreen(widget.user),
        ),
      );

    } catch (e) {
      throw Exception('Failed to buy item');
    }
  }

  bool isAvatarListEmpty = true; // Variable para almacenar si la lista de avatares está vacía o no

  @override
  void initState() {
    super.initState();
    // Llamar a la función _getAllAvatars al inicializar el estado
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

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text('Ha ocurrido un error al procesar la compra.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  void _showConfirmationDialog(dynamic card, String item, String urlImagen) {
    String itemName = card['image'];
    int itemPrice = card['price'];

    final scaffoldMessenger = ScaffoldMessenger.of(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar compra', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          backgroundColor: ColoresApp.segundoColor,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 100, // Ancho de la imagen
                    height: 100, // Alto de la imagen
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50), // Redondear esquinas
                      image: DecorationImage(
                        image: NetworkImage(urlImagen), // URL de la imagen
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20), // Espacio entre la imagen y el texto
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('¿Deseas comprar $itemName?', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(
                            Icons.monetization_on,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 5),
                          Text('\$ $itemPrice', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20), // Espacio entre la imagen y los botones
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () async {
                        if (widget.user.coins >= itemPrice) {
                          // Procesa la compra
                          Navigator.of(context).pop();
                          try {
                            await _buyItem(item, itemName);
                            // Mostrar mensaje de compra realizada
                            scaffoldMessenger.showSnackBar(
                              SnackBar(
                                content: Text('La compra de $itemName ha sido realizada.'),
                              ),
                            );
                            // Aquí puedes agregar código adicional después de la compra
                          } catch (e) {
                            // Maneja cualquier error que pueda ocurrir durante la compra
                            print('Error al comprar el artículo: $e');
                            // Muestra un mensaje de error
                            _showErrorDialog();
                          }
                        } else {
                          // Si el usuario no tiene suficientes monedas, muestra un mensaje
                          Navigator.of(context).pop();
                          _showInsufficientFundsDialog();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.green, // Color de fondo del botón
                          borderRadius: BorderRadius.circular(20), // Redondear esquinas
                        ),
                        child: const Text('Sí', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10), // Espacio entre los botones
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.red[800], // Color de fondo del botón
                          borderRadius: BorderRadius.circular(20), // Redondear esquinas
                        ),
                        child: const Text('No', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }


  void _showInsufficientFundsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Fondos insuficientes'),
          content: const Text('No tienes suficientes monedas para comprar este artículo.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }



  Widget mostrarCategoria(String title, Future<List<dynamic>> Function() fetchDataFunction) {
    return Column(
      children: [
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            width: 150, // Anchura del contenedor
            decoration: BoxDecoration(
              color: ColoresApp.segundoColor, // Color de fondo
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              title,
              textAlign: TextAlign.center, // Centra el texto horizontalmente
              style: const TextStyle(
                fontSize: 16, // Tamaño del texto
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
                  width: MediaQuery.of(context).size.width - 100, // Ajusta el ancho según sea necesario
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: itemList.length,
                    separatorBuilder: (context, index) {
                      return const SizedBox(width: 20.0, child: VerticalDivider(color: Colors.white, thickness: 5, indent: 10, endIndent: 10,));
                    },
                    itemBuilder: (context, index) {
                      String urlImagen = "https://backend-uf65.onrender.com/images/" + itemList[index]['imageFileName'];
                      return GestureDetector(
                        onTap: () {
                          _showConfirmationDialog(itemList[index], title, urlImagen);
                        },
                        child: _buildRoundedImage(
                          urlImagen,
                          80,
                          80,
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
          width: double.infinity, // Ancho total del contenedor
          height: 4, // Altura del separador
          decoration: BoxDecoration(
            color: Colors.white, // Color del separador
            borderRadius: BorderRadius.circular(2), // Borde redondeado
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
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
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              width: 100,
              height: 40,
              decoration: BoxDecoration(
                color: ColoresApp.segundoColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.monetization_on,
                      color: Colors.red,
                      size: 20,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      widget.user.coins.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}

void main() {
  runApp(MaterialApp(
    home: ShopScreen(
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
