import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gdsctokyo/util/json_converter.dart';

part '_result.freezed.dart';
part '_result.g.dart';

@Freezed(genericArgumentFactories: true)
class Result<T> with _$Result<T> {
  const factory Result({T? data, @ResultErrorConverter() ResultError? error}) =
      ResultData<T>;

  factory Result.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =>
      _$ResultFromJson(json, fromJsonT);
}

class ResultError {
  ResultError({this.message, this.code});
  String? message;
  String? code;
}
