class SmartMap<T> {
  Map<String, T> storage = {};
  void add(String name, T value) {
    if (storage[name] != null) {
      throw Exception(
          "BUG: this should not occur, check if this name is taken");
    }
    storage[name] = value;
  }

  bool has(String name) {
    return storage[name] != null;
  }

  T? get(String name) {
    return storage[name];
  }

  SmartMap.init(Map<String, T> map): storage = map;
  SmartMap();
}
