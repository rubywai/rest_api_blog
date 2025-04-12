import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../blog_notifier/blog_notifier.dart';
import '../data/models/post_model.dart';
import '../data/models/post_update_model.dart';
import '../widgets/post_list_desktop.dart';
import '../widgets/post_list_mobile_widget.dart';
import 'post_detail_page.dart';
import 'upload_post_page.dart';

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
      Provider.of<BlogNotifier>(context, listen: false).initService();
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
              child: Consumer<BlogNotifier>(
                builder: (context, notifier, child) {
                  List<PostModel> posts = notifier.postList;
                  if (posts.isEmpty) {
                    return Text("Empty list");
                  }
                  double width = MediaQuery.of(context).size.width;

                  return RefreshIndicator(
                    onRefresh: () async {
                      _getAllPost();
                    },
                    child: width <= 600
                        ? PostListMobileWidget(
                            posts: posts,
                            children: (post) {
                              return _children(post, notifier);
                            },
                            onTap: (post) {
                              _redirectToDetail(post, notifier);
                            },
                          )
                        : PostListDesktop(
                            posts: posts,
                            children: (post) {
                              return _children(post, notifier);
                            },
                            onTap: (post) {
                              _redirectToDetail(post, notifier);
                            }),
                  );
                },
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) {
                return UploadPostPage();
              },
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  List<Widget> _children(PostModel post, BlogNotifier notifier) {
    return [
      Text(
        post.title ?? '',
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
      IconButton(
        onPressed: () async {
          bool? isDelete = await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Are you sure to delete?"),
                content: Text(post.title ?? ''),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel"),
                  ),
                  FilledButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: Text("OK"),
                  ),
                ],
              );
            },
          );
          if (isDelete == true) {
            if (post.id != null) {
              try {
                setState(() {
                  _isLoading = true;
                });
                PostOptionsModel optionModel =
                    await notifier.deletePost(post.id!);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(optionModel.result ?? ''),
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Not successful'),
                    ),
                  );
                }
              } finally {
                setState(() {
                  _isLoading = false;
                });
              }
            }
          }
        },
        icon: Icon(Icons.delete),
      ),
    ];
  }

  void _redirectToDetail(PostModel post, BlogNotifier notifier) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PostDetailPage(id: post.id!),
      ),
    );
  }
}
