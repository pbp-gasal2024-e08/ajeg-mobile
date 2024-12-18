import 'package:flutter/material.dart';
import '../models/voucher.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import '../widgets/left_drawer.dart';

class VoucherPage extends StatefulWidget {
  const VoucherPage({super.key});

  @override
  State<VoucherPage> createState() => _VoucherPageState();
}

class _VoucherPageState extends State<VoucherPage> {
  Future<List<Voucher>> fetchVoucher(CookieRequest request) async {
    // TOD Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
    final response = await request.get('http://127.0.0.1:8000/json/');

    // Melakukan decode response menjadi bentuk json
    var data = response;

    // Melakukan konversi data json menjadi object Voucher
    List<Voucher> listVoucher = [];
    for (var d in data) {
      if (d != null) {
        listVoucher.add(Voucher.fromJson(d));
      }
    }
    return listVoucher;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Discounts'),
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder<List<Voucher>>(
        future: fetchVoucher(request),
        builder: (context, AsyncSnapshot<List<Voucher>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No vouchers available.',
                style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 236, 155, 88)),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) {
                final voucher = snapshot.data![index].fields;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Code: ${voucher.code}",
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text("Discount: ${voucher.discount}"),
                      const SizedBox(height: 10),
                      Text("Expiry Date: ${voucher.expiryDate.toLocal().toString().split(' ')[0]}"),
                      const SizedBox(height: 10),
                      Text("Claimed: ${voucher.isClaimed ? 'Yes' : 'No'}"),
                      const SizedBox(height: 10),
                      Text("Flash Sale: ${voucher.isFlashSale ? 'Yes' : 'No'}"),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
