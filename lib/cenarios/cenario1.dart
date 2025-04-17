import 'package:flutter/material.dart';

class Cenario1Screen extends StatelessWidget {
  final String dificuldade;

  const Cenario1Screen({super.key, required this.dificuldade});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cenário 1 - A Cura do Cego'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/cura1_oficial.png',
            fit: BoxFit.cover,
          ),
          //
        ],
      ),
    );
  }
}
