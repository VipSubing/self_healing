extension ListExtension<E> on List<E> {
  List<T> mapE<T>(T Function(E e, int i) toElement) {
    List<T> list = [];
    for (var i = 0; i < length; i++) {
      list.add(toElement(this[i], i));
    }
    return list;
  }

  eachE<T>(Function(E e, int i) toElement) {
    for (var i = 0; i < length; i++) {
      toElement(this[i], i);
    }
  }

  List<E> findE(bool Function(E e, int i) toElement) {
    List<E> list = [];
    for (var i = 0; i < length; i++) {
      if (toElement(this[i], i)) {
        list.add(this[i]);
      }
    }
    return list;
  }

  exchangeE(int index1, int index2) {
    E row = removeAt(index1);
    insert(index2, row);
  }

  List<E> copyE() {
    return List<E>.from(this);
  }
}
