import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  void _toggleTheme() => setState(() => _isDarkMode = !_isDarkMode);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Counter & Dog/Cat Toggle',
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: HomeScreen(toggleTheme: _toggleTheme),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  final VoidCallback toggleTheme;

  const HomeScreen({Key? key, required this.toggleTheme}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _counter = 0;
  bool _showDog = true;

  late final AnimationController _controller;
  late final Animation<double> _animation;

  final String _dogAsset = 'assets/images/dog.png';
  final String _catAsset = 'assets/images/cat.png';

  final String _dogNetwork =
      'https://images.unsplash.com/photo-1546182990-dffeafbe841d?w=800&q=80';
  final String _catNetwork =
      'https://images.unsplash.com/photo-1518791841217-8f162f1e1131?w=800&q=80';

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _controller.value = 1.0; 
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _incrementCounter() => setState(() => _counter++);

  void _toggleImage() {
    setState(() {
      _showDog = !_showDog;
    });
    _controller.forward(from: 0.0);
  }

  Widget _buildImage() {
    return FadeTransition(
      opacity: _animation,
      child: Image.asset(
        _showDog ? _dogAsset : _catAsset,
        height: 200,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Image.network(
            _showDog ? _dogNetwork : _catNetwork,
            height: 200,
            fit: BoxFit.contain,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Counter & Dog/Cat Toggle')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
        child: Center(
          child: Column(
            children: [
              // Counter
              Text('Counter: $_counter', style: theme.textTheme.headlineMedium),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _incrementCounter,
                child: const Text('Increment'),
              ),
              const SizedBox(height: 32),

              // Dog/Cat image
              _buildImage(),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _toggleImage,
                child: const Text('Toggle Image (Dog / Cat)'),
              ),
              const SizedBox(height: 24),

              // Theme toggle
              ElevatedButton(
                onPressed: widget.toggleTheme,
                child: const Text('Toggle Light / Dark'),
              ),
              const SizedBox(height: 12),
              Text(
                'Currently showing: ${_showDog ? "Dog" : "Cat"}',
                style: theme.textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
