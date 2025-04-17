import 'package:flutter/material.dart';

class Cenario2Screen extends StatelessWidget {
  final String dificuldade;

  const Cenario2Screen({super.key, required this.dificuldade});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cenário 2 - Multiplicação dos Pães e Peixes'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/peixe1_oficial.png',
            fit: BoxFit.cover,
          ),
          //
        ],
      ),
    );
  }
}
