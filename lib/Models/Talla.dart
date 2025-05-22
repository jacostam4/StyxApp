class Talla {
  final int idTalla;
  final String nombre;

  Talla({required this.idTalla, required this.nombre});

  factory Talla.fromJson(Map<String, dynamic> json) {
    return Talla(idTalla: json['idTalla'], nombre: json['nombre']);
  }

  Map<String, dynamic> toJson() {
    return {'idTalla': idTalla, 'nombre': nombre};
  }
}
