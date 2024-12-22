import 'package:ajeg_mobile/authentication/screens/first_page.dart';
import 'package:ajeg_mobile/authentication/screens/login.dart';
import 'package:ajeg_mobile/screens/home_new.dart';
// import 'package:ajeg_mobile/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

// class UserInfo {
//   static bool loggedIn = true;
//   static Map<String, dynamic> data = {};

//   static void login(Map<String, dynamic> data) {
//     loggedIn = true;
//     UserInfo.data = data;
//   }

//   static void logout() {
//     loggedIn = false;
//     data = {};
//   }
// }

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     home: Scaffold(
  //       appBar: AppBar(
  //         backgroundColor: Colors.deepOrange,
  //         title: const Text(
  //           "Ajeg",
  //           style: TextStyle(color: Colors.black),
  //         ),
  //         iconTheme: const IconThemeData(color: Colors.black),
  //       ),
  //       drawer: const LeftDrawer(),
  //       body: ,
  //       ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) {
        CookieRequest request = CookieRequest();
        return request;
      },
      child: MaterialApp(
        title: 'Ajeg',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.orange,
          ).copyWith(secondary: Colors.orange[400]),
        ),
        // home: const MyHomePage(title: "Ajeg"),
        // home: const LoginPage()
        home: const FirstPage()
      ),
    );
  }
}
