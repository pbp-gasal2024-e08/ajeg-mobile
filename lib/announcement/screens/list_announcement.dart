import 'package:ajeg_mobile/announcement/screens/add_announcement.dart';
import 'package:flutter/material.dart';
import 'package:ajeg_mobile/announcement/models/announcement.dart';
import 'package:ajeg_mobile/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:ajeg_mobile/announcement/screens/edit_announcement.dart';

class AnnouncementPage extends StatefulWidget {
  const AnnouncementPage({super.key});

  @override
  State<AnnouncementPage> createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> {
  List<Announcement> _announcements = [];
  bool _isMerchant = false;

  Future<List<Announcement>> fetchAnnouncement(CookieRequest request) async {
    var response =
        await request.get('http://localhost:8000/announcement/get-flutter/');

    // Decode response into JSON
    var data = response;

    // Convert JSON data into Announcement objects
    List<Announcement> listAnnouncement = [];
    for (var d in data) {
      if (d != null) {
        listAnnouncement.add(Announcement.fromJson(d));
      }
    }

    setState(() {
      _announcements = listAnnouncement;
    });
    return listAnnouncement;
  }

  Future<void> deleteAnnouncement(
      CookieRequest request, Announcement announcement) async {
    final response = await request.get(
        "http://localhost:8000/announcement/delete-flutter/${announcement.pk}");
    if (mounted) {
      if (response["status"] == "success") {
        setState(() {
          _announcements.remove(announcement);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Announcement berhasil dihapus!"),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Terdapat kesalahan, silakan coba lagi."),
          ),
        );
      }
      Navigator.pop(context);
    }
  }

  Future<void> fetchIsMerchant(CookieRequest request) async {
    final response = await request
        .get('http://localhost:8000/announcement/is-merchant-flutter/');
    setState(() {
      _isMerchant = response['isMerchant'];
    });
  }

  @override
  void initState() {
    super.initState();
    final request = context.read<CookieRequest>();
    fetchAnnouncement(request);
    fetchIsMerchant(request);
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Announcement List'),
      ),
      drawer: const LeftDrawer(),
      body: Column(
        children: [
          if (_isMerchant)
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddAnnouncementPage(),
                  ),
                );
              },
              child: const Text('Tambah Announcement',
                  style: TextStyle(color: Colors.deepOrangeAccent)),
            ),
          const SizedBox(height: 10),
          Expanded(
            child: _announcements.isEmpty
                ? const Center(
                    child: Text(
                      'Tidak ada announcement',
                      style: TextStyle(
                          fontSize: 20, color: Colors.deepOrangeAccent),
                    ),
                  )
                : ListView.builder(
                    itemCount: _announcements.length,
                    itemBuilder: (_, index) {
                      final announcement = _announcements[index];
                      return InkWell(
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            color: Colors.deepOrange,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                announcement.title,
                                style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              const SizedBox(height: 10),
                              Text(announcement.description,
                                  style: const TextStyle(color: Colors.white)),
                              const SizedBox(height: 10),
                              Text("Store: ${announcement.storeName}",
                                  style: const TextStyle(color: Colors.white)),
                              if (announcement.isOwner)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EditAnnouncementPage(
                                              announcement,
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        'Edit',
                                        style: TextStyle(
                                            color: Colors.deepOrangeAccent),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    ElevatedButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text(
                                                  'Delete Announcement'),
                                              content: const Text(
                                                  'Apakah anda yakin ingin menghapus announcement ini?'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    await deleteAnnouncement(
                                                        request, announcement);
                                                  },
                                                  child: const Text('Delete'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: const Text(
                                        'Delete',
                                        style: TextStyle(
                                            color: Colors.deepOrangeAccent),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
