import 'package:equatable/equatable.dart';

abstract class Either<L, R> extends Equatable {
  const Either();
  
  @override
  List<Object?> get props => [];
  
  bool get isLeft;
  bool get isRight;
  
  L? get left;
  R? get right;
  
  T fold<T>(T Function(L left) ifLeft, T Function(R right) ifRight);
}

class Left<L, R> extends Either<L, R> {
  final L _value;
  
  const Left(this._value);
  
  @override
  bool get isLeft => true;
  
  @override
  bool get isRight => false;
  
  @override
  L? get left => _value;
  
  @override
  R? get right => null;
  
  @override
  T fold<T>(T Function(L left) ifLeft, T Function(R right) ifRight) {
    return ifLeft(_value);
  }
  
  @override
  List<Object?> get props => [_value];
}

class Right<L, R> extends Either<L, R> {
  final R _value;
  
  const Right(this._value);
  
  @override
  bool get isLeft => false;
  
  @override
  bool get isRight => true;
  
  @override
  L? get left => null;
  
  @override
  R? get right => _value;
  
  @override
  T fold<T>(T Function(L left) ifLeft, T Function(R right) ifRight) {
    return ifRight(_value);
  }
  
  @override
  List<Object?> get props => [_value];
}