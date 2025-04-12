import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../blog_notifier/blog_notifier.dart';
import '../const/url_const.dart';
import '../data/models/post_model.dart';
import 'update_post_page.dart';

class PostDetailPage extends StatefulWidget {
  const PostDetailPage({super.key, required this.id});
  final int id;

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  bool _isLoading = true;
  bool _isError = false;
  PostModel? _postModel;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _postDetail(widget.id);
    });
  }

  void _postDetail(int id) async {
    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<BlogNotifier>(context, listen: false).getPost(id);
      setState(() {
        _isLoading = false;
        _isError = false;
      });
    } catch (e) {
      setState(() {
        _isError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Detail'),
        actions: [
          if (_postModel != null)
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UpdatePostPage(
                      postModel: _postModel!,
                    ),
                  ),
                );
              },
              icon: Icon(Icons.edit),
            )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_isLoading && !_isError)
            Center(
              child: CircularProgressIndicator(),
            ),
          if (_isError) Text("Something wrong"),
          if (!_isLoading && !_isError)
            Expanded(
              child:
                  Consumer<BlogNotifier>(builder: (context, notifier, child) {
                PostModel? post = notifier.postModel;
                Future(() {
                  setState(() {
                    _postModel = post;
                  });
                });
                if (post == null) {
                  return SizedBox.shrink();
                }
                String imageUrl = "${UrlConst.baseUrl}/${post.photo}";
                return Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(post.title ?? ''),
                        Text(post.body ?? ''),
                        if (post.photo != null)
                          Image.network(
                            imageUrl,
                            loadingBuilder: (_, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }
                              return Container(
                                alignment: Alignment.center,
                                width: double.infinity,
                                height: 200,
                                child: CircularProgressIndicator(),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                );
              }),
            ),
        ],
      ),
    );
  }
}
