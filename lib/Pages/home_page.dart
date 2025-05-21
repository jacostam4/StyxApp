import 'package:flutter/material.dart';
import '../Models/Product.dart';
import '../Models/ProductoImagen.dart';
import '../Services/ProductoService.dart';
import '../Services/ProductoImagenService.dart';
import '../Utils/token_storage.dart';
import '../Pages/registrar_producto.dart';
import '../Pages/detalle_producto_page.dart';
import '../Pages/login_page.dart';
import '../Widgets/StyxAppBar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Product>> _futureProducts;
  String? rolUsuario;

  @override
  void initState() {
    super.initState();
    _verificarAutenticacion();

    // Cargar productos
    _futureProducts = ProductoService.fetchAllProducts();

    // Obtener el rol del usuario
    TokenStorage.getRol().then((rol) {
      setState(() {
        rolUsuario = rol;
      });
    });
  }

  void _verificarAutenticacion() async {
    final token = await TokenStorage.getToken();
    if (token == null) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const currentRoute = 'HomePage';
    final isAdmin = rolUsuario == '1';

    return Scaffold(
      appBar: StyxAppBar(rolUsuario: rolUsuario, currentRoute: currentRoute),
      drawer:
          isAdmin
              ? Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    const DrawerHeader(
                      decoration: BoxDecoration(color: Colors.black),
                      child: Text(
                        'Menú administrador',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.inventory),
                      title: const Text('Registrar producto'),
                      onTap: () {
                        Navigator.pop(context); // cerrar drawer
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegistrarProductoPage(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text('Cerrar sesión'),
                      onTap: () async {
                        await TokenStorage.deleteToken(); // borrar token
                        if (!mounted) return;
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                          (route) => false,
                        );
                      },
                    ),
                  ],
                ),
              )
              : null,
      body: FutureBuilder<List<Product>>(
        future: _futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay productos disponibles'));
          }

          final productos = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: GridView.builder(
              itemCount: productos.length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 250,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.7,
              ),
              itemBuilder: (context, index) {
                final producto = productos[index];
                return FutureBuilder<List<ProductoImagen>>(
                  future: ProductoImagenService.fetchImagenesPorProducto(
                    producto.idProducto,
                  ),
                  builder: (context, imageSnapshot) {
                    if (imageSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (imageSnapshot.hasError) {
                      return Center(
                        child: Text('Error: ${imageSnapshot.error}'),
                      );
                    }

                    final imagenUrl =
                        imageSnapshot.data?.isNotEmpty == true
                            ? imageSnapshot.data![0].urlImagen
                            : null;

                    return _buildProductCard(producto, imagenUrl);
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton:
          isAdmin
              ? FloatingActionButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegistrarProductoPage(),
                    ),
                  );
                },
                backgroundColor: Colors.black,
                child: const Icon(Icons.add, color: Colors.white),
              )
              : null,
    );
  }

  Widget _buildProductCard(Product producto, String? imagenUrl) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) =>
                    DetalleProductoPage(idProducto: producto.idProducto),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child:
                    imagenUrl != null && imagenUrl.isNotEmpty
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(imagenUrl, fit: BoxFit.cover),
                        )
                        : const Icon(Icons.image, size: 50, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              Text(
                producto.nombre,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                producto.referencia,
                style: const TextStyle(color: Colors.grey),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                '\$${producto.precio.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
