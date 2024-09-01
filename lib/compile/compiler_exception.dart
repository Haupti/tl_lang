import 'package:tll/parse/expression/expression.dart';

class CompilerException implements Exception {
  final String message;
  final int row;
  final int col;

  @override
  String toString() {
    return "COMPILER-ERROR at ($row,$col): $message.";
  }

  CompilerException(this.message, this.row, this.col);

  static CompilerException atExpression(String message, Expression expression) {
    return CompilerException(
        message, expression.location.row, expression.location.col);
  }
}
