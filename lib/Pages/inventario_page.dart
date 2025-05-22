import 'package:flutter/material.dart';
import 'package:styx_app/Services/ProductoService.dart';
import '../models/inventario.dart';
import '../Services/InventarioService.dart';
import '../Services/TallaService.dart';
import '../Services/AlmacenService.dart';

class InventarioPage extends StatelessWidget {
  const InventarioPage({super.key});

  Future<Map<String, dynamic>> _fetchData() async {
    final inventarios = await InventarioService().getAllInventarios();
    final tallas = await Tallaservice.fetchAllTallas();
    final almacenes = await Almacenservice.getAlmacenes();
    final productos = await ProductoService.fetchAllProducts();

    final tallaMap = {for (var talla in tallas) talla.idTalla: talla.nombre};
    final almacenMap = {for (var alm in almacenes) alm.idAlmacen: alm.nombre};
    final productoMap = {
      for (var prod in productos) prod.idProducto: prod.nombre,
    };

    return {
      'inventarios': inventarios,
      'tallaMap': tallaMap,
      'almacenMap': almacenMap,
      'productoMap': productoMap,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventario'),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error inventario: ${snapshot.error}'));
          } else if (!snapshot.hasData ||
              snapshot.data!['inventarios'].isEmpty) {
            return const Center(child: Text('No hay inventario disponible'));
          }

          final inventarios = snapshot.data!['inventarios'] as List<Inventario>;
          final tallaMap = snapshot.data!['tallaMap'] as Map<int, String>;
          final almacenMap = snapshot.data!['almacenMap'] as Map<int, String>;
          final productoMap = snapshot.data!['productoMap'] as Map<int, String>;
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
                    final tallaNombre = tallaMap[inv.idTalla] ?? 'N/A';
                    final almacenNombre = almacenMap[inv.idAlmacen] ?? 'N/A';
                    final productoNombre = productoMap[inv.idProducto] ?? 'N/A';

                    return DataRow(
                      cells: [
                        DataCell(Text(inv.idInventario.toString())),
                        DataCell(Text(productoNombre)),
                        DataCell(Text(almacenNombre)),
                        DataCell(Text(tallaNombre)),
                        DataCell(Text(inv.cantidad.toString())),
                        DataCell(Text(inv.cantidadDisponible.toString())),
                        DataCell(Text(inv.cantidadNoDisponible.toString())),
                        DataCell(Text(inv.reservado.toString())),
                        DataCell(Text(inv.enBodega.toString())),
                        DataCell(
                          Text(
                            inv.fechaUltimaMovimiento
                                .toString()
                                .split('T')
                                .first,
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
