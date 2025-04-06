import 'package:blog_rest_api/blog_notifier/blog_notifier.dart';
import 'package:blog_rest_api/data/models/post_model.dart';
import 'package:blog_rest_api/pages/post_detail_page.dart';
import 'package:blog_rest_api/pages/upload_post_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BlogListPage extends StatefulWidget {
  const BlogListPage({super.key});

  @override
  State<BlogListPage> createState() => _BlogListPageState();
}

class _BlogListPageState extends State<BlogListPage> {
  bool _isLoading = true;
  bool _isError = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getAllPost();
    });
  }

  void _getAllPost() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<BlogNotifier>(context, listen: false).getPostList();
      setState(() {
        _isLoading = false;
        _isError = false;
      });
    } catch (e) {
      _isError = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Blog App"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_isLoading && !_isError)
            Center(
              child: CircularProgressIndicator(),
            ),
          if (_isError) Center(child: Text('Something wrong')),
          if (!_isError && !_isLoading)
            Expanded(
              child:
                  Consumer<BlogNotifier>(builder: (context, notifier, child) {
                List<PostModel> posts = notifier.postList;
                if (posts.isEmpty) {
                  return Text("Empty list");
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    _getAllPost();
                  },
                  child: ListView.builder(
                    padding: EdgeInsets.all(8.0),
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      PostModel post = posts[index];
                      return InkWell(
                        onTap: () {
                          int? id = post.id;
                          if (id != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) {
                                  return PostDetailPage(id: id);
                                },
                              ),
                            );
                          }
                        },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(post.title ?? ''),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) {
                return UploadPostPage();
              },
            ),
          );
          _getAllPost();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
