sealed class Expression {
  int row;
  int col;
  Expression(this.row, this.col);
}

class DefunExpression implements Expression{
}
