import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DescripcionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('¿Qué es esta App?')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AgroFinanzas: Empoderando a los Agricultores',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade700,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'AgroFinanzas es una plataforma diseñada específicamente para empoderar a los agricultores del Chocó, Colombia, '
              'brindándoles herramientas que les permitan mejorar su calidad de vida a través del acceso directo a información crítica '
              'y actualizada sobre el mercado agrícola.',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),
            Text(
              'Funcionalidades Principales:',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade600,
              ),
            ),
            const SizedBox(height: 10),
            BulletPointList([
              'Precios Actualizados en Tiempo Real: Obtén información precisa y al instante sobre los precios de productos agrícolas.',
              'Capacitación Especializada: Accede a recursos educativos y cursos en línea sobre técnicas de cultivo, negociación y más.',
              'Red de Apoyo y Colaboración: Conecta con otros agricultores para compartir experiencias y obtener asistencia personalizada.',
              'Visión de Desarrollo Sostenible: Contribuye al bienestar económico de las comunidades agrícolas mediante soluciones sostenibles.'
            ]),
            const SizedBox(height: 20),
            Text(
              '¿Por qué AgroFinanzas?',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade600,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'A través de esta aplicación, buscamos reducir las barreras que enfrentan los pequeños productores, como la falta de acceso a '
              'tecnología y a información relevante. Nuestra misión es crear un espacio donde los agricultores puedan acceder no solo a datos sobre '
              'el valor de sus productos, sino también a formación continua y recursos que les permitan competir en el mercado de manera justa y equitativa.',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),
            Text(
              'Con AgroFinanzas, el futuro de la agricultura es más justo, más transparente y más accesible.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green.shade700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // Contenedor de Contacto
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.transparent,  // Fondo transparente
              alignment: Alignment.center,
              child: Column(  
                children: [
                  GestureDetector(
                    onTap: () => launch('tel:+573023276809'), // Cambia por tu número de teléfono
                    child: Text(
                      '+573023276809', // Número de teléfono
                      style: TextStyle(color: Colors.blue, fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => launch('https://www.instagram.com/wleys_c137/profilecard/?igsh=MW04anVvbzV3dDZndg=='), // Cambia por tu red social
                    child: Text(
                      'Instagram',
                      style: TextStyle(color: Colors.blue, fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => launch('mailto:wleismerusuga@gmail.com'), // Cambia por tu correo
                    child: Text(
                      'wleismerusuga@gmail.com', // Correo electrónico
                      style: TextStyle(color: Colors.blue, fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BulletPointList extends StatelessWidget {
  final List<String> items;

  BulletPointList(this.items);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map((item) => Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.circle, size: 8, color: Colors.green.shade600),
                  const SizedBox(width: 8),
                  Expanded(child: Text(item, style: TextStyle(fontSize: 18))),
                ],
              ))
          .toList(),
    );
  }
}
