import '../shared_models/error_model.dart';

class ResponseDTO<T> {
  T? data;
  ErrorModel? error;
  int statusCode;

  ResponseDTO({this.data, this.error, required this.statusCode});
}
