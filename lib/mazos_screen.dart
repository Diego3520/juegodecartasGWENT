import 'package:flutter/material.dart';
import 'repartir_cartas.dart';

class MazosScreen extends StatelessWidget {
  const MazosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RepartirCartas repartirCartas = RepartirCartas();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Mazos',
            style: TextStyle(color: Colors.white),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Caballeros'),
              Tab(text: 'Monstruos'),
            ],
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.amber,
          ),
          backgroundColor: Colors.brown[500],
        ),
        body: TabBarView(
          children: [
            _buildTabContent(context, repartirCartas.mazoCaballeros),
            _buildTabContent(context, repartirCartas.mazoMonstruos),
          ],
        ),
        backgroundColor: Colors.brown[900],
      ),
    );
  }

  Widget _buildTabContent(BuildContext context, List<Carta> mazo) {
    final List<Carta> oroCartas = mazo.where((c) => c.artwork.contains('Oro')).toList();
    final List<Carta> plataCartas = mazo.where((c) => c.artwork.contains('Plata')).toList();
    final List<Carta> bronceCartas = mazo.where((c) => c.artwork.contains('Bronce')).toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategoryHeader('Oro', oroCartas.length, Colors.amber),
          const SizedBox(height: 10),
          _buildImageRow(context, oroCartas),
          const SizedBox(height: 20),
          _buildCategoryHeader('Plata', plataCartas.length, Colors.grey),
          const SizedBox(height: 10),
          _buildImageRow(context, plataCartas),
          const SizedBox(height: 20),
          _buildCategoryHeader('Bronce', bronceCartas.length, Colors.brown),
          const SizedBox(height: 10),
          _buildImageRow(context, bronceCartas),
        ],
      ),
    );
  }

  Widget _buildCategoryHeader(String title, int count, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          '$count cartas',
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildImageRow(BuildContext context, List<Carta> cartas) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: cartas.length,
        itemBuilder: (context, index) {
          final carta = cartas[index];
          return GestureDetector(
            onTap: () => _mostrarDetallesCarta(context, carta),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              width: 100,
              decoration: BoxDecoration(
                border: Border.all(color: _getBorderColor(carta), width: 3),
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage(carta.artwork),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  // Icono del tipo de carta en la esquina superior izquierda
                  Positioned(
                    top: 4,
                    left: 4,
                    child: Container(
                      padding: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _getTipoIcono(carta.tipo),
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  // Poder de la carta en la esquina superior derecha
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${carta.poder}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
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
    );
  }

  void _mostrarDetallesCarta(BuildContext context, Carta carta) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.brown[800],
          child: Container(
            padding: const EdgeInsets.all(16.0),
            height: 400,
            child: Row(
              children: [
                // Imagen de la carta
                Container(
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: AssetImage(carta.artwork),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Detalles de la carta
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        carta.nombre,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tipo: ${_getTipoCartaDescripcion(carta.tipo)}',
                        style: const TextStyle(color: Colors.white70, fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Poder: ${carta.poder}',
                        style: const TextStyle(color: Colors.white70, fontSize: 18),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Descripción:',
                        style: TextStyle(color: Colors.amber, fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getDescripcionPorTipo(carta.tipo),
                        style: const TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getTipoCartaDescripcion(TipoCarta tipo) {
    switch (tipo) {
      case TipoCarta.castillo:
        return 'Asedio (Castle)';
      case TipoCarta.security:
        return 'Protección (Security)';
      case TipoCarta.sword:
        return 'Cuerpo a Cuerpo (Sword)';
      default:
        return 'Desconocido';
    }
  }

  String _getDescripcionPorTipo(TipoCarta tipo) {
    switch (tipo) {
      case TipoCarta.castillo:
        return 'Carta defensiva perteneciente a mazos estratégicos de asedio.';
      case TipoCarta.security:
        return 'Carta de protección que refuerza la defensa de tu mazo.';
      case TipoCarta.sword:
        return 'Carta de ataque directo ideal para eliminar adversarios.';
      default:
        return 'Descripción no disponible.';
    }
  }

  IconData _getTipoIcono(TipoCarta tipo) {
  switch (tipo) {
    case TipoCarta.castillo:
      return Icons.castle; // Icono de castillo
    case TipoCarta.security:
      return Icons.security; // Icono de seguridad
    case TipoCarta.sword:
      return Icons.person; // Icono de cuerpo a cuerpo
    default:
      return Icons.help_outline; // Icono por defecto
  }
}

  Color _getBorderColor(Carta carta) {
    if (carta.artwork.contains('Oro')) return Colors.amber;
    if (carta.artwork.contains('Plata')) return Colors.grey;
    return Colors.brown;
  }
}