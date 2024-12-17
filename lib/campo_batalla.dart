import 'package:flutter/material.dart';
import 'repartir_cartas.dart';
import 'dart:math';
import 'main.dart';

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
  bool isCPUTurn = false;
  bool isGameOver = false;
  int playerLives = 2;
  int cpuLives = 2;
  int currentRound = 1;
  bool _cpuHasPassed = false;
  bool _playerHasPassed = false;

  @override
  void initState() {
    super.initState();
    repartirCartas.repartir(widget.tipoMazo);

    setState(() {
      cartasEnCampoJugador = List.from(repartirCartas.cartasJugador);
      cartasEnCampoContrincante = List.from(repartirCartas.cartasContrincante);
      isCPUTurn = Random().nextBool();

      // Mostrar modal al inicio del juego
      _mostrarModal(
        titulo: 'Inicio del Juego',
        mensaje: isCPUTurn
            ? 'El CPU inicia el juego. Espera su jugada.'
            : 'Es tu turno. ¡Haz tu mejor jugada!',
        onClose: () {
          if (isCPUTurn) {
            _cpuTurn();
          }
        },
      );
    });
  }

  void _mostrarModalSalir() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.brown[700],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.brown[900]!, width: 4),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Salir del Juego',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '¿Estás seguro de que quieres salir? Se perderá el progreso actual.',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        // Cerrar el modal
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[800],
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        // Cerrar todos los modales
                        _cerrarTodosLosModales();
                        
                        // Navegar a la pantalla principal (main.dart)
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => const MyCardGameApp()), 
                          (Route<dynamic> route) => false
                        );
                      },
                      child: const Text(
                        'Salir',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _cerrarTodosLosModales() {
    Navigator.of(context, rootNavigator: true).popUntil((route) => route.isFirst);
  }

  void _cpuTurn() {
    // Si el CPU ya pasó, no hace nada
    if (_cpuHasPassed) {
      _mostrarModal(
        titulo: 'El CPU ha pasado',
        mensaje: 'El contrincante no jugará más cartas en esta ronda.',
        onClose: () => _endRoundIfBothPassed(),
      );
      return;
    }

    int cpuTotalPower = _calculateTotalPower(true);
    int playerTotalPower = _calculateTotalPower(false);

    // Si el jugador ha pasado, el CPU debe decidir si jugar o pasar
    if (_playerHasPassed) {
      if (cartasEnCampoContrincante.isEmpty || cpuTotalPower > playerTotalPower) {
        // Si no tiene cartas o ya superó al jugador, pasa
        _cpuHasPassed = true;
        _mostrarModal(
          titulo: 'El CPU ha pasado',
          mensaje: 'El contrincante no jugará más cartas en esta ronda.',
          onClose: () => _endRoundIfBothPassed(),
        );
      return;
      } else {
        // Selecciona una carta y juega para intentar superar
        String selectedCard = _selectBestCPUCard();
        List<String> targetRow = _selectBestCPURow(selectedCard);

        Future.delayed(Duration(seconds: 1), () {
          setState(() {
            cartasEnCampoContrincante.remove(selectedCard);
            targetRow.add(selectedCard);
          });
          // Llama recursivamente después de jugar
          _cpuTurn();
        });
      }
      return;
    }

    // Lógica habitual si el jugador no ha pasado
    if (cartasEnCampoContrincante.isEmpty) {
      isCPUTurn = false;
      _cpuHasPassed = true;
      _mostrarModal(
        titulo: 'El CPU ha pasado',
        mensaje: 'El contrincante no jugará más cartas en esta ronda.',
        onClose: () => _endRoundIfBothPassed(),
      );
      return;
    }

    // Si el CPU tiene clara ventaja, pasa
    if (cpuTotalPower > playerTotalPower + 10) {
      _cpuHasPassed = true;
      _mostrarModal(
        titulo: 'El CPU ha pasado',
        mensaje: 'El contrincante no jugará más cartas en esta ronda.',
        onClose: () => _endRoundIfBothPassed(),
      );
      return;
    }

    // Si el CPU tiene menos cartas y no puede superar al jugador, pasa
    if (cartasEnCampoContrincante.length < cartasEnCampoJugador.length &&
        cpuTotalPower <= playerTotalPower) {
      _cpuHasPassed = true;
      _mostrarModal(
        titulo: 'El CPU ha pasado',
        mensaje: 'El contrincante no jugará más cartas en esta ronda.',
        onClose: () => _endRoundIfBothPassed(),
      );
      return;
    }

    // Si está perdiendo significativamente, debe jugar una carta
    if (playerTotalPower > cpuTotalPower + 10 || !_cpuHasPassed) {
      String selectedCard = _selectBestCPUCard();
      List<String> targetRow = _selectBestCPURow(selectedCard);

      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          cartasEnCampoContrincante.remove(selectedCard);
          targetRow.add(selectedCard);
          isCPUTurn = false;
        });
      });
    } else {
      // Si no puede superar al jugador de forma lógica, pasa
      _cpuHasPassed = true;
      _mostrarModal(
        titulo: 'El CPU ha pasado',
        mensaje: 'El contrincante no jugará más cartas en esta ronda.',
        onClose: () => _endRoundIfBothPassed(),
      );
    }
  }

  void _endRoundIfBothPassed() {
    if (_cpuHasPassed && _playerHasPassed) {
      _endRound();
    }
  }

  String _selectBestCPUCard() {
    // Simple card selection strategy
    return cartasEnCampoContrincante[Random().nextInt(cartasEnCampoContrincante.length)];
  }

  List<String> _selectBestCPURow(String card) {
    final cartaDetalle = repartirCartas.obtenerCartaPorId(card);
    
    // Select appropriate row based on card type
    switch (cartaDetalle.tipo) {
      case TipoCarta.castillo:
        return cartasEnCampoRojot;
      case TipoCarta.security:
        return cartasEnCampoRojoa;
      case TipoCarta.sword:
        return cartasEnCampoRojoc;
    }
  }

  void _endRound() {
    int playerTotalPower = _calculateTotalPower(false);
    int cpuTotalPower = _calculateTotalPower(true);

    setState(() {
      String mensaje;
      if (playerTotalPower > cpuTotalPower) {
        cpuLives--;
        mensaje = '¡Ganaste la ronda! El contrincante pierde una vida.';
      } else if (cpuTotalPower > playerTotalPower) {
        playerLives--;
        mensaje = 'Perdiste la ronda. Tú pierdes una vida.';
      } else {
        cpuLives--;
        playerLives--;
        mensaje = '¡Empate! Ambos pierden una vida.';
      }

      _mostrarModal(
        titulo: 'Resultado de la Ronda',
        mensaje: mensaje,
        onClose: () {
          if (playerLives <= 0 || cpuLives <= 0) {
            _endGame();
          } else {
            _resetBoardForNewRound();
          }
        },
      );
    });
  }

  void _resetBoardForNewRound() {
    setState(() {
      // Limpiar campos de cartas
      cartasEnCampoRojot.clear();
      cartasEnCampoRojoa.clear();
      cartasEnCampoRojoc.clear();
      cartasEnCampoVerdet.clear();
      cartasEnCampoVerdea.clear();
      cartasEnCampoVerdec.clear();

      // Resetear estados de paso
      _cpuHasPassed = false;
      _playerHasPassed = false;

      // Incrementar número de ronda
      currentRound++;

      // Decidir turno inicial aleatoriamente
      isCPUTurn = Random().nextBool();

      // Mostrar modal de inicio de turno
      _mostrarModal(
        titulo: 'Inicio de la Ronda $currentRound',
        mensaje: isCPUTurn
            ? 'Es el turno del CPU. Espera su jugada.'
            : 'Es tu turno. ¡Haz tu mejor jugada!',
        onClose: () {
          if (isCPUTurn) {
            _cpuTurn();
          }
        },
      );
    });
  }

  void _endGame() {
    setState(() {
      isGameOver = true;
    });

    // Determinar el resultado del juego
    String titulo;
    String mensaje;

    if (playerLives <= 0 && cpuLives <= 0) {
      // Caso de empate
      titulo = '¡Empate!';
      mensaje = 'Ambos jugadores han perdido todas sus vidas.\nResultado final: Empate';
    } else if (playerLives > 0) {
      titulo = '¡Ganaste!';
      mensaje = 'Resultado final: Jugador $playerLives - CPU $cpuLives.\nGracias por jugar.';
    } else {
      titulo = '¡Perdiste!';
      mensaje = 'Resultado final: Jugador $playerLives - CPU $cpuLives.\nGracias por jugar.';
    }

    _mostrarModal(
      titulo: titulo,
      mensaje: mensaje,
      onClose: () {
        // Navegar a la pantalla principal usando pushAndRemoveUntil
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const MyCardGameApp()), 
          (Route<dynamic> route) => false
        );
      },
    );
  }

  int _calcularPoderFila(List<String> cartasEnFila) {
    // Contar cuántas cartas hay de cada tipo
    int castilloCount = cartasEnFila.where((carta) => 
      repartirCartas.obtenerCartaPorId(carta).tipo == TipoCarta.castillo).length;
    int securityCount = cartasEnFila.where((carta) => 
      repartirCartas.obtenerCartaPorId(carta).tipo == TipoCarta.security).length;
    int swordCount = cartasEnFila.where((carta) => 
      repartirCartas.obtenerCartaPorId(carta).tipo == TipoCarta.sword).length;

    // Calculamos el poder base de la fila
    int poderBase = cartasEnFila.isEmpty 
      ? 0 
      : cartasEnFila
          .map((carta) => repartirCartas.obtenerCartaPorId(carta).poder)
          .reduce((a, b) => a + b);

    // Aplicamos bonus si hay 3 o más cartas del mismo tipo
    int poderBonus = 0;
    if (castilloCount >= 3) {
      poderBonus += castilloCount;
    }
    if (securityCount >= 3) {
      poderBonus += securityCount;
    }
    if (swordCount >= 3) {
      poderBonus += swordCount;
    }

    return poderBase + poderBonus;
  }

  // Método modificado para calcular el poder total con las filas individuales
  int _calculateTotalPower(bool isCPU) {
    int poderRojot, poderRojoa, poderRojoc;
    int poderVerdet, poderVerdea, poderVerdec;

    if (isCPU) {
      poderRojot = _calcularPoderFila(cartasEnCampoRojot);
      poderRojoa = _calcularPoderFila(cartasEnCampoRojoa);
      poderRojoc = _calcularPoderFila(cartasEnCampoRojoc);
      
      return poderRojot + poderRojoa + poderRojoc;
    } else {
      poderVerdet = _calcularPoderFila(cartasEnCampoVerdet);
      poderVerdea = _calcularPoderFila(cartasEnCampoVerdea);
      poderVerdec = _calcularPoderFila(cartasEnCampoVerdec);
      
      return poderVerdet + poderVerdea + poderVerdec;
    }
  }

  void _passTurn() {
    setState(() {
      _playerHasPassed = true;
      isCPUTurn = true;
    });
    // Si el CPU no ha pasado, le toca jugar
    if (!_cpuHasPassed) {
      _cpuTurn();
    } else {
      _endRound();
    }
  }

  void _mostrarModal({
    required String titulo,
    required String mensaje,
    required VoidCallback onClose,
    bool delay = false,
  }) {
    Future.delayed(
      delay ? const Duration(seconds: 2) : Duration.zero,
      () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.brown[700],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.brown[900]!, width: 4),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      titulo,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      mensaje,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown[800],
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        onClose();
                      },
                      child: const Text(
                        'Cerrar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  int _calcularPoderConBonus(List<String> cartasEnFila) {
    // Contar cuántas cartas hay de cada tipo
    int castilloCount = cartasEnFila.where((carta) => 
      repartirCartas.obtenerCartaPorId(carta).tipo == TipoCarta.castillo).length;
    int securityCount = cartasEnFila.where((carta) => 
      repartirCartas.obtenerCartaPorId(carta).tipo == TipoCarta.security).length;
    int swordCount = cartasEnFila.where((carta) => 
      repartirCartas.obtenerCartaPorId(carta).tipo == TipoCarta.sword).length;

    // Calculamos el poder base de la fila
    int poderTotal = cartasEnFila.isEmpty 
      ? 0 
      : cartasEnFila
          .map((carta) => repartirCartas.obtenerCartaPorId(carta).poder)
          .reduce((a, b) => a + b);

    // Aplicamos bonus si hay 3 o más cartas del mismo tipo
    if (castilloCount >= 3) {
      poderTotal += cartasEnFila
        .where((carta) => repartirCartas.obtenerCartaPorId(carta).tipo == TipoCarta.castillo)
        .length;
    }
    if (securityCount >= 3) {
      poderTotal += cartasEnFila
        .where((carta) => repartirCartas.obtenerCartaPorId(carta).tipo == TipoCarta.security)
        .length;
    }
    if (swordCount >= 3) {
      poderTotal += cartasEnFila
        .where((carta) => repartirCartas.obtenerCartaPorId(carta).tipo == TipoCarta.sword)
        .length;
    }

    return poderTotal;
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
              onTap: () => _mostrarModalSalir(),
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
      poderTotal = _calcularPoderFila(cartasEnCampoRojot) +
                  _calcularPoderFila(cartasEnCampoRojoa) +
                  _calcularPoderFila(cartasEnCampoRojoc);
    } else if (nombre == 'Jugador Actual') {
      poderTotal = _calcularPoderFila(cartasEnCampoVerdet) +
                  _calcularPoderFila(cartasEnCampoVerdea) +
                  _calcularPoderFila(cartasEnCampoVerdec);
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
            ],
          ),
        ],
        if (nombre == 'Jugador Actual') ...[
          const SizedBox(height: 8),
          // Botón de Pasar
          IconButton(
            onPressed: _passTurn,
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
    int lives = isOpponent ? cpuLives : playerLives;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(2, (index) {
        return Container(
          width: 20,
          height: 20,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            color: index < lives ? Colors.red[700] : Colors.white, // Color según las vidas
          ),
        );
      }),
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
    int poderTotal = _calcularPoderFila(cartasEnCampo);

    // Determinar si hay bonus activo
    bool hayBonus = false;
    int castilloCount = cartasEnCampo.where((carta) => 
      repartirCartas.obtenerCartaPorId(carta).tipo == TipoCarta.castillo).length;
    int securityCount = cartasEnCampo.where((carta) => 
      repartirCartas.obtenerCartaPorId(carta).tipo == TipoCarta.security).length;
    int swordCount = cartasEnCampo.where((carta) => 
      repartirCartas.obtenerCartaPorId(carta).tipo == TipoCarta.sword).length;

    // Verificar si algún tipo tiene 3 o más cartas
    if (castilloCount >= 3 || securityCount >= 3 || swordCount >= 3) {
      hayBonus = true;
    }

    return DragTarget<String>(
      onWillAccept: (data) {
        // Si es rojo, no se puede colocar carta
        if (esRojo) return false;
        if (_playerHasPassed) return false;
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
          if (!_cpuHasPassed) {
            _cpuTurn();
            isCPUTurn = true;
          } else if (cartasEnCampoJugador.isEmpty) {
            _passTurn();
            isCPUTurn = true;
            if (!_cpuHasPassed) {
              _cpuTurn();
            }
          }
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
              color: hayBonus ? Colors.yellow[500]! : Colors.brown[800]!,
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
                        border: Border.all(color: hayBonus ? Colors.yellow[500]! : Colors.brown[800]!, width: 2),
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

    // Determinar si es una carta del contrincante o del jugador
    bool esCartaContrincante = cartasEnCampoContrincante.contains(carta);

    // Si es una carta del contrincante y no está en el campo de batalla, mostrar el reverso
    if (esCartaContrincante && !_cartaEstaEnCampoDeBatalla(carta)) {
      return Container(
        margin: const EdgeInsets.all(8.0),
        width: 70,
        height: 100,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.brown[800]!, width: 2),
          image: const DecorationImage(
            image: AssetImage('assets/images/card_back.png'), // Asegúrate de tener esta imagen
            fit: BoxFit.cover,
          ),
        ),
      );
    }

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

  // Método auxiliar para verificar si una carta está en el campo de batalla
  bool _cartaEstaEnCampoDeBatalla(String carta) {
    return cartasEnCampoRojot.contains(carta) ||
          cartasEnCampoRojoa.contains(carta) ||
          cartasEnCampoRojoc.contains(carta);
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
