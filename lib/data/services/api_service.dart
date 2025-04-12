import 'dart:typed_data';

import 'package:blog_rest_api/data/models/post_update_model.dart';
import 'package:blog_rest_api/data/models/updload_model.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../const/url_const.dart';
import '../models/post_model.dart';

class BlogApiService {
  late Dio _dio;
  void initDio() {
    _dio = Dio(
      BaseOptions(baseUrl: UrlConst.baseUrl),
    );
    _dio.interceptors.add(PrettyDioLogger(
      responseHeader: true,
    ));
  }

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
    Uint8List? photo,
  }) async {
    FormData? formData;
    if (photo != null) {
      formData = FormData.fromMap({
        'photo': MultipartFile.fromBytes(photo),
      });
    }
    final response = await _dio.post(
      '${UrlConst.post}?title=$title&body=$body',
      data: formData,
    );
    return UploadModel.fromJson(response.data);
  }

  Future<PostOptionsModel> updatePost({
    required String title,
    required body,
    required int id,
  }) async {
    final response = await _dio.put(UrlConst.post, queryParameters: {
      "id": id,
      "title": title,
      "body": body,
    });
    return PostOptionsModel.fromJson(response.data);
  }

  Future<PostOptionsModel> deletePost(int id) async {
    final response =
        await _dio.delete(UrlConst.post, queryParameters: {"id": id});
    return PostOptionsModel.fromJson(response.data);
  }
}
