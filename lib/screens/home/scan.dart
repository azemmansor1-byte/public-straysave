import 'dart:io';
import 'package:flutter/material.dart';
import 'package:straysave/screens/report/make_report.dart';
import 'package:straysave/shared/image_picker.dart';
import 'package:straysave/shared/loading.dart';

class Scan extends StatefulWidget {
  const Scan({super.key});

  @override
  State<Scan> createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  bool loading = false;
  bool _showMakeReport = false;
  File? img;
  ImageProvider? fakeImg = NetworkImage('https://place.dog/500/500');

  String speciesName = "Mammal/Otter";
  String description =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Color(0xFFF8F9FA),
            appBar: _showMakeReport
                ? null
                : AppBar(
                    backgroundColor: Colors.white,
                    elevation: 1,
                    title: Text(
                      'Scan Animal',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
            body: _showMakeReport
                ? MakeReport(
                    onClose: () {
                      setState(() {
                        _showMakeReport = false;
                      });
                    },
                    // pass scanned data here 👇
                    initialTitle: speciesName,
                    initialDesc: description,
                    initialImage: img,
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Scanned image
                        Container(
                          width: double.infinity,
                          height: 400,
                          decoration: BoxDecoration(
                            color: img == null ? Colors.grey : null,
                            borderRadius: BorderRadius.circular(8),
                            image: img != null
                                ? DecorationImage(
                                    image: FileImage(img!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          alignment: Alignment.center,
                          child: img == null
                              ? Text(
                                  'Add Image',
                                  style: TextStyle(color: Colors.white),
                                )
                              : null,
                        ),
                        const SizedBox(height: 16),
                        // Title
                        const Text(
                          "Result",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        //Animal Name??
                        const Text(
                          "Otter",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Description
                        Text(
                          description,
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                        const SizedBox(height: 8),
                        // Species info
                        Text(
                          "Species • $speciesName",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(height: 24),
                        //Scan button
                        TextButton(
                          style: TextButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () async {
                            final picked =
                                await pickImageFromGallery(); // wait for the File
                            if (picked != null) {
                              setState(() {
                                img = picked; // now img is a real File
                              });
                            }
                          },
                          child: Text('Scan'),
                        ),
                        const SizedBox(height: 12),
                        //Report button
                        TextButton(
                          style: TextButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                            foregroundColor: Colors.blue,
                            backgroundColor: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _showMakeReport = true;
                            });
                          },
                          child: Text('Report'),
                        ),
                      ],
                    ),
                  ),
          );
  }
}
