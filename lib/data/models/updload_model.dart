class UploadModel {
  final String? result;

  UploadModel({required this.result});

  factory UploadModel.fromJson(Map<String, dynamic> json) {
    return UploadModel(result: json['result']);
  }
}
