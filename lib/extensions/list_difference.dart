extension WhereNotInExt<T> on Iterable<T> {
  Iterable<T> whereNotIn(Iterable<T> reject) {
    final rejectSet = reject.toSet();
    return where((el) => !rejectSet.contains(el));
  }
}
