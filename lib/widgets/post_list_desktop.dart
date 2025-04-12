import 'package:flutter/material.dart';

import '../data/models/post_model.dart';

class PostListDesktop extends StatelessWidget {
  const PostListDesktop({
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
    return GridView.builder(
      itemCount: posts.length,
      gridDelegate:
          SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 200.0),
      itemBuilder: (context, index) {
        PostModel post = posts[index];
        return InkWell(
          onTap: () {
            onTap(post);
          },
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: children(post),
              ),
            ),
          ),
        );
      },
    );
  }
}
