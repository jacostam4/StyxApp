import 'package:flutter/material.dart';
import 'package:styx_app/Pages/login_page.dart';
import '../Services/RegisterService.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _numeroDocController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();
  String _tipoDoc = 'CC';

  Future<void> _registerUser() async {
    final error = await RegisterService.registerUser(
      nombre: _nombreController.text,
      correo: _correoController.text,
      telefono: _telefonoController.text,
      tipoDoc: _tipoDoc,
      numeroDoc: _numeroDocController.text,
      direccion: _direccionController.text,
      contrasena: _contrasenaController.text,
    );

    if (error == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Registro exitoso')));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro - Styx'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: _nombreController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre completo',
                        border: OutlineInputBorder(),
                      ),
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Por favor ingrese su nombre'
                                  : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _correoController,
                      decoration: const InputDecoration(
                        labelText: 'Correo electrónico',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese su correo';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Ingrese un correo válido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _telefonoController,
                      decoration: const InputDecoration(
                        labelText: 'Teléfono',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Por favor ingrese su teléfono'
                                  : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _tipoDoc.isNotEmpty ? _tipoDoc : null,
                      decoration: const InputDecoration(
                        labelText: 'Tipo de documento',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'CC',
                          child: Text('Cédula de ciudadanía (CC)'),
                        ),
                        DropdownMenuItem(
                          value: 'CE',
                          child: Text('Cédula de extranjería (CE)'),
                        ),
                        DropdownMenuItem(
                          value: 'Pasaporte',
                          child: Text('Pasaporte'),
                        ),
                        DropdownMenuItem(
                          value: 'PxP',
                          child: Text('Permiso por Protección (PxP)'),
                        ),
                      ],
                      hint: const Text('Seleccione tipo de documento'),
                      isExpanded: true,
                      onChanged: (value) {
                        setState(() {
                          _tipoDoc = value!;
                        });
                      },
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Por favor seleccione un tipo de documento'
                                  : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _numeroDocController,
                      decoration: const InputDecoration(
                        labelText: 'Número de documento',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Por favor ingrese su número de documento'
                                  : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _direccionController,
                      decoration: const InputDecoration(
                        labelText: 'Dirección',
                        border: OutlineInputBorder(),
                      ),
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Por favor ingrese su dirección'
                                  : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _contrasenaController,
                      decoration: const InputDecoration(
                        labelText: 'Contraseña',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese su contraseña';
                        }
                        if (value.length < 6) {
                          return 'La contraseña debe tener al menos 6 caracteres';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _registerUser();
                        }
                      },
                      icon: const Icon(Icons.person_add),
                      label: const Text('Registrar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
