import 'package:flutter/material.dart';
import 'package:styx_app/Models/Product.dart';

class RegistrarProductoPage extends StatefulWidget {
  const RegistrarProductoPage({Key? key}) : super(key: key);

  @override
  State<RegistrarProductoPage> createState() => _RegistrarProductoPageState();
}

class _RegistrarProductoPageState extends State<RegistrarProductoPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idCategoriaController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _costoController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final TextEditingController _referenciaController = TextEditingController();

  void _guardarProducto() {
    if (_formKey.currentState!.validate()) {
      final producto = Product(
        idProducto: 0, // temporal, el backend lo asigna
        idCategoria: int.parse(_idCategoriaController.text),
        nombre: _nombreController.text,
        costo: double.parse(_costoController.text),
        precio: double.parse(_precioController.text),
        referencia: _referenciaController.text,
      );

      // Aquí puedes guardar/enviar el producto al backend
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Producto guardado')));

      // Opcional: Navegar hacia atrás o limpiar campos
      // Navigator.pop(context);
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Producto'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _idCategoriaController,
                decoration: _inputDecoration('ID Categoría'),
                keyboardType: TextInputType.number,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Ingrese el ID de la categoría'
                            : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nombreController,
                decoration: _inputDecoration('Nombre'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Ingrese el nombre'
                            : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _costoController,
                decoration: _inputDecoration('Costo'),
                keyboardType: TextInputType.number,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Ingrese el costo'
                            : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _precioController,
                decoration: _inputDecoration('Precio'),
                keyboardType: TextInputType.number,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Ingrese el precio'
                            : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _referenciaController,
                decoration: _inputDecoration('Referencia'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Ingrese la referencia'
                            : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _guardarProducto,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Guardar',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
