import 'package:flutter/material.dart';
import 'package:straysave/screens/authorities/authority_detail.dart';
import 'package:straysave/shared/loading.dart';
import 'package:straysave/shared/search_bar.dart';

class Authorities extends StatefulWidget {
  const Authorities({super.key});

  @override
  State<Authorities> createState() => _AuthoritiesState();
}

class _AuthoritiesState extends State<Authorities> {
  bool loading = false;
  String _searchQuery = "";

  final TextEditingController _searchController = TextEditingController();

  final List<String> authorities = [
    "Department of Veterinary Services (DVS)",
    "Persatuan Haiwan Terbiar Malaysia (SAFM)",
    "SPCA Selangor",
    "Malaysian National Animal Welfare Foundation (MNAWF)",
    "PAWS Animal Welfare Society",
    "Malaysian Animal Welfare Association (MAWA)",
    "One World Animal Care (OWAC)",
    "Malaysian Conservation Alliance for Tigers (MYCAT)",
  ];

  @override
  Widget build(BuildContext context) {
    final List<String> filteredAuths = authorities
        .where(
          (report) => report.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Color(0xFFF8F9FA),
            appBar: AppBar(
              backgroundColor: Color(0xFFF8F9FA),
              elevation: 0,
              title: Text('Authorities', style: TextStyle(color: Colors.black)),
            ),
            body: Stack(
              children: [
                //Authorities List
                ListView.builder(
                  padding: EdgeInsets.only(top: 80),
                  shrinkWrap: true,
                  itemCount: filteredAuths.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 1),
                      shape: BeveledRectangleBorder(
                        side: BorderSide(style: BorderStyle.none),
                      ),
                      color: /* Colors.green */ Colors.white,
                      elevation: 0,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AuthorityDetail(),
                            ),
                          );
                        },
                        child: ListTile(
                          leading: const Icon(Icons.pets),
                          title: Text(filteredAuths[index]),
                          subtitle: const Text("Tap for more details"),
                        ),
                      ),
                    );
                  },
                ),
                //Floating Search Bar
                PosSearchBar(
                  controller: _searchController,
                  onChanged: (query) {
                    setState(() {
                      _searchQuery = query;
                    });
                  },
                ),
              ],
            ),
          );
  }
}
