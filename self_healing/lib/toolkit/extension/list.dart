extension ListExtension<E> on List<E> {
  List<T> mapE<T>(T Function(E e, int i) toElement) {
    List<T> list = [];
    for (var i = 0; i < length; i++) {
      list.add(toElement(this[i], i));
    }
    return list;
  }
}
