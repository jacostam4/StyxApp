class Product {
  final int idProducto;
  final int idCategoria;
  final String nombre;
  final double costo;
  final double precio;
  final String referencia;

  Product({
    required this.idProducto,
    required this.idCategoria,
    required this.nombre,
    required this.costo,
    required this.precio,
    required this.referencia,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      idProducto: json['id_producto'],
      idCategoria: json['id_categoria'],
      nombre: json['nombre'],
      costo: (json['costo'] as num).toDouble(),
      precio: (json['precio'] as num).toDouble(),
      referencia: json['referencia'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_producto': idProducto,
      'id_categoria': idCategoria,
      'nombre': nombre,
      'costo': costo,
      'precio': precio,
      'referencia': referencia,
    };
  }
}
