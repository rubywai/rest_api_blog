import 'dart:io';

import 'package:blog_rest_api/data/models/updload_model.dart';
import 'package:blog_rest_api/data/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/models/post_model.dart';

class BlogNotifier extends ChangeNotifier {
  final BlogApiService _apiService = BlogApiService();

  List<PostModel> postList = [];
  PostModel? postModel;
  Future<void> getPostList() async {
    try {
      postList = await _apiService.getPostList();
      notifyListeners();
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<void> getPost(int id) async {
    try {
      postModel = await _apiService.getPost(id);
      notifyListeners();
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<UploadModel> uploadPost({
    required String title,
    required String body,
    File? photo,
  }) async {
    try {
      UploadModel uploadModel = await _apiService.uploadPost(
        title: title,
        body: body,
        photo: photo,
      );
      return uploadModel;
    } catch (e) {
      return Future.error(e);
    }
  }
}
