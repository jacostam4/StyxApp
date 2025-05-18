import 'package:flutter/material.dart';


import 'package:styx_app/Utils/token_storage.dart';

import '../Models/Product.dart';
import '../Models/ProductoImagen.dart';
import '../Services/ProductoService.dart';
import '../Services/ProductoImagenService.dart';
import '../Pages/editar_producto_page.dart';

class DetalleProductoPage extends StatefulWidget {

class DetalleProductoPage extends StatelessWidget {
  final int idProducto;

  const DetalleProductoPage({super.key, required this.idProducto});

  @override
  State<DetalleProductoPage> createState() => _DetalleProductoPageState();
}

class _DetalleProductoPageState extends State<DetalleProductoPage> {
  String? rolUsuario;

  @override
  void initState() {
    super.initState();
    _cargarRolUsuario();
  }

  Future<void> _cargarRolUsuario() async {
    final rol = await TokenStorage.getRol();
    setState(() {
      rolUsuario = rol;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Detalle del Producto'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<Product>(

        future: ProductoService.fetchProductoById(widget.idProducto),
        builder: (context, productoSnapshot) {
          if (productoSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (productoSnapshot.hasError) {
            return Center(child: Text('Error: ${productoSnapshot.error}'));
          }

          if (!productoSnapshot.hasData) {
            return const Center(child: Text('Producto no encontrado'));
          }

          final producto = productoSnapshot.data!;

          return FutureBuilder<List<ProductoImagen>>(
            future: ProductoImagenService.fetchImagenesPorProducto(
              widget.idProducto,
            ),
            builder: (context, imagenSnapshot) {
              final imagenUrl =
                  (imagenSnapshot.hasData && imagenSnapshot.data!.isNotEmpty)
                      ? imagenSnapshot.data!.first.urlImagen
        future: ProductoService.fetchProductoById(idProducto),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Producto no encontrado'));
          }

          final producto = snapshot.data!;

          return FutureBuilder<List<ProductoImagen>>(
            future: ProductoImagenService.fetchImagenesPorProducto(idProducto),
            builder: (context, imageSnapshot) {
              final imagenUrl =
                  (imageSnapshot.hasData && imageSnapshot.data!.isNotEmpty)
                      ? imageSnapshot.data!.first.urlImagen
                      : null;

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                          child: Container(
                            width: double.infinity,

                            height: 200, // Más pequeño que antes
                            color: Colors.grey[200],
                            child:
                                imagenUrl != null
                                    ? Image.network(
                                      imagenUrl,
                                      fit: BoxFit.contain,
                                      fit:
                                          BoxFit
                                              .contain, // Mostrar la imagen completa sin recortes
                                    )
                                    : const Center(
                                      child: Icon(
                                        Icons.image,
                                        size: 100,
                                        color: Colors.grey,
                                      ),
                                    ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                producto.nombre,
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Referencia: ${producto.referencia}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                '\$${producto.precio.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Botón visible solo para administradores (rol 1)
                              if (rolUsuario == "1")
                                Center(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => EditarProductoPage(
                                                producto: producto,
                                              ),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.edit),
                                    label: const Text("Editar Producto"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
