import 'package:flutter/material.dart';
import '../models/inventario.dart';
import '../services/InventarioService.dart';

class InventarioPage extends StatelessWidget {
  const InventarioPage({super.key});

  Future<List<Inventario>> _fetchInventario() async {
    final inventarioService = InventarioService();
    return await inventarioService.getAllInventarios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventario'),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<List<Inventario>>(
        future: _fetchInventario(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay inventario disponible'));
          }

          final inventarios = snapshot.data!;

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('ID')),
                DataColumn(label: Text('Producto')),
                DataColumn(label: Text('Almacén')),
                DataColumn(label: Text('Talla')),
                DataColumn(label: Text('Cantidad')),
                DataColumn(label: Text('Disponible')),
                DataColumn(label: Text('No Disponible')),
                DataColumn(label: Text('Reservado')),
                DataColumn(label: Text('Bodega')),
                DataColumn(label: Text('Último Movimiento')),
              ],
              rows:
                  inventarios.map((inv) {
                    return DataRow(
                      cells: [
                        DataCell(Text(inv.idInventario.toString())),
                        DataCell(Text(inv.idProducto.toString())),
                        DataCell(Text(inv.idAlmacen.toString())),
                        DataCell(Text(inv.idTalla.toString())),
                        DataCell(Text(inv.cantidad.toString())),
                        DataCell(Text(inv.cantidadDisponible.toString())),
                        DataCell(Text(inv.cantidadNoDisponible.toString())),
                        DataCell(Text(inv.reservado.toString())),
                        DataCell(Text(inv.enBodega.toString())),
                        DataCell(
                          Text(
                            inv.fechaUltimaMovimiento
                                    ?.toString()
                                    .split('T')
                                    .first ??
                                '',
                          ),
                        ),
                      ],
                    );
                  }).toList(),
            ),
          );
        },
      ),
    );
  }
}
