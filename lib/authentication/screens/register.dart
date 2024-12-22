import 'dart:convert';
import 'package:ajeg_mobile/authentication/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String? _userType;

  // bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        // backgroundColor: _isLoading ? const Color(0xFFB1B1B1) : Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 24,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      stops: [0.6, 0.9],
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white,
                        Color.fromARGB(255, 241, 162, 88)
                      ])),
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    "Register",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Create an account with Ajeg",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[500],
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  getInputFields(),
                  const SizedBox(height: 32),
                  MaterialButton(
                    elevation: 0.0,
                    color: const Color.fromARGB(255, 219, 128, 53),
                    height: 56,
                    minWidth: double.infinity,
                    onPressed: () async {
                      FocusManager.instance.primaryFocus?.unfocus();
                      final navigator = Navigator.of(context);
                      String username = _usernameController.text;
                      String password1 = _passwordController.text;
                      String password2 = _confirmPasswordController.text;
                      String? userType = _userType;

                      // setState(() {
                      // _isLoading = true;
                      // });

                      final response = await request.postJson(
                          "http://https://thorbert-anson-ajeg.pbp.cs.ui.ac.id/mobile-register/",
                          jsonEncode({
                            "username": username,
                            "password1": password1,
                            "password2": password2,
                            "user_type": userType,
                          }));

                      await Future.delayed(const Duration(milliseconds: 1), () {
                        if (response['status'] == 'success') {
                          // setState(() {
                          //   _isLoading = false;
                          // });

                          if (!context.mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Successfully registered!'),
                            ),
                          );
                          navigator.pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        } else {
                          if (!context.mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Failed to register!'),
                            ),
                          );
                          // setState(() {
                          // _isLoading = false;
                          // });
                        }
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      "Register",
                      style: GoogleFonts.inter(
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // // if (_isLoading)
            //   const Opacity(
            //     opacity: 0.3,
            //     child: ModalBarrier(dismissible: false, color: Colors.black),
            //   ),
            // // if (_isLoading)
            //   const Center(
            //     child: CircularProgressIndicator(
            //       color: Color.fromARGB(255, 219, 128, 53),
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }

  Widget getInputFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: _userType,
          decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.person,
              size: 18,
              color: Color.fromARGB(255, 219, 128, 53),
            ),
            hintText: "Choose your account type...",
            filled: true,
            enabledBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: Color.fromARGB(255, 219, 128, 53)),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
          ),
          onChanged: (value) => setState(() {
            _userType = value;
          }),
          items: const [
            DropdownMenuItem(
              value: "traveller",
              child: Text("Traveller (Normal User)"),
            ),
            DropdownMenuItem(
              value: "merchant",
              child: Text("Merchant (Store Owner)"),
            ),
          ],
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _usernameController,
          decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.account_circle_outlined,
              size: 18,
              color: Color.fromARGB(255, 219, 128, 53),
            ),
            hintText: "Username",
            filled: true,
            enabledBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: Color.fromARGB(255, 219, 128, 53)),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.lock_outline,
              size: 18,
              color: Color.fromARGB(255, 219, 128, 53),
            ),
            hintText: "Password",
            filled: true,
            enabledBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: Color.fromARGB(255, 219, 128, 53)),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _confirmPasswordController,
          decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.lock_outline,
              size: 18,
              color: Color.fromARGB(255, 219, 128, 53),
            ),
            hintText: "Confirm Password",
            filled: true,
            enabledBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: Color.fromARGB(255, 219, 128, 53)),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
          ),
          obscureText: true,
        ),
      ],
    );
  }
}
