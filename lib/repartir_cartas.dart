import 'dart:math';

enum TipoCarta {
  castillo,   // Defensiva
  security,   // Protección
  sword       // Ataque
}

class Carta {
  final String id;         // Identificador único de la carta
  final String nombre;     // Nombre de la carta
  final String artwork;    // Ruta del artwork
  final TipoCarta tipo;    // Tipo de carta
  final int poder;         // Poder de la carta

  Carta({
    required this.id,
    required this.nombre,
    required this.artwork,
    required this.tipo,
    required this.poder,
  });
}

class RepartirCartas {
  // Mazos de Caballeros y Monstruos con detalles completos
  final List<Carta> mazoCaballeros = [
    Carta(
      id: 'C1', 
      nombre: 'Caballeros Novatos', 
      artwork: 'assets/images/caballeros/Bronce1.jpg',
      tipo: TipoCarta.sword, 
      poder: 3
    ),
    Carta(
      id: 'C2', 
      nombre: 'Caballero de la Guardia', 
      artwork: 'assets/images/caballeros/Bronce2.jpg',
      tipo: TipoCarta.security, 
      poder: 4
    ),
    Carta(
      id: 'C3', 
      nombre: 'Caballero del Asalto', 
      artwork: 'assets/images/caballeros/Bronce3.jpg',
      tipo: TipoCarta.sword, 
      poder: 4
    ),
    Carta(
      id: 'C4', 
      nombre: 'Caballeros Veteranos', 
      artwork: 'assets/images/caballeros/Bronce4.jpg',
      tipo: TipoCarta.sword, 
      poder: 6
    ),
    Carta(
      id: 'C5', 
      nombre: 'Caballero Veterano', 
      artwork: 'assets/images/caballeros/Bronce5.jpg',
      tipo: TipoCarta.sword, 
      poder: 2
    ),
    Carta(
      id: 'C6', 
      nombre: 'Caballero Aldeano', 
      artwork: 'assets/images/caballeros/Bronce6.jpg',
      tipo: TipoCarta.sword, 
      poder: 2
    ),
    Carta(
      id: 'C7', 
      nombre: 'Primeros Auxilios', 
      artwork: 'assets/images/caballeros/Bronce7.jpg',
      tipo: TipoCarta.security, 
      poder: 6
    ),
    Carta(
      id: 'C8', 
      nombre: 'Catapulta', 
      artwork: 'assets/images/caballeros/Bronce8.jpg',
      tipo: TipoCarta.castillo, 
      poder: 6
    ),
    Carta(
      id: 'C9', 
      nombre: 'Roba Fechas', 
      artwork: 'assets/images/caballeros/Bronce9.jpg',
      tipo: TipoCarta.security, 
      poder: 4
    ),
    Carta(
      id: 'C10', 
      nombre: 'Elfo Aliado', 
      artwork: 'assets/images/caballeros/Bronce11.jpg',
      tipo: TipoCarta.security, 
      poder: 5
    ),
    Carta(
      id: 'C11', 
      nombre: 'Asesino Aliado', 
      artwork: 'assets/images/caballeros/Bronce12.jpg',
      tipo: TipoCarta.sword, 
      poder: 3
    ),
    Carta(
      id: 'C12', 
      nombre: 'Ciri', 
      artwork: 'assets/images/caballeros/Oro 1.jpg',
      tipo: TipoCarta.security, 
      poder: 8
    ),
    Carta(
      id: 'C13', 
      nombre: 'Gerald', 
      artwork: 'assets/images/caballeros/Oro 2.jpg',
      tipo: TipoCarta.sword, 
      poder: 9
    ),
    Carta(
      id: 'C14', 
      nombre: 'Tower defense', 
      artwork: 'assets/images/caballeros/Oro 3.jpg',
      tipo: TipoCarta.castillo, 
      poder: 8
    ),
    Carta(
      id: 'C15', 
      nombre: 'Vampiro Aliado', 
      artwork: 'assets/images/caballeros/Oro 4.jpg',
      tipo: TipoCarta.sword, 
      poder: 8
    ),
    Carta(
      id: 'C16', 
      nombre: 'Coordinador en torre', 
      artwork: 'assets/images/caballeros/Plata 1.jpg',
      tipo: TipoCarta.castillo, 
      poder: 3
    ),
    Carta(
      id: 'C17', 
      nombre: 'Torre de Madera', 
      artwork: 'assets/images/caballeros/Plata 2.jpg',
      tipo: TipoCarta.castillo, 
      poder: 4
    ),
    Carta(
      id: 'C18', 
      nombre: 'Elfa Arquera', 
      artwork: 'assets/images/caballeros/Plata 3.jpg',
      tipo: TipoCarta.security, 
      poder: 6
    ),
    Carta(
      id: 'C19', 
      nombre: 'Torre de piedra', 
      artwork: 'assets/images/caballeros/Plata 6.jpg',
      tipo: TipoCarta.castillo, 
      poder: 6
    ),
    Carta(
      id: 'C20', 
      nombre: 'catapulta de fuego', 
      artwork: 'assets/images/caballeros/Plata 8.jpg',
      tipo: TipoCarta.castillo, 
      poder: 6
    ),
  ];

  final List<Carta> mazoMonstruos = [
    // Monstruos con poder bajo
    Carta(
      id: 'M1', 
      nombre: 'Monstruo Grande', 
      artwork: 'assets/images/monstruos/Bronce1.jpg', 
      tipo: TipoCarta.sword, 
      poder: 4
    ),
    Carta(
      id: 'M2', 
      nombre: 'Monstruo Defensivo', 
      artwork: 'assets/images/monstruos/Bronce4.jpg', 
      tipo: TipoCarta.castillo, 
      poder: 5
    ),
    Carta(
      id: 'M3', 
      nombre: 'Meretriz', 
      artwork: 'assets/images/monstruos/Bronce5.jpg', 
      tipo: TipoCarta.security, 
      poder: 4
    ),
    Carta(
      id: 'M4', 
      nombre: 'Monstruo Pequeño', 
      artwork: 'assets/images/monstruos/Bronce6.jpg', 
      tipo: TipoCarta.sword, 
      poder: 2
    ),
    Carta(
      id: 'M5', 
      nombre: 'Monstruo Lagarto', 
      artwork: 'assets/images/monstruos/Bronce7.jpg', 
      tipo: TipoCarta.sword, 
      poder: 4
    ),
    Carta(
      id: 'M6', 
      nombre: 'Hogo venenoso', 
      artwork: 'assets/images/monstruos/Bronce8.jpg', 
      tipo: TipoCarta.security, 
      poder: 3
    ),
    Carta(
      id: 'M7', 
      nombre: 'Grull', 
      artwork: 'assets/images/monstruos/Bronce9.jpg', 
      tipo: TipoCarta.sword, 
      poder: 3
    ),
    Carta(
      id: 'M8', 
      nombre: 'Arpias', 
      artwork: 'assets/images/monstruos/Bronce10.jpg', 
      tipo: TipoCarta.security, 
      poder: 4
    ),
    Carta(
      id: 'M9', 
      nombre: 'Renacidos', 
      artwork: 'assets/images/monstruos/Bronce11.jpg', 
      tipo: TipoCarta.sword, 
      poder: 5
    ),
    Carta(
      id: 'M10', 
      nombre: 'grull pequeño', 
      artwork: 'assets/images/monstruos/Bronce12.jpg', 
      tipo: TipoCarta.sword, 
      poder: 3
    ),
    Carta(
      id: 'M11', 
      nombre: 'Grull magico', 
      artwork: 'assets/images/monstruos/Bronce13.jpg', 
      tipo: TipoCarta.security, 
      poder: 2
    ),
    Carta(
      id: 'M12', 
      nombre: 'Caballero negro', 
      artwork: 'assets/images/monstruos/Bronce14.jpg', 
      tipo: TipoCarta.security, 
      poder: 5
    ),
    Carta(
      id: 'M13', 
      nombre: 'Caido del castillo', 
      artwork: 'assets/images/monstruos/Oro 1.jpg', 
      tipo: TipoCarta.security, 
      poder: 7
    ),
    Carta(
      id: 'M14', 
      nombre: 'El Frio', 
      artwork: 'assets/images/monstruos/Oro 3.jpg', 
      tipo: TipoCarta.sword, 
      poder: 8
    ),
    Carta(
      id: 'M15', 
      nombre: 'Arbol de muertos', 
      artwork: 'assets/images/monstruos/Oro 4.jpg', 
      tipo: TipoCarta.castillo, 
      poder: 9
    ),
    Carta(
      id: 'M16', 
      nombre: 'Cadaver de la araña', 
      artwork: 'assets/images/monstruos/Plata 2.jpg', 
      tipo: TipoCarta.castillo, 
      poder: 5
    ),
    Carta(
      id: 'M17', 
      nombre: 'Troll', 
      artwork: 'assets/images/monstruos/Plata 3.jpg', 
      tipo: TipoCarta.castillo, 
      poder: 6
    ),
    Carta(
      id: 'M18', 
      nombre: 'Glifo', 
      artwork: 'assets/images/monstruos/Plata 4.jpg', 
      tipo: TipoCarta.security, 
      poder: 5
    ),
    Carta(
      id: 'M19', 
      nombre: 'Guardian', 
      artwork: 'assets/images/monstruos/Plata 5.jpg', 
      tipo: TipoCarta.castillo, 
      poder: 5
    ),
    Carta(
      id: 'M20', 
      nombre: 'Linch del bosque', 
      artwork: 'assets/images/monstruos/Plata 6.jpg', 
      tipo: TipoCarta.castillo, 
      poder: 6
    ),
  ];
  
  List<String> cartasJugador = [];
  List<String> cartasContrincante = [];

  void repartir(String tipoMazo) {
    final random = Random();
    
    // Crear copias para barajar
    var caballerosBarajados = List.of(mazoCaballeros);
    var monstruosBarajados = List.of(mazoMonstruos);
    
    // Barajar
    caballerosBarajados.shuffle(random);
    monstruosBarajados.shuffle(random);

    // Dependiendo del tipo de mazo seleccionado, asignar cartas
    if (tipoMazo == 'Caballeros') {
      cartasJugador = caballerosBarajados.take(10).map((carta) => carta.id).toList();
      cartasContrincante = monstruosBarajados.take(10).map((carta) => carta.id).toList();
    } else if (tipoMazo == 'Monstruos') {
      cartasJugador = monstruosBarajados.take(10).map((carta) => carta.id).toList();
      cartasContrincante = caballerosBarajados.take(10).map((carta) => carta.id).toList();
    } else {
      throw Exception('Tipo de mazo no válido');
    }
  }

  // Método para obtener los detalles de una carta por su ID
  Carta obtenerCartaPorId(String id) {
    try {
      return [...mazoCaballeros, ...mazoMonstruos].firstWhere((carta) => carta.id == id);
    } catch (e) {
      throw Exception('Carta no encontrada con ID: $id');
    }
  }
}