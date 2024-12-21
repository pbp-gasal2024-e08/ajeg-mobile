import 'package:ajeg_mobile/authentication/screens/login.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
        child: Column(
          children: [
            InkWell(
                child: Column(children: [
                  FloatingPanel(
                      color: Colors.deepOrange.shade100,
                      text: "See All Products"),
                ]),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()));
                }),
            const SizedBox(height: 20),
            FloatingPanel(
              color: Colors.deepOrange.shade50,
              text: 'Panel 2',
            ),
            const SizedBox(height: 20),
            FloatingPanel(
              color: Colors.deepOrange.shade200,
              text: 'Panel 3',
            ),
          ],
        ),
      ),
    );
  }
}

class FloatingPanel extends StatelessWidget {
  final Color color;
  final String text;

  const FloatingPanel({super.key, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
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
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
