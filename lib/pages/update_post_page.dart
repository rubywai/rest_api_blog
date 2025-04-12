import 'package:blog_rest_api/blog_notifier/blog_notifier.dart';
import 'package:blog_rest_api/data/models/post_model.dart';
import 'package:blog_rest_api/data/models/post_update_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdatePostPage extends StatefulWidget {
  const UpdatePostPage({
    super.key,
    required this.postModel,
  });
  final PostModel postModel;

  @override
  State<UpdatePostPage> createState() => _UpdatePostPage();
}

class _UpdatePostPage extends State<UpdatePostPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  PostOptionsModel? _updateModel;
  bool? _isLoading = false;
  bool? _isError = false;

  @override
  void initState() {
    super.initState();
    PostModel postModel = widget.postModel;
    _titleController.text = postModel.title ?? '';
    _bodyController.text = postModel.body ?? '';
  }

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
          if (_updateModel != null)
            Center(
              child: Column(
                children: [
                  Text(_updateModel?.result ?? "Success"),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("OK"),
                  )
                ],
              ),
            ),
          if (_updateModel == null && _isLoading != true && _isError != true)
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
                  FilledButton(
                    onPressed: () async {
                      String title = _titleController.text;
                      String body = _bodyController.text;
                      if (title.trim().isNotEmpty && body.trim().isNotEmpty) {
                        try {
                          setState(() {
                            _isLoading = true;
                          });
                          int? id = widget.postModel.id;
                          if (id == null) {
                            return;
                          }
                          _updateModel = await Provider.of<BlogNotifier>(
                                  context,
                                  listen: false)
                              .updatePost(
                            title: title,
                            body: body,
                            id: id,
                          );
                          setState(() {
                            _isLoading = false;
                            _isError = false;
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
                    child: Text("Update"),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
