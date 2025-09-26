import 'package:flutter/material.dart';
import 'package:ui_challenges/animation_chain/animation_chain.dart';
import 'package:ui_challenges/physics_widget/physics_simulation.dart';
import 'package:ui_challenges/dismissible_list/task_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UI Challenges',
      home: MainPage()
    );
  }
}


class MainPage extends StatelessWidget {
  const MainPage({super.key});

  void _openPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Page'),
        backgroundColor: Colors.lightBlueAccent,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildNavButton(
              context,
              label: 'Animation Chain',
              page: const AnimationChain(),
            ),
            const SizedBox(height: 20),
            _buildNavButton(
              context,
              label: 'Task Manager',
              page: const TaskManager(),
            ),
            const SizedBox(height: 20),
            _buildNavButton(
              context,
              label: 'Physics Playground',
              page: const PhysicsPlayground(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavButton(BuildContext context,
      {required String label, required Widget page}) {
    return SizedBox(
      width: 220,
      height: 50,
      child: ElevatedButton(
        onPressed: () => _openPage(context, page),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        child: Text(label, style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}
