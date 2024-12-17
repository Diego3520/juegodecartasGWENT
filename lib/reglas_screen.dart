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
            _buildSectionContent('Mazo: Cada jugador debe tener un mazo compuesto por un mínimo de 20 cartas y un máximo de 150 provisiones en total, incluyendo cartas de unidades, hechizos y artefactos.'),
            _buildSectionContent('Líder: Cada jugador elige un líder con habilidades especiales únicas que se pueden usar durante la partida.'),
            _buildSectionContent('Provisión: Cada carta tiene un valor de provisión que contribuye al límite total del mazo.'),
            _buildSectionTitle('Inicio de la Partida'),
            _buildSectionContent('Mano Inicial: Ambos jugadores roban 10 cartas al comienzo de la partida. Pueden hacer mulligans para cambiar hasta tres cartas de su mano inicial.'),
            _buildSectionContent('Rondas: El juego se divide en tres rondas. El jugador que gane dos de las tres rondas gana el juego.'),
            _buildSectionTitle('Mecánicas de Juego'),
            _buildSectionContent('Turnos: Los jugadores se alternan para jugar una carta de su mano. Una vez jugada la carta, su habilidad se resuelve de inmediato.'),
            _buildSectionContent('Pasar: Un jugador puede pasar su turno, decidiendo no jugar más cartas en esa ronda. El otro jugador puede continuar jugando cartas hasta que también pase.'),
            _buildSectionTitle('Tipos de Cartas y Efectos'),
            _buildSectionContent('Cartas de Unidades: Tienen valores de fuerza y se colocan en filas de cuerpo a cuerpo o a distancia.'),
            _buildSectionContent('Hechizos: Producen efectos especiales al ser jugados, como dañar a las unidades enemigas o fortalecer las propias.'),
            _buildSectionContent('Artefactos: Son cartas especiales con habilidades únicas que no tienen fuerza de combate.'),
            _buildSectionContent('Condiciones de Clima: Algunas cartas pueden alterar las condiciones del tablero, afectando el poder de las unidades en ciertas filas.'),
            _buildSectionTitle('Final de la Ronda'),
            _buildSectionContent('Puntuación: Al final de la ronda, se suman los puntos de fuerza de las unidades en el tablero. El jugador con más puntos gana la ronda.'),
            _buildSectionContent('Empate: Si hay un empate en puntos, la ronda queda empatada, pero se siguen jugando las siguientes rondas hasta determinar un ganador.'),
            _buildSectionTitle('Habilidades Especiales y Estrategias'),
            _buildSectionContent('Habilidades de Líder: Cada líder tiene una habilidad especial que puede usarse una vez por ronda.'),
            _buildSectionContent('Sinergias de Cartas: Crear combinaciones de cartas que potencian sus efectos mutuos es clave para ganar.'),
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