import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:straysave/models/report_type.dart';
import 'package:straysave/models/user.dart';
import 'package:straysave/services/database.dart';
import 'package:straysave/services/upload_image.dart';
import 'package:straysave/shared/constant.dart';
import 'package:straysave/shared/image_picker.dart';
import 'package:straysave/shared/loading.dart';

class MakeReport extends StatefulWidget {
  final DatabaseService? databaseService;
  final Future<String?> Function(File?)? uploadImageFn;
  final Future<void> Function(String)? deleteImageFn;

  final VoidCallback? onClose;
  final String? initialTitle;
  final String? initialDesc;
  final File? initialImage;

  const MakeReport({
    this.databaseService,
    this.uploadImageFn,
    this.deleteImageFn,
    this.onClose,
    this.initialTitle,
    this.initialDesc,
    this.initialImage,
    super.key,
  });

  @override
  State<MakeReport> createState() => _MakeReportState();
}

class _MakeReportState extends State<MakeReport> {
  final _formKey = GlobalKey<FormState>();

  bool loading = false;

  String? selectedLocation;
  File? img;
  ReportType? selectedType;
  String error = '';

  late TextEditingController _titleController;
  late TextEditingController _descController;

  DatabaseService _databaseServiceBuilder(String uid) {
    return widget.databaseService ?? DatabaseService(uid: uid);
  }

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle ?? '');
    _descController = TextEditingController(text: widget.initialDesc ?? '');
    img = widget.initialImage;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    Future<void> pickAndSetImage() async {
      final picked = await pickImageFromGallery();
      if (picked == null) return;

      final selectedFile = File(picked.path);
      bool valid = await checkImageSize(selectedFile);

      if (!valid) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Image too large. Max 5 MB allowed.")),
        );
        return;
      }

      setState(() => img = selectedFile);
    }

    Future<void> submitReport() async {
      if (!_formKey.currentState!.validate()) return;

      setState(() => loading = true);

      try {
        await _databaseServiceBuilder(user.uid).createReportData(
          _titleController.text.trim(),
          selectedType!.id,
          _descController.text.trim(),
          user.uid,
          img: img,
          location: selectedLocation,
        );

        if (!mounted) return;

        // ignore: use_build_context_synchronously
        showToast(context, 'Submitted!');
      } catch (e) {
        if (!mounted) return;
        // ignore: use_build_context_synchronously
        showToast(context, 'submission failed!');
      } finally {
        if (mounted) setState(() => loading = false);
        widget.onClose?.call();
      }
    }

    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Color(0xFFF8F9FA),
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 1,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: widget.onClose,
              ),
              title: Text('New Report', style: TextStyle(color: Colors.black)),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Align(
                  alignment: Alignment.center,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        //title
                        TextFormField(
                          controller: _titleController,
                          decoration: textInputDecoration.copyWith(
                            hintText: 'Title',
                          ),
                          validator: (val) => val == null || val.isEmpty
                              ? 'Enter a title'
                              : null,
                        ),
                        SizedBox(height: 20.0),
                        //report type
                        DropdownButtonFormField<ReportType>(
                          decoration: textInputDecoration.copyWith(
                            hintText: 'Select Category',
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          initialValue: selectedType,
                          icon: const Icon(Icons.arrow_downward),
                          elevation: 16,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          dropdownColor: Colors.white,
                          onChanged: (value) {
                            setState(() {
                              selectedType = value;
                            });
                          },
                          items: reportTypes.map((type) {
                            return DropdownMenuItem(
                              value: type,
                              child: Row(
                                children: [
                                  Icon(type.icon, color: type.color),
                                  SizedBox(width: 8),
                                  Text(type.name),
                                ],
                              ),
                            );
                          }).toList(),
                          validator: (val) =>
                              val == null ? 'Pick a type :(' : null,
                        ),
                        SizedBox(height: 20.0),
                        // TODO: Replace this text input with map picker for better location accuracy
                        //location
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                            hintText:
                                'Enter your location (Cendikiawan, Murni,...)',
                            suffixIcon: Icon(Icons.location_on),
                          ),
                          onChanged: (value) {
                            setState(() => selectedLocation = value);
                          },
                          validator: (val) => val == null || val.isEmpty
                              ? 'Enter your location :('
                              : null,
                        ),
                        SizedBox(height: 20.0),
                        //description
                        TextFormField(
                          controller: _descController,
                          maxLines: 6, // limit height to 6 lines
                          keyboardType: TextInputType.multiline,
                          decoration: textInputDecoration.copyWith(
                            hintText: 'Description',
                          ),
                          validator: (val) => val == null || val.isEmpty
                              ? 'Enter a description'
                              : null,
                        ),
                        SizedBox(height: 20.0),
                        //image
                        InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: pickAndSetImage,
                          child: Container(
                            width: 150,
                            height: 150,
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
                                ? const Text(
                                    'Add Image',
                                    style: TextStyle(color: Colors.white),
                                  )
                                : null,
                          ),
                        ),
                        SizedBox(height: 20),
                        //submit button
                        TextButton(
                          style: TextButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () => submitReport(),
                          child: Text('Submit'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
