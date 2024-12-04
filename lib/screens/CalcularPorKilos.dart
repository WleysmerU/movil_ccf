import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'models/producto.dart';

class CalcularPorKiloScreen extends StatefulWidget {
  @override
  _CalcularPorKiloScreenState createState() => _CalcularPorKiloScreenState();
}

class _CalcularPorKiloScreenState extends State<CalcularPorKiloScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _searchController = TextEditingController();
  String searchTerm = '';
  Producto? productoSeleccionado;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calcular por Kilo')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar producto...',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchTerm = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: _firestore.collection('precios').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error al cargar los datos'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No hay productos disponibles'));
                }

                var productos = snapshot.data!.docs
                    .map((doc) => Producto.fromMap(doc.data() as Map<String, dynamic>))
                    .where((producto) => producto.nombre.toLowerCase().contains(searchTerm))
                    .toList();

                return ListView.builder(
                  itemCount: productos.length,
                  itemBuilder: (context, index) {
                    final producto = productos[index];
                    return Card(
                      child: ListTile(
                        title: Text(producto.nombre),
                        subtitle: Text('Precio por ${producto.unidad}: \$${producto.precio.toString()}'),
                        onTap: () {
                          // Al tocar el producto, abrir el BottomSheet
                          _mostrarCalculadora(producto);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Mostrar el BottomSheet para calcular el precio
  void _mostrarCalculadora(Producto producto) {
    TextEditingController _cantidadController = TextEditingController();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Mostrar el nombre del producto seleccionado
              Text(
                'Producto: ${producto.nombre}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              // Campo de cantidad
              TextField(
                controller: _cantidadController,
                decoration: InputDecoration(
                  labelText: 'Cantidad en ${producto.unidad}',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              // Botón para calcular el precio
              ElevatedButton(
                onPressed: () {
                  double cantidad = double.tryParse(_cantidadController.text) ?? 0;
                  if (cantidad > 0) {
                    double total = cantidad * producto.precio;
                    // Mostrar el resultado en un diálogo
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Total'),
                        content: Text('El total por ${cantidad} ${producto.unidad} es: \$${total.toStringAsFixed(2)}'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Cerrar'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    );
                  } else {
                    // Si la cantidad es inválida
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Por favor ingrese una cantidad válida')),
                    );
                  }
                },
                child: Text('Calcular Precio'),
              ),
            ],
          ),
        );
      },
    );
  }
}
