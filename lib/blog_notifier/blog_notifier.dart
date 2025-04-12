import 'dart:typed_data';

import 'package:blog_rest_api/data/models/post_update_model.dart';
import 'package:blog_rest_api/data/models/updload_model.dart';
import 'package:blog_rest_api/data/services/api_service.dart';
import 'package:flutter/material.dart';

import '../data/models/post_model.dart';

class BlogNotifier extends ChangeNotifier {
  final BlogApiService _apiService = BlogApiService();

  void initService() {
    _apiService.initDio();
  }

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
    Uint8List? photo,
  }) async {
    try {
      UploadModel uploadModel = await _apiService.uploadPost(
        title: title,
        body: body,
        photo: photo,
      );
      getPostList();
      return uploadModel;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<PostOptionsModel> updatePost({
    required int id,
    required String title,
    required String body,
  }) async {
    try {
      PostOptionsModel postUpdateModel = await _apiService.updatePost(
        id: id,
        title: title,
        body: body,
      );
      getPost(id);
      getPostList();
      return postUpdateModel;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<PostOptionsModel> deletePost(int id) async {
    try {
      PostOptionsModel postOptionsModel = await _apiService.deletePost(id);
      getPostList();
      return postOptionsModel;
    } catch (e) {
      return Future.error(e);
    }
  }
}
