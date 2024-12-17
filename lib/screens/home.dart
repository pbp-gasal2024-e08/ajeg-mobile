import 'package:ajeg_mobile/review/widgets/rating_panel.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
        child: Column(
          children: [
            FloatingPanel(
              color: Theme.of(context).secondaryHeaderColor,
              children: const RatingPanel(),
            ),
            const SizedBox(height: 20),
            FloatingPanel(
              color: Colors.deepOrange.shade50,
              children: const Text("Panel 2"),
            ),
            const SizedBox(height: 20),
            FloatingPanel(
              color: Colors.deepOrange.shade200,
              children: const Text("Panel 3"),
            ),
          ],
        ),
      ),
    );
  }
}

class FloatingPanel extends StatelessWidget {
  final Color color;
  final dynamic children;

  const FloatingPanel({super.key, required this.children, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Center(
        child: this.children,
      ),
    );
  }
}
