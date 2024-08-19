import 'package:tll/parse/expression/expression.dart';

sealed class ContainerActionResult {}

class ContainerActionSuccess implements ContainerActionResult {}

class ContainerActionFailure implements ContainerActionResult {}

class ExpressionContainer<T extends Expression> {
  Map<String, T> storage = {};
  ContainerActionResult add(String name, T value) {
    if (storage[name] != null) {
      return ContainerActionFailure();
    }
    storage[name] = value;
    return ContainerActionSuccess();
  }

  bool has(String name){
    return storage[name] != null;
  }

  T? get(String name){
    return storage[name];
  }
}
