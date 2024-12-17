import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'campo_batalla.dart';

class PantallaSeleccionMazo extends StatefulWidget {
  const PantallaSeleccionMazo({super.key});

  @override
  _PantallaSeleccionMazoState createState() => _PantallaSeleccionMazoState();
}

class _PantallaSeleccionMazoState extends State<PantallaSeleccionMazo> with SingleTickerProviderStateMixin {
  late AnimationController _coinController;
  late Animation<double> _coinAnimation;
  bool _isFlipping = false;
  String _resultado = '';
  String _coinText = 'LANZAR';

  @override
  void initState() {
    super.initState();
    _coinController = AnimationController(
      duration: const Duration(seconds: 4), // Aumentamos la duración
      vsync: this,
    )..addListener(() {
        // Cambiar texto durante la animación
        if (_coinController.value > 0.5 && _coinText == 'LANZAR') {
          setState(() {
            _coinText = 'GIRANDO';
          });
        }
      });

    _coinAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: 1), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1, end: 2), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 2, end: 3), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 3, end: 4), weight: 1),
    ]).animate(
      CurvedAnimation(
        parent: _coinController,
        curve: Curves.easeInOut,
      ),
    );

    _coinController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isFlipping = false;
          _resultado = Random().nextBool() ? 'Monstruos' : 'Caballeros';
          _coinText = _resultado;
        });
      }
    });
  }

  void _lanzarMoneda() {
    if (!_isFlipping) {
      setState(() {
        _isFlipping = true;
        _resultado = '';
        _coinText = 'GIRANDO';
      });
      _coinController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _coinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[900],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Selección de Mazo',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: _lanzarMoneda,
                child: AnimatedBuilder(
                  animation: _coinAnimation,
                  builder: (context, child) {
                    return Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(_coinAnimation.value * pi),
                      child: Container(
                        width: 250,
                        height: 250,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.yellow[700]!,
                              Colors.yellow[900]!,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.7),
                              spreadRadius: 5,
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            _coinText,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.brown[900],
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 40),
              if (_resultado.isNotEmpty)
                Text(
                  'Mazo seleccionado: $_resultado',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              const SizedBox(height: 40),
              if (_resultado.isNotEmpty)
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CampoBatalla(
                          tipoMazo: _resultado,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Comenzar Juego',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}