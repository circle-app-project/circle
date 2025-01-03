import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  final String? message;
  final String? code;
  final StackTrace? stackTrace;

  const Failure({this.message = "An error has occurred", this.code, this.stackTrace});
  const Failure.generic({this.message = "An error has occurred", this.code, this.stackTrace});
  const Failure.firebase({this.message = "An error has occurred", this.code, this.stackTrace});
  const Failure.network({this.message = "An error has occurred", this.code, this.stackTrace});
  const Failure.storage({this.message = "An error has occurred", this.code, this.stackTrace});

  @override
  List<Object?> get props => [message, code, stackTrace];
}
