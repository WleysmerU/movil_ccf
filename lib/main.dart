import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_9/firebase_options.dart';
import 'screens/Admin_screen.dart';
import 'screens/CalcularPorKilos.dart';
import 'screens/CursosScreen.dart';
import 'screens/Descripcion.dart';
import 'screens/RecursosScreen.dart';
import 'screens/lista_precios.dart';
import 'screens/login_screen.dart';
import 'screens/Descripcion.dart';
import 'screens/chatbot_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';  // Importar Firebase Auth

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Agro',
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),  // Pantalla de Login
        '/admin': (context) => AdminScreen(),  // Redirige a AdminScreen si es admin
        '/usuario': (context) => MainUserScreen(),  // Redirige a MainUserScreen para usuarios
      },
    );
  }
}

class MainUserScreen extends StatefulWidget {
  @override
  _MainUserScreenState createState() => _MainUserScreenState();
}

class _MainUserScreenState extends State<MainUserScreen> {
  int _selectedIndex = 0;

  // Lista de pantallas para el usuario
  final List<Widget> _userScreens = [
    DescripcionScreen(),  // Módulo de descripción
    ChatbotScreen(),      // Módulo de chatbot
    ListaPreciosScreen(), // Módulo de lista de precios
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App Agro'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
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
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('Acerca de'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DescripcionScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.book),
              title: Text('Cursos Educativos'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CursosScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.school),
              title: Text('Recursos Educativos'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RecursosScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.calculate),
              title: Text('Calcular por Kilo'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CalcularPorKiloScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Cerrar sesión'),
              onTap: () {
                FirebaseAuth.instance.signOut();  // Cerrar sesión
                Navigator.pushReplacementNamed(context, '/login');  // Redirigir al login
              },
            ),
          ],
        ),
      ),
      body: _userScreens[_selectedIndex], // Pantalla seleccionada
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Descripción',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chatbot',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Precios',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped, // Cambiar entre pantallas
      ),
    );
  }
}
