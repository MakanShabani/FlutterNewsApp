import 'package:equatable/equatable.dart';

class PagingOptionsDTO extends Equatable {
  late int limit;
  late int offset;

  PagingOptionsDTO({int? limit, int? offset}) {
    if (limit == null || limit <= 0) {
      this.limit = 10;
    } else {
      this.limit = limit;
    }

    if (offset == null || offset <= 0) {
      this.offset = 0;
    } else {
      this.offset = offset;
    }
  }

  @override
  List<Object?> get props => [offset, limit];
}
