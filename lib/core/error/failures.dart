import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

@freezed
class Failure with _$Failure {
  const factory Failure.database(String message) = DatabaseFailure;
  const factory Failure.notFound(String message) = NotFoundFailure;
  const factory Failure.unexpected(String message) = UnexpectedFailure;
}
