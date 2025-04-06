import 'package:blog_rest_api/blog_notifier/blog_notifier.dart';
import 'package:blog_rest_api/pages/blog_list_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BlogNotifier(),
      child: MaterialApp(
        title: 'Flutter Demo',
        home: BlogListPage(),
      ),
    );
  }
}
