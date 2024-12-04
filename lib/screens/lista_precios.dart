import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'models/producto.dart';

class ListaPreciosScreen extends StatefulWidget {
  @override
  _ListaPreciosScreenState createState() => _ListaPreciosScreenState();
}

class _ListaPreciosScreenState extends State<ListaPreciosScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _searchController = TextEditingController();
  String searchTerm = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Precios del Agro')),
      body: Column(
        children: [
          // Cuadro de búsqueda
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
          // Lista de productos
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

                // Filtrar los productos por el término de búsqueda
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
                        subtitle: Text('\$${producto.precio.toString()} ${producto.unidad}'), // Agregar unidad aquí
                        onTap: () {
                          // Aquí puedes agregar más detalles sobre el producto si lo deseas
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
}
