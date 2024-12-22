import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<dynamic> cartItems = [];
  bool isLoading = true;

  Future<void> fetchCart() async {
    final url = Uri.parse('https://yourapi.com/get_cart_json'); // Replace with your endpoint
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        cartItems = json.decode(response.body);
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load cart');
    }
  }

  Future<Map<String, dynamic>> fetchProduct(int productId) async {
    final url = Uri.parse('https://yourapi.com/get_product_json?product_id=$productId'); // Replace with your endpoint
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch product');
    }
  }

  Future<void> removeCartItem(int productId) async {
    final url = Uri.parse('https://yourapi.com/delete_cart'); // Replace with your endpoint
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'product_id': productId}),
    );

    if (response.statusCode == 200) {
      setState(() {
        cartItems.removeWhere((item) => item['fields']['product'] == productId);
      });
    } else {
      throw Exception('Failed to remove item');
    }
  }

  Future<void> updateCartQuantity(int productId, int quantity) async {
    final url = Uri.parse('https://yourapi.com/update_cart_quantity'); // Replace with your endpoint
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'product_id': productId, 'quantity': quantity}),
    );

    if (response.statusCode == 200) {
      final updatedItem = json.decode(response.body);
      setState(() {
        final index = cartItems.indexWhere((item) => item['fields']['product'] == productId);
        if (index != -1) {
          cartItems[index]['fields']['quantity'] = quantity;
          cartItems[index]['fields']['total_price'] = updatedItem['total_price'];
        }
      });
    } else {
      throw Exception('Failed to update quantity');
    }
  }

  int calculateTotalPrice() {
    return cartItems.fold(0, (sum, item) => sum + int.parse(item['fields']['total_price']));
  }

  @override
  void initState() {
    super.initState();
    fetchCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cart')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : cartItems.isEmpty
              ? Center(child: Text('Empty Cart'))
              : ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final cartItem = cartItems[index];
                    final productId = cartItem['fields']['product'];

                    return FutureBuilder(
                      future: fetchProduct(productId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error loading product');
                        } else {
                          final product = snapshot.data;
                          return Card(
                            child: ListTile(
                              // leading: Image.network(product['fields']['imgurl']),
                              title: Text(product!['fields']['name']),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Rp ${cartItem['fields']['total_price']}'),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.remove),
                                        onPressed: () {
                                          if (cartItem['fields']['quantity'] > 1) {
                                            updateCartQuantity(
                                              productId,
                                              cartItem['fields']['quantity'] - 1,
                                            );
                                          }
                                        },
                                      ),
                                      Text(cartItem['fields']['quantity'].toString()),
                                      IconButton(
                                        icon: const Icon(Icons.add),
                                        onPressed: () {
                                          updateCartQuantity(
                                            productId,
                                            cartItem['fields']['quantity'] + 1,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => removeCartItem(productId),
                              ),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('Total Price: Rp ${calculateTotalPrice()}'),
      ),
    );
  }
}
