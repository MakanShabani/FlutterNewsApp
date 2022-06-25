class ErrorModel {
  String message;
  String? detail;
  int? statusCode;

  ErrorModel({required this.message, this.detail, this.statusCode});
}
