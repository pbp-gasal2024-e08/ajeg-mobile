import 'dart:math';

import 'package:ajeg_mobile/checkout/screens/cart.dart';
import 'package:ajeg_mobile/products/screens/traveller.dart';
import 'package:ajeg_mobile/screens/list_announcement.dart';
import 'package:ajeg_mobile/screens/list_voucher.dart';
import 'package:ajeg_mobile/screens/qna_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ajeg Main Home',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(title: 'Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<dynamic> _allProducts;

  @override
  void initState() {
    super.initState();
    _allProducts = [];
    fetchProduct();
  }

  Future<void> fetchProduct() async {
    // Simulated API response for testing layout
    await Future.delayed(const Duration(seconds: 1));
    _allProducts = List.generate(
      5,
      (index) => {"name": "Book $index", "image": null},
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    int len = 12; // Simulated user name length for testing layout

    return Scaffold(
      backgroundColor: Colors.orangeAccent,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Greeting Section
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 80, 0, 60),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        len <= 12 ? "Hello, User" : "Hello,\nUser",
                        style: GoogleFonts.inter(
                          fontSize: len <= 12 ? 25 : 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "What food do you want to \neat today?",
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CartScreen()
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                          elevation: 0,
                          padding: const EdgeInsets.fromLTRB(35, 8, 35, 8),
                          backgroundColor: Colors.white,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              color: Colors.black,
                              size: 16,
                              Icons.shopping_cart,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "My Cart",
                              style: GoogleFonts.inter(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  // // buat voucher?
                  // Expanded(
                  //   child: Padding(
                  //     padding: const EdgeInsets.fromLTRB(20, 5, 5, 5),
                  //     child: Image.network(
                  //       'placeholder',
                  //       width: 120,
                  //       height: 120,
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
            // Action Buttons Section
            Container(
              padding: const EdgeInsets.only(top: 20, bottom: 30),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                        Container(
                        padding: const EdgeInsets.only(
                            right: 20.0, left: 20.0, bottom: 15.0),
                        height: 130,
                        width: double.infinity,
                        child: Material(
                          color: Colors.white,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ProductPage()
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.orangeAccent,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 32.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Katalog",
                                          style: GoogleFonts.inter(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          "Lihat semua item disini",
                                          style: GoogleFonts.inter(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w300,
                                            color: Colors.white,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: Icon(
                                      Icons.food_bank,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                        Container(
                        padding: const EdgeInsets.only(
                            right: 20.0, left: 20.0, bottom: 15.0),
                        height: 130,
                        width: double.infinity,
                        child: Material(
                          color: Colors.white,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AnnouncementPage()
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.orangeAccent,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 32.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Annoucements",
                                          style: GoogleFonts.inter(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          "Lihat announcement toko disini",
                                          style: GoogleFonts.inter(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w300,
                                            color: Colors.white,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: Icon(
                                      Icons.announcement,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                        Container(
                        padding: const EdgeInsets.only(
                            right: 20.0, left: 20.0, bottom: 15.0),
                        height: 130,
                        width: double.infinity,
                        child: Material(
                          color: Colors.white,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => QnAPage()
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.orangeAccent,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 32.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "QnA",
                                          style: GoogleFonts.inter(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          "Lihat QnA product",
                                          style: GoogleFonts.inter(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w300,
                                            color: Colors.white,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: Icon(
                                      Icons.question_answer,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                        Container(
                        padding: const EdgeInsets.only(
                            right: 20.0, left: 20.0, bottom: 15.0),
                        height: 130,
                        width: double.infinity,
                        child: Material(
                          color: Colors.white,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VoucherPage()
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.orangeAccent,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 32.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Vouchers",
                                          style: GoogleFonts.inter(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          "Lihat vouchers untuk diskon disini",
                                          style: GoogleFonts.inter(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w300,
                                            color: Colors.white,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: Icon(
                                      Icons.discount,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                  const SizedBox(height: 20),
                  // New Books Section
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 0, 20),
                      child: Text(
                        "New Products",
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        final book = _allProducts.isNotEmpty
                            ? _allProducts[Random().nextInt(_allProducts.length)]
                            : {"name": "Book Placeholder", "image": null};

                        return Container(
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          height: 200,
                          width: MediaQuery.of(context).size.width * 0.27,
                          decoration: BoxDecoration(
                            color: const Color(0xffd7e9f4),
                            borderRadius: BorderRadius.circular(13),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              )
                            ],
                          ),
                          child: Image.network(
                            book["image"] ??
                                "https://via.placeholder.com/150",
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.error);
                            },
                          ),
                        );
                      }),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder page for navigation
class PlaceholderPage extends StatelessWidget {
  final String title;
  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text("This is the $title"),
      ),
    );
  }
}
