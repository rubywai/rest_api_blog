import 'dart:io';

import 'package:blog_rest_api/blog_notifier/blog_notifier.dart';
import 'package:blog_rest_api/data/models/updload_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UploadPostPage extends StatefulWidget {
  const UploadPostPage({super.key});

  @override
  State<UploadPostPage> createState() => _UploadPostPageState();
}

class _UploadPostPageState extends State<UploadPostPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  File? _photo;

  UploadModel? _uploadModel;
  bool? _isLoading = false;
  bool? _isError = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a post"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_isLoading == true)
            Center(
              child: CircularProgressIndicator(),
            ),
          if (_isError == true && _isLoading == false)
            Center(
              child: Text("Something wrong"),
            ),
          if (_uploadModel != null)
            Center(
              child: Column(
                children: [
                  Text("Success"),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("OK"),
                  )
                ],
              ),
            ),
          if (_uploadModel == null && _isLoading != true && _isError != true)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: 'Title',
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                    controller: _bodyController,
                    maxLines: 5,
                    minLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Body',
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      ImagePicker picker = ImagePicker();
                      XFile? xFile =
                          await picker.pickImage(source: ImageSource.gallery);
                      if (xFile != null) {
                        setState(() {
                          _photo = File(xFile.path);
                        });
                      }
                    },
                    child: Text('Choose Image(Optional)'),
                  ),
                  if (_photo != null) Image.file(_photo!),
                  FilledButton(
                    onPressed: () async {
                      String title = _titleController.text;
                      String body = _bodyController.text;
                      if (title.trim().isNotEmpty && body.trim().isNotEmpty) {
                        try {
                          setState(() {
                            _isLoading = true;
                          });
                          final uploadModel = await Provider.of<BlogNotifier>(
                                  context,
                                  listen: false)
                              .uploadPost(
                            title: title,
                            body: body,
                            photo: _photo,
                          );
                          setState(() {
                            _isLoading = false;
                            _isError = false;
                            _uploadModel = uploadModel;
                          });
                        } catch (e) {
                          setState(() {
                            _isError = true;
                          });
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("PLease enter completely"),
                          ),
                        );
                      }
                    },
                    child: Text("Upload"),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
