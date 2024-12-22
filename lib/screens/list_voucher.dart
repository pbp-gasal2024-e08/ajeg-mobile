import 'package:flutter/material.dart';
import '../models/voucher.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class VoucherCard extends StatelessWidget {
  final String code;
  final String discount;
  final String expiryDate;
  final bool isClaimed;

  const VoucherCard({
    super.key,
    required this.code,
    required this.discount,
    required this.expiryDate,
    required this.isClaimed,
  });

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16.0),
        width: MediaQuery.of(context).size.width * 0.9, // 90% of screen width
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Discount section
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Text(
                discount,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 12),
            // Voucher details
            Text(
              "Code: $code",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "Expiry Date: $expiryDate",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            // Status section
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.verified,
                  color: Colors.orange,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  isClaimed ? 'Voucher verified' : 'Voucher not claimed',
                  style: TextStyle(
                    fontSize: 14,
                    color: isClaimed ? Colors.orange : Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Claim button at the bottom
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: isClaimed
                    ? null
                    : () async {
                        final response = await request.post(
                          "http://127.0.0.1:8000/vouchers/claim-voucher/$code/",
                          {},
                        );

                        if (!context.mounted) return;

                        if (response['status'] == 'success') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('Voucher $code claimed successfully!'),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Failed to claim voucher: ${response['message']}'),
                            ),
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  disabledBackgroundColor: Colors.grey[300],
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Text(
                  isClaimed ? 'Claimed' : 'Claim Voucher',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VoucherPage extends StatefulWidget {
  const VoucherPage({super.key});

  @override
  State<VoucherPage> createState() => _VoucherPageState();
}

class _VoucherPageState extends State<VoucherPage> {
  Future<List<Voucher>> fetchVoucher(CookieRequest request) async {
    // TOD Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
    final response =
        await request.get('http://127.0.0.1:8000/vouchers/vouchers-json/');

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
      body: FutureBuilder<List<Voucher>>(
        future: fetchVoucher(request),
        builder: (context, AsyncSnapshot<List<Voucher>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No vouchers available.',
                style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 236, 155, 88),
                ),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) {
                final voucher = snapshot.data![index].fields;
                return VoucherCard(
                  code: voucher.code,
                  discount: voucher.discount,
                  expiryDate:
                      voucher.expiryDate.toLocal().toString().split(' ')[0],
                  isClaimed: voucher.isClaimed,
                );
              },
            );
          }
        },
      ),
    );
  }
}
