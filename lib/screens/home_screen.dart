import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pixi - Home')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.photo, size: 72, color: Colors.deepPurple),
            SizedBox(height: 12),
            Text('Welcome to Pixi', style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
