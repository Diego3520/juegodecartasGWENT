import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pantalla_mazo.dart';
import 'help_modal.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const MyCardGameApp());
}

class MyCardGameApp extends StatelessWidget {
  const MyCardGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gwent',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        fontFamily: 'Cinzel',
      ),
      home: const InicioPantalla(),
    );
  }
}

class InicioPantalla extends StatefulWidget {
  const InicioPantalla({super.key});

  @override
  _InicioPantallaState createState() => _InicioPantallaState();
}

class _InicioPantallaState extends State<InicioPantalla> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20), // Increased duration for smoother movement
      vsync: this,
    )..repeat(reverse: true);

    // Use a more nuanced animation curve
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 1.0, curve: Curves.linear),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  // Background image with horizontal movement
                  image: DecorationImage(
                    image: const AssetImage('assets/images/fondo.jpg'),
                    fit: BoxFit.cover,
                    alignment: FractionalOffset(_animation.value, 0), // Movement along X-axis
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Gwent',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              offset: Offset(2.0, 2.0),
                              blurRadius: 3.0,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      ScaleTransition(
                        scale: Tween<double>(begin: 1.0, end: 1.1).animate(
                          CurvedAnimation(
                            parent: _controller,
                            curve: Curves.easeInOut,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.brown[800],
                            borderRadius: BorderRadius.circular(30.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const PantallaSeleccionMazo()),
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            child: const Text(
                              'JUGAR',
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.help, color: Colors.white, size: 30),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const HelpModal();
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