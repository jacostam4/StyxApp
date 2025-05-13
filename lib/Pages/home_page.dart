import 'package:flutter/material.dart';
import '../Models/Product.dart';
import '../Services/ProductoService.dart';
import '../Utils/token_storage.dart'; // <-- Asegúrate de importar esto

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Product>> _futureProducts;
  String? rolUsuario; // <-- Nuevo: para guardar el rol

  @override
  void initState() {
    super.initState();
    _futureProducts = ProductoService.fetchAllProducts();

    // Obtener el rol del usuario desde el token decodificado
    TokenStorage.getRol().then((rol) {
      setState(() {
        rolUsuario = rol;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Styx'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
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
          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (context, index) {
              final producto = productos[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(producto.nombre),
                  subtitle: Text(producto.referencia),
                  trailing: Text('\$${producto.precio.toStringAsFixed(2)}'),
                ),
              );
            },
          );
        },
      ),

      // Mostrar botón solo si el usuario es admin
      floatingActionButton:
          rolUsuario == '1'
              ? FloatingActionButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/crear-producto');
                },
                backgroundColor: Colors.black, // fondo negro
                child: const Icon(
                  Icons.add,
                  color: Colors.white, // ícono blanco
                ),
              )
              : null,
    );
  }
}
