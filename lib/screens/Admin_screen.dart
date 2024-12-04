import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  String searchTerm = '';

  // Agregar un nuevo producto
  Future<void> _addProduct() async {
    if (_nameController.text.isNotEmpty &&
        _priceController.text.isNotEmpty &&
        _unitController.text.isNotEmpty) {
      await _firestore.collection('precios').add({
        'nombre': _nameController.text,
        'precio': double.parse(_priceController.text),
        'unidad': _unitController.text,
      });

      _nameController.clear();
      _priceController.clear();
      _unitController.clear();
      Navigator.pop(context);  // Cerrar el diálogo de agregar producto
    }
  }

  // Eliminar producto por ID
  Future<void> _deleteProduct(String productId) async {
    await _firestore.collection('precios').doc(productId).delete();
  }

  // Actualizar producto
  Future<void> _updateProduct(String productId, String newName, double newPrice, String newUnit) async {
    await _firestore.collection('precios').doc(productId).update({
      'nombre': newName,
      'precio': newPrice,
      'unidad': newUnit,
    });
  }

  // Buscar productos
  List<QueryDocumentSnapshot> _getFilteredProducts(List<QueryDocumentSnapshot> productos) {
    return productos
        .where((producto) => producto['nombre'].toString().toLowerCase().contains(searchTerm.toLowerCase()))
        .toList();
  }

  // Manejo de usuarios (eliminar usuario)
  Future<void> _deleteUser(String userId) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pantalla de Administrador')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Text(
                'Menú',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Cerrar sesión'),
              onTap: () {
                _auth.signOut();
                Navigator.of(context).pushReplacementNamed('/login'); // Redirigir a la pantalla de login
              },
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Gestionar Usuarios'),
              onTap: () {
                // Aquí puedes abrir una pantalla para gestionar usuarios
              },
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Agregar Producto'),
              onTap: () {
                // Mostrar formulario para agregar producto
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Agregar Nuevo Producto'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: _nameController,
                            decoration: InputDecoration(labelText: 'Nombre del Producto'),
                          ),
                          TextField(
                            controller: _priceController,
                            decoration: InputDecoration(labelText: 'Precio del Producto'),
                            keyboardType: TextInputType.number,
                          ),
                          TextField(
                            controller: _unitController,
                            decoration: InputDecoration(labelText: 'Unidad del Producto'),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            _addProduct();
                          },
                          child: Text('Agregar'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Cerrar el diálogo
                          },
                          child: Text('Cancelar'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Buscar Producto',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchTerm = value;
                });
              },
            ),
            SizedBox(height: 20),
            // Lista de productos (con eliminar y editar)
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

                  var productos = snapshot.data!.docs;
                  var filteredProductos = _getFilteredProducts(productos);

                  return ListView.builder(
                    itemCount: filteredProductos.length,
                    itemBuilder: (context, index) {
                      var producto = filteredProductos[index];
                      return Card(
                        child: ListTile(
                          title: Text(producto['nombre']),
                          subtitle: Text('COP ${producto['precio']} / ${producto['unidad']}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  // Mostrar cuadro de diálogo para editar
                                  _nameController.text = producto['nombre'];
                                  _priceController.text = producto['precio'].toString();
                                  _unitController.text = producto['unidad'];
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Editar Producto'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextField(
                                            controller: _nameController,
                                            decoration: InputDecoration(labelText: 'Nuevo Nombre'),
                                          ),
                                          TextField(
                                            controller: _priceController,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(labelText: 'Nuevo Precio'),
                                          ),
                                          TextField(
                                            controller: _unitController,
                                            decoration: InputDecoration(labelText: 'Nueva Unidad'),
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            _updateProduct(
                                              producto.id,
                                              _nameController.text,
                                              double.parse(_priceController.text),
                                              _unitController.text,
                                            );
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Actualizar'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  _deleteProduct(producto.id);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
