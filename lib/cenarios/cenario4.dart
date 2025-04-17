import 'package:flutter/material.dart';

class Cenario4Screen extends StatelessWidget {
  final String dificuldade;

  const Cenario4Screen({super.key, required this.dificuldade});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cenário BÔNUS'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/bonus2_oficial.png',
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
