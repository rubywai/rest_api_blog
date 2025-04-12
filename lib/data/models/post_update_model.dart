class PostOptionsModel {
  final String? result;
  PostOptionsModel(this.result);
  factory PostOptionsModel.fromJson(dynamic json) {
    return PostOptionsModel(json['result']);
  }
}
