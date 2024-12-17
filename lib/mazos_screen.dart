import 'package:flutter/material.dart';

class MazosScreen extends StatelessWidget {
  const MazosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> caballerosImages = [
      'assets/images/caballeros/Bronce1.jpg',
      'assets/images/caballeros/Bronce2.jpg',
      'assets/images/caballeros/Bronce3.jpg',
      'assets/images/caballeros/Bronce4.jpg',
      'assets/images/caballeros/Bronce5.jpg',
      'assets/images/caballeros/Bronce6.jpg',
      'assets/images/caballeros/Bronce7.jpg',
      'assets/images/caballeros/Bronce8.jpg',
      'assets/images/caballeros/Bronce9.jpg',
      'assets/images/caballeros/Bronce11.jpg',
      'assets/images/caballeros/Bronce12.jpg',
      'assets/images/caballeros/Oro 1.jpg',
      'assets/images/caballeros/Oro 2.jpg',
      'assets/images/caballeros/Oro 3.jpg',
      'assets/images/caballeros/Oro 4.jpg',
      'assets/images/caballeros/Plata 1.jpg',
      'assets/images/caballeros/Plata 2.jpg',
      'assets/images/caballeros/Plata 3.jpg',
      'assets/images/caballeros/Plata 6.jpg',
      'assets/images/caballeros/Plata 8.jpg',
    ];

    final List<String> monstruosImages = [
      'assets/images/monstruos/Bronce1.jpg',
      'assets/images/monstruos/Bronce4.jpg',
      'assets/images/monstruos/Bronce5.jpg',
      'assets/images/monstruos/Bronce6.jpg',
      'assets/images/monstruos/Bronce7.jpg',
      'assets/images/monstruos/Bronce8.jpg',
      'assets/images/monstruos/Bronce9.jpg',
      'assets/images/monstruos/Bronce10.jpg',
      'assets/images/monstruos/Bronce11.jpg',
      'assets/images/monstruos/Bronce12.jpg',
      'assets/images/monstruos/Bronce13.jpg',
      'assets/images/monstruos/Bronce14.jpg',
      'assets/images/monstruos/Oro 1.jpg',
      'assets/images/monstruos/Oro 3.jpg',
      'assets/images/monstruos/Oro 4.jpg',
      'assets/images/monstruos/Plata 2.jpg',
      'assets/images/monstruos/Plata 3.jpg',
      'assets/images/monstruos/Plata 4.jpg',
      'assets/images/monstruos/Plata 5.jpg',
      'assets/images/monstruos/Plata 6.jpg',
    ];

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
            _buildTabContent(caballerosImages),
            _buildTabContent(monstruosImages),
          ],
        ),
        backgroundColor: Colors.brown[900],
      ),
    );
  }

  Widget _buildTabContent(List<String> images) {
    final List<String> oroImages = images.where((img) => img.contains('Oro')).toList();
    final List<String> plataImages = images.where((img) => img.contains('Plata')).toList();
    final List<String> bronceImages = images.where((img) => img.contains('Bronce')).toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategoryHeader('Oro', oroImages.length, Colors.amber),
          const SizedBox(height: 10),
          _buildImageRow(oroImages, Colors.amber),
          const SizedBox(height: 20),
          _buildCategoryHeader('Plata', plataImages.length, Colors.grey),
          const SizedBox(height: 10),
          _buildImageRow(plataImages, Colors.grey),
          const SizedBox(height: 20),
          _buildCategoryHeader('Bronce', bronceImages.length, Colors.brown),
          const SizedBox(height: 10),
          _buildImageRow(bronceImages, Colors.brown),
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
            shadows: [
              Shadow(
                blurRadius: 10.0,
                color: Colors.black,
                offset: Offset(2.0, 2.0),
              ),
            ],
          ),
        ),
        Text(
          '$count cartas',
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildImageRow(List<String> images, Color borderColor) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: HoverImage(imagePath: images[index], borderColor: borderColor),
          );
        },
      ),
    );
  }
}

class HoverImage extends StatefulWidget {
  final String imagePath;
  final Color borderColor;

  const HoverImage({required this.imagePath, required this.borderColor, super.key});

  @override
  _HoverImageState createState() => _HoverImageState();
}

class _HoverImageState extends State<HoverImage> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        transform: _isHovered ? Matrix4.identity().scaled(1.2) : Matrix4.identity(),
        decoration: BoxDecoration(
          border: Border.all(color: widget.borderColor, width: 3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(widget.imagePath),
        ),
      ),
    );
  }

  void _onHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
  }
}