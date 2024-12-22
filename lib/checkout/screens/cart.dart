import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  CartScreenState createState() => CartScreenState();
}

class CartScreenState extends State<CartScreen> {
  List<dynamic> cartItems = [];
  bool isLoading = true;

  Future<void> fetchCart(CookieRequest request) async {
    final response = await request.get('http://localhost:8000/get-cart/');
    if (response.statusCode == 200) {
      final List<dynamic> data = (response.body);
      setState(() {
        cartItems = data;
        isLoading = false;
      });
    } else {
      throw Exception('Failed to fetch cart');
    }
  }

  Future<Map<String, dynamic>> fetchProduct(
      CookieRequest request, int productId) async {
    final response = await request
        .get('http://localhost:8000/product/get-product/$productId/');
    if (response.statusCode == 200) {
      return (response.body);
    } else {
      throw Exception('Failed to fetch product');
    }
  }

  Future<void> removeCartItem(CookieRequest request, int productId) async {
    final response = await request.post(
      'http://localhost:8000/remove-item/',
      {'product_id': productId},
    );
    if (response.statusCode == 200) {
      setState(() {
        cartItems.removeWhere((item) => item['fields']['product'] == productId);
      });
    } else {
      throw Exception('Failed to remove item');
    }
  }

  Future<void> updateCartQuantity(
      CookieRequest request, int productId, int quantity) async {
    final response = await request.post(
      'http://localhost:8000/update-quantity/',
      {'product_id': productId, 'quantity': quantity},
    );
    if (response.statusCode == 200) {
      final updatedItem = (response.body);
      setState(() {
        final index = cartItems
            .indexWhere((item) => item['fields']['product'] == productId);
        if (index != -1) {
          cartItems[index]['fields']['quantity'] = quantity;
          cartItems[index]['fields']['total_price'] =
              updatedItem['total_price'];
        }
      });
    } else {
      throw Exception('Failed to update quantity');
    }
  }

  int calculateTotalPrice() {
    return cartItems.fold(
        0, (sum, item) => sum + int.parse(item['fields']['total_price']));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final request = Provider.of<CookieRequest>(context, listen: false);
      fetchCart(request);
    });
  }

  @override
  Widget build(BuildContext context) {
    final request = Provider.of<CookieRequest>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : cartItems.isEmpty
              ? const Center(child: Text('Empty Cart'))
              : ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final cartItem = cartItems[index];
                    final productId = cartItem['fields']['product'];

                    return FutureBuilder(
                      future: fetchProduct(request, productId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return const Text('Error loading product');
                        } else {
                          final product = snapshot.data;
                          return Card(
                            child: ListTile(
                              title: Text(product!['fields']['name']),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Rp ${cartItem['fields']['total_price']}'),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove),
                                        onPressed: () {
                                          if (cartItem['fields']['quantity'] >
                                              1) {
                                            updateCartQuantity(
                                              request,
                                              productId,
                                              cartItem['fields']['quantity'] -
                                                  1,
                                            );
                                          }
                                        },
                                      ),
                                      Text(cartItem['fields']['quantity']
                                          .toString()),
                                      IconButton(
                                        icon: const Icon(Icons.add),
                                        onPressed: () {
                                          updateCartQuantity(
                                            request,
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
                                onPressed: () =>
                                    removeCartItem(request, productId),
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
