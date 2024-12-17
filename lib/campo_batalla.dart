import 'package:flutter/material.dart';
import 'repartir_cartas.dart';

class CampoBatalla extends StatefulWidget {
  final String tipoMazo;
  
  const CampoBatalla({super.key, required this.tipoMazo});

  @override
  _CampoBatallaState createState() => _CampoBatallaState();
}

class _CampoBatallaState extends State<CampoBatalla> {
  final RepartirCartas repartirCartas = RepartirCartas();
  List<String> cartasEnCampoJugador = [];
  List<String> cartasEnCampoContrincante = [];
  List<String> cartasEnCampoRojot = [];
  List<String> cartasEnCampoRojoa = [];
  List<String> cartasEnCampoRojoc = [];
  List<String> cartasEnCampoVerdet = [];
  List<String> cartasEnCampoVerdea = [];
  List<String> cartasEnCampoVerdec = [];
  
  bool isDragging = false;

  @override
  void initState() {
    super.initState();
    repartirCartas.repartir(widget.tipoMazo);
    setState(() {
      cartasEnCampoJugador = List.from(repartirCartas.cartasJugador);
      cartasEnCampoContrincante = List.from(repartirCartas.cartasContrincante);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: size.width,
            height: size.height,
            decoration: BoxDecoration(
              color: Colors.brown[200],
              image: const DecorationImage(
                image: AssetImage('assets/images/wood_background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: CustomPaint(
              painter: ZigZagPainter(),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _crearJugador('Contrincante', 'assets/images/enemy_avatar.jpg'),
                        _crearRectanguloCartasCampo(),
                        _crearJugador('Jugador Actual', 'assets/images/player_avatar.jpg'),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: Column(
                      children: [
                        _crearEspacioCartasJugador(Colors.red[400]!, cartasEnCampoContrincante, true),
                        Expanded(
                          flex: 7,
                          child: Stack(
                            children: [
                              _crearEspaciosCartas(),
                              _crearLineaDivisoria(),
                            ],
                          ),
                        ),
                        _crearEspacioCartasJugador(Colors.green[400]!, cartasEnCampoJugador, false),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: Colors.brown[200],
                      title: const Text(
                        'Confirmación',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      content: const Text(
                        '¿Estás seguro de terminar la partida?',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Cierra el modal
                          },
                          child: const Text(
                            'Cancelar',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Cierra el modal
                            Navigator.pop(context); // Cierra la partida
                          },
                          child: const Text(
                            'Aceptar',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.red[800],
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _crearJugador(String nombre, String avatarPath) {
    // Calcular el poder total dependiendo de si es contrincante o jugador
    int poderTotal = 0;
    if (nombre == 'Contrincante') {
      poderTotal = cartasEnCampoRojot.fold(0, (sum, carta) => sum + repartirCartas.obtenerCartaPorId(carta).poder).toInt() +
                  cartasEnCampoRojoa.fold(0, (sum, carta) => sum + repartirCartas.obtenerCartaPorId(carta).poder).toInt() +
                  cartasEnCampoRojoc.fold(0, (sum, carta) => sum + repartirCartas.obtenerCartaPorId(carta).poder).toInt();
    } else if (nombre == 'Jugador Actual') {
      poderTotal = cartasEnCampoVerdet.fold(0, (sum, carta) => sum + repartirCartas.obtenerCartaPorId(carta).poder).toInt() +
                  cartasEnCampoVerdea.fold(0, (sum, carta) => sum + repartirCartas.obtenerCartaPorId(carta).poder).toInt() +
                  cartasEnCampoVerdec.fold(0, (sum, carta) => sum + repartirCartas.obtenerCartaPorId(carta).poder).toInt();
    }

    return Column(
      children: [
        if (nombre == 'Contrincante') ...[
          // Name first
          Text(
            nombre,
            style: const TextStyle(
              fontSize: 20, 
              color: Colors.white, 
              fontWeight: FontWeight.bold
            ),
          ),
          const SizedBox(height: 2),
          // Avatar
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage(avatarPath),
          ),
          const SizedBox(height: 8),
          // Total power circle
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: Center(
              child: Text(
                '$poderTotal',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Vida del contrincante
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLifeContainer(true),
              const SizedBox(width: 5),
              _buildLifeContainer(true),
            ],
          ),
        ],
        if (nombre == 'Jugador Actual') ...[
          const SizedBox(height: 8),
          // Botón de Pasar
          IconButton(
            onPressed: () {
              print('Turno pasado');
            },
            icon: Icon(
              Icons.skip_next,
              color: Colors.white,
              size: 35,
            ),
            style: IconButton.styleFrom(
              backgroundColor: Colors.brown[600],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Colors.brown[800]!, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLifeContainer(false),
              const SizedBox(width: 5),
              _buildLifeContainer(false),
            ],
          ),
          const SizedBox(height: 8),
          // Círculo de poder total
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: Center(
              child: Text(
                '$poderTotal',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Avatar
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage(avatarPath),
          ),
          const SizedBox(height: 2),
          // Name last
          Text(
            nombre,
            style: const TextStyle(
              fontSize: 20, 
              color: Colors.white, 
              fontWeight: FontWeight.bold
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildLifeContainer(bool isOpponent) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        color: Colors.red[700], 
      ),
    );
  }

  Widget _crearRectanguloCartasCampo() {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.brown[600],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.brown[800]!,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.brown[900]!,
            spreadRadius: 1,
            blurRadius: 2,
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.brown[400]!,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _crearEspaciosCartas() {
    return Column(
      children: [
        _crearFilaCartas(Colors.red[200]!, Icons.castle, Alignment.centerLeft, cartasEnCampoRojot, true),
        _crearFilaCartas(Colors.red[200]!, Icons.security, Alignment.centerLeft, cartasEnCampoRojoa, true),
        _crearFilaCartas(Colors.red[200]!, Icons.person, Alignment.centerLeft, cartasEnCampoRojoc, true),
        _crearFilaCartas(Colors.green[200]!, Icons.person, Alignment.centerLeft, cartasEnCampoVerdec, false),
        _crearFilaCartas(Colors.green[200]!, Icons.security, Alignment.centerLeft, cartasEnCampoVerdea, false),
        _crearFilaCartas(Colors.green[200]!, Icons.castle, Alignment.centerLeft, cartasEnCampoVerdet, false),
      ],
    );
  }

  Widget _crearFilaCartas(
  Color colorFondo, 
  IconData icono, 
  AlignmentGeometry posicionIcono, 
  List<String> cartasEnCampo, 
  bool esRojo
  ) {
    // Calcular el poder total de las cartas en esta fila
    int poderTotal = cartasEnCampo.isEmpty 
      ? 0 
      : cartasEnCampo
          .map((carta) => repartirCartas.obtenerCartaPorId(carta).poder)
          .reduce((a, b) => a + b);

    return DragTarget<String>(
      onWillAccept: (data) {
        // Si es rojo, no se puede colocar carta
        if (esRojo) return false;

        // Obtener los detalles de la carta
        final cartaDetalle = repartirCartas.obtenerCartaPorId(data!);

        // Validar que el tipo de carta coincida con el ícono de la fila
        if (
          (icono == Icons.castle && cartaDetalle.tipo == TipoCarta.castillo) ||
          (icono == Icons.security && cartaDetalle.tipo == TipoCarta.security) ||
          (icono == Icons.person && cartaDetalle.tipo == TipoCarta.sword)
        ) {
          return true;
        }

        return false;
      },
      onAccept: (carta) {
        setState(() {
          cartasEnCampoJugador.remove(carta);
          cartasEnCampo.add(carta);
        });
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          padding: const EdgeInsets.all(4.5),
          height: 100,
          decoration: BoxDecoration(
            color: colorFondo,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              color: Colors.brown[800]!,
              width: 2,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                left: posicionIcono == Alignment.centerLeft ? 8.0 : null,
                right: posicionIcono == Alignment.centerRight ? 8.0 : null,
                child: Column(
                  children: [
                    Icon(
                      icono,
                      size: 40,
                      color: Colors.brown[900],
                    ),
                    // Círculo de poder total
                    Container(
                      width: 40,
                      height: 40,
                      margin: const EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: Center(
                        child: Text(
                          '$poderTotal',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Scroll horizontal de cartas (igual que antes)
              Positioned(
                left: 50,
                right: 0,
                top: 0,
                bottom: 0,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: cartasEnCampo.map((carta) {
                      return _buildCardContainer(carta, Colors.white);
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _crearLineaDivisoria() {
    return Positioned.fill(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 2,
                  decoration: BoxDecoration(
                    color: Colors.brown[900],
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.brown[900]!,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.brown[900],
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.brown[600]!, width: 2),
                ),
                child: const Center(
                  child: Text(
                    'VS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 2,
                  decoration: BoxDecoration(
                    color: Colors.brown[900],
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.brown[900]!,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _crearEspacioCartasJugador(Color color, List<String> cartas, bool esContrincante) {
    return Expanded(
      flex: 1,
      child: DragTarget<String>(
        onWillAccept: (data) => !esContrincante,
        onAccept: (carta) {
          // Si la carta no está en el espacio original, la devolvemos
          if (!cartas.contains(carta)) {
            setState(() {
              cartas.add(carta);
            });
          }
        },
        builder: (context, candidateData, rejectedData) {
          return Container(
            width: 325,
            decoration: BoxDecoration( 
              color: color, 
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: cartas.length,
              itemBuilder: (context, index) {
                return _crearCarta(cartas[index], esContrincante);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _crearCarta(String carta, bool esContrincante) {
    return GestureDetector(
      onTap: () {
        if (!esContrincante) {
          _mostrarModalCarta(carta);
        }
      },
      onPanStart: (details) {
        setState(() {
          isDragging = !esContrincante;
        });
      },
      child: isDragging && !esContrincante
          ? Draggable<String>(
              data: carta,
              feedback: _buildCardContainer(carta, Colors.transparent),  // Elimina el Material widget
              childWhenDragging: Container(),
              child: _buildCardContainer(carta, Colors.transparent),
            )
          : _buildCardContainer(carta, Colors.transparent),
    );
  }

  void _mostrarModalCarta(String carta) {
    final cartaDetalle = repartirCartas.obtenerCartaPorId(carta);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: 300,
            height: 450,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.brown[800]!, width: 3),
              image: DecorationImage(
                image: AssetImage(cartaDetalle.artwork),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Detalles en la parte superior
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Tipo de carta
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          _getIconoTipoCarta(cartaDetalle.tipo),
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      // Poder de la carta
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black, width: 2),
                        ),
                        child: Center(
                          child: Text(
                            '${cartaDetalle.poder}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Botón de cerrar
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Cerrar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Método auxiliar para obtener el icono según el tipo de carta
  IconData _getIconoTipoCarta(TipoCarta tipo) {
    switch (tipo) {
      case TipoCarta.castillo:
        return Icons.castle;
      case TipoCarta.security:
        return Icons.security;
      case TipoCarta.sword:
        return Icons.person;
    }
  }

  Widget _buildCardContainer(String carta, Color color) {
  // Obtener los detalles de la carta usando el método obtenerCartaPorId
  final cartaDetalle = repartirCartas.obtenerCartaPorId(carta);

  // Seleccionar el icono basado en el tipo de carta
  IconData tipoIcono;
  switch (cartaDetalle.tipo) {
    case TipoCarta.castillo:
      tipoIcono = Icons.castle;
      break;
    case TipoCarta.security:
      tipoIcono = Icons.security;
      break;
    case TipoCarta.sword:
      tipoIcono = Icons.person;
      break;
  }

  return Container(
    margin: const EdgeInsets.all(8.0),
    width: 70,
    height: 100,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(8.0),
      border: Border.all(color: Colors.brown[800]!, width: 2),
      image: DecorationImage(
        image: AssetImage(cartaDetalle.artwork),
        fit: BoxFit.cover,
      ),
    ),
      child: Column(
        children: [
          // Fila superior con tipo de carta e información de poder
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Icono del tipo de carta
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      tipoIcono,
                      color: Colors.black,
                      size: 23, 
                    ),
                    Icon(
                      tipoIcono,
                      color: Colors.white,
                      size: 19, 
                    ),
                  ],
                ),
                // Círculo de poder
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                  child: Center(
                    child: Text(
                      '${cartaDetalle.poder}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ZigZagPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.brown[700]!
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke;

    final path = Path();
    const waveHeight = 30.0;
    const waveLength = 80.0;

    for (double x = 0; x < size.width; x += waveLength) {
      final y = (x ~/ waveLength).isEven ? waveHeight : -waveHeight;
      path.lineTo(x, size.height * 0.5 + y);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

void main() {
  runApp(const MaterialApp(home: CampoBatalla(tipoMazo: 'Caballeros')));
}