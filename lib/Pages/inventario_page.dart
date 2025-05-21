import 'package:flutter/material.dart';

class InventarioPage extends StatelessWidget {
  const InventarioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventario'),
        backgroundColor: Colors.black,
      ),
      body: const Center(child: Text('Aquí irá el inventario de productos')),
    );
  }
}
