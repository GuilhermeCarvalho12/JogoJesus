import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JESUS: Além do Impossível',
      debugShowCheckedModeBanner: false,
      home: const MenuScreen(),
    );
  }
}

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  bool somLigado = true;
  double volume = 0.5;
  String dificuldade = 'Médio';
  final AudioPlayer _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _carregarConfiguracoes();
  }

  Future<void> _carregarConfiguracoes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      dificuldade = prefs.getString('dificuldade') ?? 'Médio';
      somLigado = prefs.getBool('somLigado') ?? true;
      volume = prefs.getDouble('volume') ?? 0.5;
    });

    if (somLigado) {
      _tocarMusica();
    }
    await _player.setVolume(volume);
  }

  Future<void> _tocarMusica() async {
    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.play(AssetSource('sounds/musica_fundo.ogg'));
  }

  Future<void> _pararMusica() async {
    await _player.stop();
  }

  Future<void> _alternarSom() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      somLigado = !somLigado;
    });
    await prefs.setBool('somLigado', somLigado);

    if (somLigado) {
      _tocarMusica();
    } else {
      _pararMusica();
    }
  }

  Future<void> _ajustarVolume(double novoVolume) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      volume = novoVolume;
    });
    await prefs.setDouble('volume', novoVolume);
    await _player.setVolume(novoVolume);
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/fundo_menu.png',
              fit: BoxFit.cover,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 200.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 550),
                    _menuButton('Jogar ($dificuldade)', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              JogarScreen(dificuldade: dificuldade),
                        ),
                      );
                    }),
                    const SizedBox(height: 30),
                    _menuButton('Opções', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OpcoesScreen(),
                        ),
                      ).then((_) => _carregarConfiguracoes());
                    }),
                    const SizedBox(height: 30),
                    _menuButton('Créditos', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreditosScreen(),
                        ),
                      );
                    }),
                    const SizedBox(height: 30),
                    _menuButton('Sair', () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Sair'),
                          content: const Text('Tem certeza de que quer sair?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () {
                                exit(0);
                              },
                              child: const Text(
                                'Sim',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 150.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 590),
                    _menuButton(
                        somLigado ? 'Som: Ligado' : 'Som: Desligado', () {
                      _alternarSom();
                    }),
                    const SizedBox(height: 30),
                    _menuButton('Ajustar Volume', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AjustarVolumeScreen(
                            volume: volume,
                            onVolumeChanged: _ajustarVolume,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _menuButton(String texto, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white.withOpacity(0.85),
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 60),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontSize: 36, fontWeight: FontWeight.w700),
        minimumSize: const Size(450, 90),
      ),
      child: Text(texto),
    );
  }
}

class AjustarVolumeScreen extends StatefulWidget {
  final double volume;
  final ValueChanged<double> onVolumeChanged;

  const AjustarVolumeScreen({
    super.key,
    required this.volume,
    required this.onVolumeChanged,
  });

  @override
  State<AjustarVolumeScreen> createState() => _AjustarVolumeScreenState();
}

class _AjustarVolumeScreenState extends State<AjustarVolumeScreen> {
  late double _volumeAtual;

  @override
  void initState() {
    super.initState();
    _volumeAtual = widget.volume;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voltar')),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/imagem_opcoes.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Ajuste o volume do som:',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Slider(
                  value: _volumeAtual,
                  min: 0.0,
                  max: 1.0,
                  divisions: 10,
                  label: (_volumeAtual * 100).toStringAsFixed(0) + '%',
                  onChanged: (newVolume) {
                    setState(() {
                      _volumeAtual = newVolume;
                    });
                    widget.onVolumeChanged(newVolume);
                  },
                ),
                Text(
                  'Volume: ${(_volumeAtual * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class JogarScreen extends StatelessWidget {
  final String dificuldade;

  const JogarScreen({super.key, required this.dificuldade});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voltar')),
      body: Center(
        child: Text(
          'Jogo iniciado no modo $dificuldade!',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class OpcoesScreen extends StatefulWidget {
  const OpcoesScreen({super.key});

  @override
  State<OpcoesScreen> createState() => _OpcoesScreenState();
}

class _OpcoesScreenState extends State<OpcoesScreen> {
  String dificuldade = 'Médio';
  bool mostrarDificuldade = false;

  @override
  void initState() {
    super.initState();
    _carregarDificuldade();
  }

  Future<void> _carregarDificuldade() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      dificuldade = prefs.getString('dificuldade') ?? 'Médio';
    });
  }

  Future<void> _salvarDificuldade(String novaDificuldade) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('dificuldade', novaDificuldade);
    setState(() {
      dificuldade = novaDificuldade;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voltar')),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/imagem_opcoes.png',
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 30.0, top: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _menuButton('Tutorial', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TutorialScreen(),
                      ),
                    );
                  }),
                  const SizedBox(height: 30),
                  _menuButton('Escolher Nível de Dificuldade', () {
                    setState(() {
                      mostrarDificuldade = true;
                    });
                  }),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: mostrarDificuldade
                ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Escolha o modo de dificuldade:',
                  style: TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                _menuButton('Fácil', () => _salvarDificuldade('Fácil')),
                const SizedBox(height: 20),
                _menuButton('Médio', () => _salvarDificuldade('Médio')),
                const SizedBox(height: 20),
                _menuButton(
                    'Difícil', () => _salvarDificuldade('Difícil')),
                const SizedBox(height: 40),
                Text(
                  'Modo de Dificuldade: $dificuldade',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _menuButton(String texto, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white.withOpacity(0.85),
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 60),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontSize: 36, fontWeight: FontWeight.w700),
        minimumSize: const Size(450, 90),
      ),
      child: Text(texto),
    );
  }
}

class CreditosScreen extends StatelessWidget {
  const CreditosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voltar')),
      body: SizedBox.expand(
        child: Image.asset(
          'assets/images/Creditos_oficial.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class TutorialScreen extends StatelessWidget {
  const TutorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voltar')),
      body: SizedBox.expand(
        child: Image.asset(
          'assets/images/tutorial_oficial.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
