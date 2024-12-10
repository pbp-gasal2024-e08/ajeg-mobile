import 'package:ajeg_mobile/homepage/screens/home.dart';
import 'package:ajeg_mobile/widgets/left_drawer.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrange,
          title: const Text(
            "Ajeg",
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        drawer: const LeftDrawer(),
        body: const Center(
          child: HomeScreen(),
        ),
      ),
    );
  }
}
