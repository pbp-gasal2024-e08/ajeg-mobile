import 'package:ajeg_mobile/screens/add_announcement.dart';
import 'package:flutter/material.dart';
import 'package:ajeg_mobile/models/announcement.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:ajeg_mobile/screens/edit_announcement.dart';

class AnnouncementPage extends StatefulWidget {
  const AnnouncementPage({super.key});

  @override
  State<AnnouncementPage> createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> {
  List<Announcement> _announcements = [];

  Future<List<Announcement>> fetchAnnouncement(CookieRequest request) async {
    final response =
        await request.get('http://localhost:8000/announcement/store/1');

    // Melakukan decode response menjadi bentuk json
    var data = response;

    // Melakukan konversi data json menjadi object Announcement
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

  @override
  void initState() {
    super.initState();
    final request = context.read<CookieRequest>();
    fetchAnnouncement(request);
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Announcement List'),
      ),
      body: Column(
        children: [
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
            child: FutureBuilder(
              future: fetchAnnouncement(request),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'Tidak ada announcement',
                        style: TextStyle(
                            fontSize: 20, color: Colors.deepOrangeAccent),
                      ),
                    );
                  } else {
                    return ListView.builder(
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
                                    announcement.fields.title,
                                    style: const TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(announcement.fields.description,
                                      style:
                                          const TextStyle(color: Colors.white)),
                                  const SizedBox(height: 10),
                                  Text("Store id: ${announcement.fields.store}",
                                      style:
                                          const TextStyle(color: Colors.white)),
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
                                                        'Are you sure you want to delete this announcement?'),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                            'Cancel'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () async {
                                                          await deleteAnnouncement(
                                                              request,
                                                              announcement);
                                                        },
                                                        child: const Text(
                                                            'Delete'),
                                                      ),
                                                    ]);
                                              });
                                        },
                                        child: const Text(
                                          'Delete',
                                          style: TextStyle(
                                              color: Colors.deepOrangeAccent),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
