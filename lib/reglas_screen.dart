import 'package:flutter/material.dart';

class ReglasScreen extends StatelessWidget {
  const ReglasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reglas del Juego'),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildSectionTitle('Objetivo del Juego'),
            _buildSectionContent('El objetivo es ganar dos de tres rondas. Cada ronda se gana acumulando más puntos que el oponente jugando cartas estratégicamente.'),
            _buildSectionTitle('Preparación del Juego'),
            _buildSectionContent('Mazo: Cada jugador debe tener un mazo compuesto por un mínimo de 20 cartas, incluyendo cartas de unidades, proteccion y asedio.'),
            _buildSectionContent('Vidas: Cada jugador al iniciar la partida tendra 2 contenedores de vida lo cuales representan el estado del juego.'),
            _buildSectionTitle('Inicio de la Partida'),
            _buildSectionContent('Mano Inicial: Ambos jugadores roban 10 cartas al comienzo de la partida. Las cartas sera entregadas de forma aleatoria.'),
            _buildSectionContent('Rondas: El juego se divide en tres rondas. El jugador que gane dos de las tres rondas gana el juego.'),
            _buildSectionTitle('Mecánicas de Juego'),
            _buildSectionContent('Turnos: Los jugadores se alternan para jugar una carta de su mano. Una vez jugada la carta, solo se puede invocar en el tipo de campo adecuado.'),
            _buildSectionContent('Pasar: Un jugador puede pasar su turno, decidiendo no jugar más cartas en esa ronda. El otro jugador puede continuar jugando cartas hasta que también pase.'),
            _buildSectionTitle('Tipos de Cartas y Efectos'),
            _buildSectionContent('Cartas de Unidades: Tienen valores de fuerza y se colocan en filas de cuerpo a cuerpo.'),
            _buildSectionContent('Seguridad: Producen ataques a distancia al ser jugados, como dañar a las unidades enemigas.'),
            _buildSectionContent('Asedio: Son cartas especiales tienen fuerza de combate Moderada.'),
            _buildSectionContent('Condiciones de Clima: Algunas cartas pueden alterar las condiciones del tablero, afectando el poder de las unidades en ciertas filas.'),
            _buildSectionTitle('Final de la Ronda'),
            _buildSectionContent('Puntuación: Al final de la ronda, se suman los puntos de fuerza de las unidades en el tablero. El jugador con más puntos gana la ronda.'),
            _buildSectionContent('Empate: Si hay un empate en puntos, la ronda queda empatada, pero se siguen jugando las siguientes rondas hasta determinar un ganador.'),
            _buildSectionTitle('Cartas Especiales y Estrategias'),
            _buildSectionContent('Sinergias de Cartas: tener tres o mas cartas de un mismo tipo en el campo de batalla, potencian sus efectos mutuos al aumentar su ataque en 1 por cada carta.'),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.green[800],
        ),
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        content,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.black87,
        ),
      ),
    );
  }
}