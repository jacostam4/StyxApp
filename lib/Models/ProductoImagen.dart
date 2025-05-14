class ProductoImagen {
  final int idImagen;
  final int idProducto;
  final String urlImagen;
  final int? orden; // Si `orden` puede ser nulo

  ProductoImagen({
    required this.idImagen,
    required this.idProducto,
    required this.urlImagen,
    this.orden,
  });

  factory ProductoImagen.fromJson(Map<String, dynamic> json) {
    return ProductoImagen(
      idImagen: json['idImagen'],
      idProducto: json['idProducto'],
      urlImagen: json['urlImagen'],
      orden: json['orden'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idImagen': idImagen,
      'idProducto': idProducto,
      'urlImagen': urlImagen,
      'orden': orden,
    };
  }
}
