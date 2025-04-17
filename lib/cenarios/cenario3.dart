import 'package:flutter/material.dart';

class Cenario3Screen extends StatelessWidget {
  final String dificuldade;

  const Cenario3Screen({super.key, required this.dificuldade});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cenário 3 - Água em Vinho'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/vinho2_oficial.png',
            fit: BoxFit.cover,
          ),
          //
        ],
      ),
    );
  }
}
