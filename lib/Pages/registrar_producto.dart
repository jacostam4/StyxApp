import 'package:flutter/material.dart';
import 'package:styx_app/Models/Product.dart';
import 'package:styx_app/Models/Categoria.dart';
import 'package:styx_app/Pages/home_page.dart';
import 'package:styx_app/Services/CategoriaService.dart';
import 'package:styx_app/Services/ProductoService.dart';

class RegistrarProductoPage extends StatefulWidget {
  const RegistrarProductoPage({Key? key}) : super(key: key);

  @override
  State<RegistrarProductoPage> createState() => _RegistrarProductoPageState();
}

class _RegistrarProductoPageState extends State<RegistrarProductoPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _costoController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final TextEditingController _referenciaController = TextEditingController();

  List<Categoria> _categorias = [];
  Categoria? _categoriaSeleccionada;
  bool _isLoadingCategorias = true;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _fetchCategorias();
  }

  Future<void> _fetchCategorias() async {
    try {
      final categorias = await CategoriaService().getCategorias();
      setState(() {
        _categorias = categorias;
        _isLoadingCategorias = false;
      });
    } catch (e) {
      setState(() => _isLoadingCategorias = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _guardarProducto() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final producto = Product(
      idProducto: 0,
      idCategoria: _categoriaSeleccionada!.id,
      nombre: _nombreController.text,
      costo: double.parse(_costoController.text),
      precio: double.parse(_precioController.text),
      referencia: _referenciaController.text,
    );

    try {
      await ProductoService.crearProducto(producto);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Producto guardado con éxito')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al guardar: $e')));
    } finally {
      setState(() => _isSubmitting = false);
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
              _isLoadingCategorias
                  ? const CircularProgressIndicator()
                  : DropdownButtonFormField<Categoria>(
                    value: _categoriaSeleccionada,
                    items:
                        _categorias.map((cat) {
                          return DropdownMenuItem<Categoria>(
                            value: cat,
                            child: Text(cat.nombre),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _categoriaSeleccionada = value;
                      });
                    },
                    decoration: _inputDecoration('Categoría'),
                    validator:
                        (value) =>
                            value == null ? 'Seleccione una categoría' : null,
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
                  onPressed: _isSubmitting ? null : _guardarProducto,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child:
                      _isSubmitting
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
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
