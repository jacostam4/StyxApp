class Inventario {
  final int idInventario;
  final int idProducto;
  final int? idAlmacen; // <- permite null
  final int? idTalla; // <- permite null
  final int cantidad;
  final int cantidadDisponible;
  final int cantidadNoDisponible;
  final int reservado;
  final int enBodega;
  final DateTime? fechaUltimaMovimiento; // <- permite null

  Inventario({
    required this.idInventario,
    required this.idProducto,
    this.idAlmacen,
    this.idTalla,
    required this.cantidad,
    required this.cantidadDisponible,
    required this.cantidadNoDisponible,
    required this.reservado,
    required this.enBodega,
    this.fechaUltimaMovimiento,
  });

  factory Inventario.fromJson(Map<String, dynamic> json) {
    return Inventario(
      idInventario: json['idInventario'],
      idProducto: json['idProducto'],
      idAlmacen: json['idAlmacen'], // puede ser null
      idTalla: json['idTalla'], // puede ser null
      cantidad: json['cantidad'],
      cantidadDisponible: json['cantidadDisponible'],
      cantidadNoDisponible: json['cantidadNoDisponible'],
      reservado: json['reservado'],
      enBodega: json['enBodega'],
      fechaUltimaMovimiento:
          json['fechaUltimaMovimiento'] != null
              ? DateTime.parse(json['fechaUltimaMovimiento'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idInventario': idInventario,
      'idProducto': idProducto,
      'idAlmacen': idAlmacen,
      'idTalla': idTalla,
      'cantidad': cantidad,
      'cantidadDisponible': cantidadDisponible,
      'cantidadNoDisponible': cantidadNoDisponible,
      'reservado': reservado,
      'enBodega': enBodega,
      'fechaUltimaMovimiento':
          fechaUltimaMovimiento?.toIso8601String(), // usa null safety
    };
  }
}
