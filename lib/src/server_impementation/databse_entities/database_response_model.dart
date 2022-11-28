import 'databse_error_model.dart';

class DatabseResponseModel<T> {
  T? data;
  DatabseErrorModel? error;
  int statusCode;

  DatabseResponseModel({this.data, this.error, required this.statusCode});
}
