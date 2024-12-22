import 'package:ajeg_mobile/screens/list_voucher.dart';
import 'package:ajeg_mobile/screens/qna_page.dart';
import 'package:flutter/material.dart';
import 'package:ajeg_mobile/announcement/screens/list_announcement.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.deepOrange,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: const ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AnnouncementPage()),
              );
            },
            child: const ListTile(
              leading: Icon(Icons.announcement),
              title: Text('Announcements'),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const VoucherPage()),
              );
            },
            child: const ListTile(
              leading: Icon(Icons.percent),
              title: Text('Vouchers'),
            ),
          ),
          InkWell(
            onTap: () {},
            child: const ListTile(
              leading: Icon(Icons.favorite),
              title: Text('Wishlist'),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const QnAPage()),
              );
            },
            child: const ListTile(
              leading: Icon(Icons.question_answer),
              title: Text('QnA'),
            ),
          )
        ],
      ),
    );
  }
}
