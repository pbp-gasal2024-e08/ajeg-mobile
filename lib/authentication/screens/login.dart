import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ajeg_mobile/screens/home_new.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
          )),
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
                  // Container(
                  //   height: 64,
                  //   decoration: const BoxDecoration(
                  //     image: DecorationImage(
                  //         image: AssetImage(
                  //           'assets/images/logo.png',
                  //         ),
                  //         fit: BoxFit.scaleDown),
                  //   ),
                  // ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Login",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Login to Ajeg",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[500],
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  getTextFields(),
                  const SizedBox(height: 32.0),
                  MaterialButton(
                    elevation: 0.0,
                    color: const Color.fromARGB(255, 219, 128, 53),
                    height: 56,
                    minWidth: double.infinity,
                    onPressed: () async {
                      FocusManager.instance.primaryFocus?.unfocus();
                      final navigator = Navigator.of(context);
                      String username = _usernameController.text;
                      String password = _passwordController.text;
                      // setState(() {
                      //   _isLoading = true;
                      // });
                      final response = await request.login(
                          "http://https://thorbert-anson-ajeg.pbp.cs.ui.ac.id/mobile-login/",
                          {
                            'username': username,
                            'password': password,
                          });
                      await Future.delayed(const Duration(milliseconds: 1), () {
                        if (request.loggedIn) {
                          navigator.pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const MyHomePage(title: ''),
                            ),
                            (route) => false,
                          );
                        } else {
                          if (context.mounted) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Login Gagal'),
                                content: Text(response['message']),
                                actions: [
                                  TextButton(
                                    child: const Text('OK'),
                                    onPressed: () {
                                      navigator.pop();
                                    },
                                  ),
                                ],
                              ),
                            );
                          }
                          // setState(() {
                          //   _isLoading = false;
                          // });
                        }
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      "Login",
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
            // if (_isLoading)
            //   const Opacity(
            //     opacity: 0.3,
            //     child: ModalBarrier(dismissible: false, color: Colors.black),
            //   ),
            // if (_isLoading)
            //   Center(
            //     child: Container(
            //       height: 100,
            //       width: 100,
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(16.0),
            //         color: Colors.white,
            //       ),
            //     ),
            //   ),
            // if (_isLoading)
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

  Widget getTextFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              contentPadding: const EdgeInsets.symmetric(vertical: 15.0)),
          style: GoogleFonts.inter(
            textStyle: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 20.0),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.key,
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
          style: GoogleFonts.inter(
            textStyle: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
