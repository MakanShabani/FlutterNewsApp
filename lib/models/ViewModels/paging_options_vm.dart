class PagingOptionsVm {
  late int limit;
  late int offset;

  PagingOptionsVm({int? limit, int? offset}) {
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
}
