import 'package:flutter/material.dart';
import 'package:styx_app/Services/ProductoService.dart';
import 'package:styx_app/Utils/token_storage.dart';
import 'package:styx_app/Widgets/StyxAppBar.dart';
import '../models/inventario.dart';
import '../Services/InventarioService.dart';
import '../Services/TallaService.dart';
import '../Services/AlmacenService.dart';

class InventarioPage extends StatefulWidget {
  const InventarioPage({super.key});

  @override
  State<InventarioPage> createState() => _InventarioPageState();
}

class _InventarioPageState extends State<InventarioPage> {
  String? rolUsuario;

  bool _addingNewRow = false;
  int? _selectedProducto;
  int? _selectedAlmacen;
  int? _selectedTalla;
  final TextEditingController _cantidadController = TextEditingController();

  late Future<Map<String, dynamic>> _futureData;

  @override
  void initState() {
    super.initState();
    _cargarRolUsuario();
    _futureData = _fetchData();
  }

  Future<void> _cargarRolUsuario() async {
    final rol = await TokenStorage.getRol();
    setState(() {
      rolUsuario = rol;
    });
  }

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
    if (rolUsuario == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: StyxAppBar(
        rolUsuario: rolUsuario,
        currentRoute: 'InventarioPage',
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _futureData,
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

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
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
                      DataColumn(label: Text('Acciones')),
                    ],
                    rows: [
                      ...inventarios.map((inv) {
                        final tallaNombre = tallaMap[inv.idTalla] ?? 'N/A';
                        final almacenNombre =
                            almacenMap[inv.idAlmacen] ?? 'N/A';
                        final productoNombre =
                            productoMap[inv.idProducto] ?? 'N/A';

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
                            const DataCell(SizedBox()),
                          ],
                        );
                      }),
                      if (_addingNewRow)
                        DataRow(
                          cells: [
                            const DataCell(Text('Nuevo')),
                            DataCell(
                              DropdownButtonFormField<int>(
                                value: _selectedProducto,
                                items:
                                    productoMap.entries
                                        .map(
                                          (e) => DropdownMenuItem(
                                            value: e.key,
                                            child: Text(e.value),
                                          ),
                                        )
                                        .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedProducto = value;
                                  });
                                },
                              ),
                            ),
                            DataCell(
                              DropdownButtonFormField<int>(
                                value: _selectedAlmacen,
                                items:
                                    almacenMap.entries
                                        .map(
                                          (e) => DropdownMenuItem(
                                            value: e.key,
                                            child: Text(e.value),
                                          ),
                                        )
                                        .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedAlmacen = value;
                                  });
                                },
                              ),
                            ),
                            DataCell(
                              DropdownButtonFormField<int>(
                                value: _selectedTalla,
                                items:
                                    tallaMap.entries
                                        .map(
                                          (e) => DropdownMenuItem(
                                            value: e.key,
                                            child: Text(e.value),
                                          ),
                                        )
                                        .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedTalla = value;
                                  });
                                },
                              ),
                            ),
                            DataCell(
                              TextField(
                                controller: _cantidadController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  hintText: 'Cantidad',
                                ),
                              ),
                            ),
                            const DataCell(Text('-')),
                            const DataCell(Text('-')),
                            const DataCell(Text('-')),
                            const DataCell(Text('-')),
                            const DataCell(Text('-')),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    ),
                                    onPressed: () async {
                                      if (_selectedProducto != null &&
                                          _selectedAlmacen != null &&
                                          _selectedTalla != null &&
                                          _cantidadController.text.isNotEmpty) {
                                        try {
                                          final nuevoInventario = Inventario(
                                            idInventario: 0,
                                            idProducto: _selectedProducto!,
                                            idAlmacen: _selectedAlmacen!,
                                            idTalla: _selectedTalla!,
                                            cantidad: int.parse(
                                              _cantidadController.text,
                                            ),
                                            cantidadDisponible: 0,
                                            cantidadNoDisponible: 0,
                                            reservado: 0,
                                            enBodega: 0,
                                            fechaUltimaMovimiento:
                                                DateTime.now(),
                                          );

                                          await InventarioService()
                                              .registerInventario(
                                                nuevoInventario,
                                              );

                                          setState(() {
                                            _addingNewRow = false;
                                            _cantidadController.clear();
                                            _futureData =
                                                _fetchData(); // Refrescar la tabla
                                          });
                                        } catch (e) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Error al registrar: $e',
                                              ),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _addingNewRow = false;
                                        _cantidadController.clear();
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              if (!_addingNewRow)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _addingNewRow = true;
                        _selectedProducto = null;
                        _selectedAlmacen = null;
                        _selectedTalla = null;
                        _cantidadController.clear();
                      });
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Agregar Inventario'),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
