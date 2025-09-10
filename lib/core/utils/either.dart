abstract class Either<L, R> {
  const Either();

  bool isLeft() => this is Left<L, R>;
  bool isRight() => this is Right<L, R>;

  L get left => (this as Left<L, R>).value;
  R get right => (this as Right<L, R>).value;

  T fold<T>(T Function(L left) fnL, T Function(R right) fnR) {
    if (isLeft()) {
      return fnL(left);
    } else {
      return fnR(right);
    }
  }
}

class Left<L, R> extends Either<L, R> {
  const Left(this.value);
  final L value;
}

class Right<L, R> extends Either<L, R> {
  const Right(this.value);
  final R value;
}