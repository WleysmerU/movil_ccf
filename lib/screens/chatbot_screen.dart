import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatbotScreen extends StatefulWidget {
  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Intenciones y palabras clave
  final List<Map<String, dynamic>> intents = [
  {'intent': 'greeting', 'keywords': ['hola', 'buenas tardes', 'buenos dias', 'buenas noches', 'que tal', 'buenas', 'hey', 'holi', 'holis', 'saludos', 'hi', 'hello', 'alo', 'ey', 'oye', 'tu', 'chatbot']},
  {'intent': 'status_check', 'keywords': ['como estas', 'como te va', 'como te encuentras', 'como te sientes', 'que tal estas', 'todo bien', 'como andas', 'estas bien']},  {'intent': 'price', 'keywords': ['precio', 'costos', 'cuanto cuesta', 'cuanto vale', 'cuanto sale', 'cual es el precio', 'precio de', 'valor', 'cuanto tiene', 'que cuesta', 'cual es el costo', 'cuanto es', 'cual es el valor']},
  {'intent': 'soil', 'keywords': ['suelo', 'tipos de suelo', 'terreno', 'tipos de terreno', 'suelo agrícola', 'tipos de tierras', 'suelo fértil', 'composición del suelo', 'características del suelo', 'suelo de cultivo']},
  {'intent': 'regions', 'keywords': ['region', 'ciudad', 'ubicacion', 'zonas agrícolas', 'zonas de cultivo', 'regiones agrícolas', 'áreas agrícolas', 'territorios agrícolas', 'región productiva', 'región de cultivo', 'zonas de producción', 'ciudades agrícolas']},
  {'intent': 'climate', 'keywords': ['clima', 'zonas climaticas', 'temperatura', 'condiciones climáticas', 'tipo de clima', 'clima en regiones', 'zona de temperatura', 'factores climáticos', 'climas en Colombia', 'clima de cultivo']},
  {'intent': 'challenges', 'keywords': ['retos', 'dificultades', 'problemas', 'desafíos', 'obstáculos', 'complicaciones', 'dificultades en agricultura', 'problemas agrícolas', 'retos del campo', 'situaciones difíciles']},
  {'intent': 'thanks', 'keywords': ['gracias', 'muchas gracias', 'te lo agradezco', 'mil gracias', 'gracias de verdad', 'muy amable', 'agradecido', 'gracias por todo', 'se agradece', 'te agradezco', 'infinitas gracias', 'gracias totales']},
  {'intent': 'advice', 'keywords': ['consejo', 'recomendacion', 'sugerencia', 'tip', 'orientacion', 'guia', 'recomendaciones', 'consejos', 'sugerencias', 'propuesta', 'indicacion', 'estrategia']},
  {'intent': 'recommendations', 'keywords': ['recomendaciones', 'sugerencias', 'consejos', 'tips', 'orientaciones', 'propuestas', 'guias', 'indicacion', 'consejo practico']},
  {'intent': 'suggestions', 'keywords': ['sugerencia', 'recomendacion', 'propuesta', 'consejo', 'tip', 'guia', 'indicacion', 'recomendacion practica']},
  {'intent': 'tips', 'keywords': ['tip', 'consejo', 'sugerencia', 'recomendacion', 'trucos', 'estrategias', 'orientaciones', 'tacticas']},
  {'intent': 'guidance', 'keywords': ['guia', 'orientacion', 'consejos', 'recomendaciones', 'apoyo', 'instrucciones', 'asesoria', 'direccion']}
  ];

  final Map<String, String> responses = {
  'greeting': '¡Hola! 👋 Bienvenido, ¿en qué puedo ayudarte hoy?',
  'status_check': '¡Gracias por preguntar! 😊 Estoy funcionando perfectamente y listo para ayudarte con cualquier consulta que tengas. ¿En qué te puedo ayudar?', 
  'regions': 'Las regiones agrícolas de Colombia son muy diversas y tienen diferentes características que afectan a los cultivos 🏞️. En la región Andina ⛰️, por ejemplo, la altitud y el clima son perfectos para el cultivo del café ☕. En la región Caribe 🏝️, la cercanía al mar 🌊 y el clima cálido hacen que productos como el banano 🍌 y la palma 🥥 crezcan muy bien. Cada región tiene su propia combinación de suelo, clima y agua 💧, lo que influye en la productividad de los cultivos. ¿Te gustaría conocer más sobre cómo estos factores afectan a los cultivos en una región específica? 🌍',
  'climate': 'El clima afecta profundamente a los cultivos en Colombia 🌞❄️. Las zonas cálidas 🌡️, con altitudes más bajas, son ideales para cultivos tropicales como el banano 🍌, que necesita temperaturas estables y altas 🌴. En las zonas templadas 🌿, que tienen temperaturas moderadas, el café ☕ y los frutales como el aguacate 🥑 prosperan. En las zonas frías 🧊, con temperaturas más bajas, cultivos como la papa 🥔, trigo 🌾 y cebolla 🧅 se desarrollan mejor. Así que, dependiendo del clima de la zona, los agricultores deben elegir los cultivos que mejor se adapten a esas condiciones. ¿Te gustaría saber más sobre cómo adaptar los cultivos a diferentes climas? 🌤️',
  'challenges': 'Los retos como el acceso a insumos afectan directamente la productividad de los cultivos 🚜💸. Los fertilizantes y pesticidas son esenciales para el crecimiento y protección de las plantas, pero los precios elevados 💰 y la falta de disponibilidad pueden limitar su uso. Además, la infraestructura de transporte deficiente en algunas áreas dificulta la distribución de productos agrícolas 🚚, lo que afecta tanto a los precios como a la frescura de los productos 🥕🍅. Por otro lado, la adopción de nuevas tecnologías en los cultivos puede mejorar la eficiencia 📲💡, pero muchos agricultores pequeños no tienen acceso a ellas. ¿Te gustaría saber cómo los agricultores están superando estos retos? 🤔',
  'thanks': '¡De nada! 😄 Me alegra poder ayudarte 🤗. Si tienes más preguntas o algo más en lo que pueda asistirte, no dudes en decírmelo. ¡Estoy a tu disposición! 💬',
  'advice': 'Si estás comenzando con tus cultivos, mi consejo 💡 es que siempre investigues bien el tipo de suelo 🌱 y clima 🌞 en tu región. Conocer las características específicas de tu tierra te permitirá elegir los cultivos más adecuados y obtener mejores resultados 🌾. También te recomiendo que mantengas un control constante sobre los costos de insumos 💸, ya que estos pueden variar, y planifiques tus actividades según las estaciones del año 🗓️ para optimizar el rendimiento. ¿Te gustaría recibir más recomendaciones sobre cómo empezar? 🤔',
  'recommendations': 'Te sugiero que, antes de comenzar a sembrar 🌾, realices un análisis de suelo 🧪. Esto te ayudará a entender mejor las necesidades de tus cultivos y evitar problemas en el futuro 🌱. Además, mantén siempre un ojo 👀 en las condiciones climáticas 🌦️, ya que factores como el fenómeno de El Niño 🌬️ pueden afectar los rendimientos. ¿Te gustaría obtener recomendaciones sobre cómo gestionar tus cultivos durante la temporada seca o lluviosa? 💧',
  'tips': 'Un consejo clave para cualquier agricultor 🌾 es diversificar los cultivos 🌻. Esto no solo te protege de posibles fallos en un solo cultivo, sino que también te permite aprovechar mejor el suelo 🌍 y las condiciones climáticas 🌦️. Otro tip es utilizar tecnologías como sensores de humedad 🌡️ o aplicaciones 📱 para monitorear el clima y los cultivos. ¿Te gustaría saber más sobre cómo implementarlo? 💻',
  'suggestions': 'Si buscas mejorar la productividad 📈, considera implementar técnicas de riego eficientes 💧 y utilizar abonos orgánicos 🍂 que mejoren la calidad del suelo 🌱. Además, te sugiero que estés al tanto de las tendencias de mercado 📊 para saber cuándo es el mejor momento para vender tus productos 💵. ¿Te interesa conocer más sobre cómo comercializar tus cultivos? 🛒',
  'guidance': 'Para optimizar tus cultivos 🌿, te guiaría en la selección de semillas de alta calidad 🌱 y el uso adecuado de fertilizantes orgánicos 🌾, que son más sostenibles y beneficiosos para el suelo a largo plazo. Además, contar con un plan de manejo de plagas natural 🐞 puede ser muy efectivo. ¿Te gustaría recibir más guías sobre cómo manejar plagas o enfermedades en los cultivos? 🌱'
  };

  String _detectarIntencion(String mensaje) {
  mensaje = mensaje.toLowerCase();
  for (var intent in intents) {
    for (var keyword in intent['keywords']) {
      if (mensaje.contains(keyword)) {
        return intent['intent'];
      }
    }
  }

  // Detectar si es una consulta directa de producto
  if (mensaje.split(' ').any((palabra) => palabra.length > 2)) {
    return 'price'; // Asumimos que es una consulta de precio si no hay otra intención clara
  }

  return 'unknown';
}

Future<String> _buscarProducto(String consulta) async {
  try {
    // Extraer posibles palabras clave relacionadas con productos
    final palabrasClave = consulta
        .toLowerCase()
        .replaceAll(RegExp(r'(precio|de|cuánto cuesta|vale|es)'), '')
        .trim();

    if (palabrasClave.isEmpty) {
      return 'Por favor, especifica un producto. Ejemplo: "precio de tomate".';
    }

    QuerySnapshot resultado = await _firestore.collection('precios').get();

    List<QueryDocumentSnapshot> coincidencias = resultado.docs.where((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final nombreProducto = (data['nombre'] ?? '').toString().toLowerCase();
      return nombreProducto.contains(palabrasClave);
    }).toList();

    if (coincidencias.isEmpty) {
      return 'No encontré productos relacionados con "$palabrasClave".';
    }

    return coincidencias.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final nombre = data['nombre'];
      final precio = data['precio'];
      final unidad = data.containsKey('unidad') ? data['unidad'] : 'unidad';
      return '$nombre: \$${precio.toString()} por $unidad';
    }).join('\n');
  } catch (e) {
    return 'Ocurrió un error al buscar el producto. Por favor, inténtalo nuevamente.';
  }
}

  void _enviarMensaje() async {
    String mensajeUsuario = _messageController.text.trim();
    if (mensajeUsuario.isEmpty) return;

    setState(() {
      _messages.add({'sender': 'user', 'text': mensajeUsuario});
    });

    _messageController.clear();

    String respuesta;
    String intencion = _detectarIntencion(mensajeUsuario);

    if (intencion == 'price') {
      respuesta = await _buscarProducto(mensajeUsuario);
    } else if (responses.containsKey(intencion)) {
      respuesta = responses[intencion]!;
    } else {
      respuesta = 'Lo siento, no entiendo tu mensaje.';
    }

    setState(() {
      _messages.add({'sender': 'chatbot', 'text': respuesta});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chatbot - Agro')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final mensaje = _messages[index];
                return Align(
                  alignment: mensaje['sender'] == 'user' ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: mensaje['sender'] == 'user' ? Colors.blue[100] : Colors.green[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(mensaje['text']!, style: TextStyle(fontSize: 16)),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(hintText: 'Escribe tu consulta aquí...', border: OutlineInputBorder()),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(icon: Icon(Icons.send), onPressed: _enviarMensaje),
              ],
            ),
          ),
        ],
      ),
    );
  }
}