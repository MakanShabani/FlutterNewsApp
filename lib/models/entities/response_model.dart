import '../entities/error_model.dart';

class ResponseModel<T> {
  T? data;
  ErrorModel? error;
  int statusCode;

  ResponseModel({this.data, this.error, required this.statusCode});
}
