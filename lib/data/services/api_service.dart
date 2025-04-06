import 'dart:io';

import 'package:blog_rest_api/data/models/updload_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

import '../../const/url_const.dart';
import '../models/post_model.dart';

class BlogApiService {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: UrlConst.baseUrl),
  );
  Future<List<PostModel>> getPostList() async {
    final response = await _dio.get(UrlConst.all);
    List<dynamic> list = response.data as List;
    return list.map((e) {
      return PostModel.fromJson(e);
    }).toList();
  }

  Future<PostModel> getPost(int id) async {
    final response = await _dio.get(
      '${UrlConst.post}?id=$id',
    );
    List<dynamic> list = response.data as List;
    return PostModel.fromJson(list.first);
  }

  Future<UploadModel> uploadPost({
    required String title,
    required String body,
    File? photo,
  }) async {
    FormData? formData;
    if (photo != null) {
      formData = FormData.fromMap({
        'photo': await MultipartFile.fromFile(photo.path),
      });
    }
    final response = await _dio.post(
      '${UrlConst.post}?title=$title&body=$body',
      data: formData,
    );
    return UploadModel.fromJson(response.data);
  }
}
