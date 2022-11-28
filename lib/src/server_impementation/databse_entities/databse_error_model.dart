class DatabseErrorModel {
  String message;
  String? detail;
  int? statusCode;

  DatabseErrorModel({required this.message, this.detail, this.statusCode});
}
