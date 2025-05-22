class Inventario {
  final int idInventario;
  final int idProducto;
  final int idAlmacen;
  final int idTalla;
  final int cantidad;
  final int cantidadDisponible;
  final int cantidadNoDisponible;
  final int reservado;
  final int enBodega;
  final DateTime fechaUltimaMovimiento;

  Inventario({
    required this.idInventario,
    required this.idProducto,
    required this.idAlmacen,
    required this.idTalla,
    required this.cantidad,
    required this.cantidadDisponible,
    required this.cantidadNoDisponible,
    required this.reservado,
    required this.enBodega,
    required this.fechaUltimaMovimiento,
  });

  factory Inventario.fromJson(Map<String, dynamic> json) {
    return Inventario(
      idInventario: json['idInventario'],
      idProducto: json['idProducto'],
      idAlmacen: json['idAlmacen'],
      idTalla: json['idTalla'],
      cantidad: json['cantidad'],
      cantidadDisponible: json['cantidadDisponible'],
      cantidadNoDisponible: json['cantidadNoDisponible'],
      reservado: json['reservado'],
      enBodega: json['enBodega'],
      fechaUltimaMovimiento: DateTime.parse(json['fechaUltimaMovimiento']),
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
      'fechaUltimaMovimiento': fechaUltimaMovimiento.toIso8601String(),
    };
  }
}
