import 'package:blog_rest_api/blog_notifier/blog_notifier.dart';
import 'package:blog_rest_api/const/url_const.dart';
import 'package:blog_rest_api/data/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostDetailPage extends StatefulWidget {
  const PostDetailPage({super.key, required this.id});
  final int id;

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  bool _isLoading = true;
  bool _isError = false;
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
                if (post == null) {
                  return SizedBox.shrink();
                }
                String imageUrl = "${UrlConst.baseUrl}/${post.photo}";
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(post.title ?? ''),
                    Text(post.body ?? ''),
                    if (post.photo != null) Image.network(imageUrl),
                  ],
                );
              }),
            ),
        ],
      ),
    );
  }
}
