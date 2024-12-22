import 'package:ajeg_mobile/products/models/product_model.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late List<ProductModel> _allProducts;
  late List<ProductModel> _filteredProducts;

  @override
  void initState() {
    super.initState();
    _allProducts = [];
    _filteredProducts = [];
    fetchProduct();
  }

  Future<void> fetchProduct() async {
    var url = Uri.parse('https://192.168.84.197:8000/get_products/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      _allProducts =
          body.map((dynamic item) => ProductModel.fromJson(item)).toList();
      _filteredProducts = List.from(_allProducts);
      setState(() {});
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget 
}
