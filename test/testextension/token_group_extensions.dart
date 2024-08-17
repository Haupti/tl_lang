import 'package:tll/parse/collect/token_group.dart';

extension Show on TokenGroup {
  String show() {
    switch (this) {
      case SingleTokenGroup s:
        return s.token.show;
      case ExpressionTokenGroup e:
        return "${e.first.token.show} ${e.arguments.map((inner) => inner.show()).join(" ")}";
    }
  }
}
