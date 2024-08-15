class LexerException implements Exception {
  final String message;
  final int row;
  final int col;
  LexerException(this.message, this.row, this.col);
  @override
  String toString() => "ERROR at ($row|$col): $message.";
}

