class Producto {
  final String nombre;
  final double precio;
  final String unidad;

  Producto({
    required this.nombre,
    required this.precio,
    required this.unidad,
  });

  // Método para crear un Producto desde un Map (Firestore)
  factory Producto.fromMap(Map<String, dynamic> map) {
    // Depuración: Imprimir los datos que recibimos de Firestore
    print('Datos recibidos de Firestore: $map');

    // Verificar el nombre (si está vacío, asignar una cadena vacía)
    var nombre = map['nombre'] ?? '';

    // Verificar el precio. Si el valor no es un número válido, asignar 0.0
    var precioString = map['precio'] ?? '';
    var precio = 0.0; // Valor predeterminado

    if (precioString is String && precioString.isNotEmpty) {
      precio = double.tryParse(precioString) ?? 0.0; // Si no se puede convertir, se asigna 0.0
    } else if (precioString is num) {
      precio = precioString.toDouble(); // Si ya es num, lo convertimos a double
    }

    // Verificar la unidad (si está vacía, asignar 'kg')
    var unidad = map['unidad'] ?? 'kg';

    // Depuración: Imprimir los valores que se usarán para crear el Producto
    print('Creando Producto: nombre=$nombre, precio=$precio, unidad=$unidad');

    return Producto(
      nombre: nombre,
      precio: precio,
      unidad: unidad,
    );
  }
}
