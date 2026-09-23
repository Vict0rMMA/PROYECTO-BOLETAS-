class Boleta {
  final int id;
  final String evento;
  final String asiento;
  final double precio;
  final bool vendida;
  final String imagenPath;
  final String synopsis;

  const Boleta({
    required this.id,
    required this.evento,
    required this.asiento,
    required this.precio,
    required this.vendida,
    required this.imagenPath,
    required this.synopsis,
  });

  factory Boleta.fromJson(Map<String, dynamic> json) {
    return Boleta(
      id: json['id'],
      evento: json['evento'],
      asiento: json['asiento'],
      precio: (json['precio'] as num).toDouble(),
      vendida: json['vendida'] ?? false,
      imagenPath: json['imagen_path'],
      synopsis: json['synopsis'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'evento': evento,
      'asiento': asiento,
      'precio': precio,
      'vendida': vendida,
      'imagen_path': imagenPath,
      'synopsis': synopsis,
    };
  }
}
