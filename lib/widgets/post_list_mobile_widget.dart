import 'package:flutter/material.dart';

import '../data/models/post_model.dart';

class PostListMobileWidget extends StatelessWidget {
  const PostListMobileWidget({
    super.key,
    required this.posts,
    required this.children,
    required this.onTap,
  });
  final List<PostModel> posts;
  final List<Widget> Function(PostModel) children;
  final Function(PostModel) onTap;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(8.0),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            onTap(posts[index]);
          },
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: children(posts[index]),
              ),
            ),
          ),
        );
      },
    );
  }
}
