import '../../server_impementation/databse_entities/databse_entities.dart';

class ErrorModel {
  String message;
  String? detail;
  int? statusCode;

  ErrorModel({required this.message, this.detail, this.statusCode});

  factory ErrorModel.fromFakeDatabaseError(
      DatabseErrorModel databaseErrorModel) {
    return ErrorModel(
        message: databaseErrorModel.message,
        statusCode: databaseErrorModel.statusCode,
        detail: databaseErrorModel.detail);
  }
}
