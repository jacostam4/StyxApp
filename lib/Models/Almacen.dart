class Almacen {
  final int idAlmacen;
  final String nombre;
  final String ubicacion;

  Almacen({
    required this.idAlmacen,
    required this.nombre,
    required this.ubicacion,
  });

  factory Almacen.fromJson(Map<String, dynamic> json) {
    return Almacen(
      idAlmacen: json['idAlmacen'],
      nombre: json['nombre'],
      ubicacion: json['ubicacion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'idAlmacen': idAlmacen, 'nombre': nombre, 'ubicacion': ubicacion};
  }
}
