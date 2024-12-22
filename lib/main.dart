import 'package:ajeg_mobile/screens/home.dart';
import 'package:ajeg_mobile/widgets/left_drawer.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) {
        return CookieRequest();
      },
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.deepOrange,
            titleTextStyle: TextStyle(
                color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
            iconTheme: IconThemeData(color: Colors.black),
          ),
        ),
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            title: Text(
              "Ajeg",
              style: Theme.of(context).appBarTheme.titleTextStyle,
            ),
            iconTheme: Theme.of(context).appBarTheme.iconTheme,
          ),
          drawer: const LeftDrawer(),
          body: const Center(
            child: HomeScreen(),
          ),
        ),
      ),
    );
  }
}
