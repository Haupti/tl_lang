sealed class SmartMapActionResult {}

class SmartMapActionSuccess implements SmartMapActionResult {}

class SmartMapActionFailure implements SmartMapActionResult {}

class SmartMap<T> {
  Map<String, T> storage = {};
  SmartMapActionResult add(String name, T value) {
    if (storage[name] != null) {
      return SmartMapActionFailure();
    }
    storage[name] = value;
    return SmartMapActionSuccess();
  }

  bool has(String name){
    return storage[name] != null;
  }

  T? get(String name){
    return storage[name];
  }
}
