import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

// General failures
class ServerFailure extends Failure {}
class PlatformFailure extends Failure {}
class AssetFailure extends Failure {}
class InternalFailure extends Failure {}