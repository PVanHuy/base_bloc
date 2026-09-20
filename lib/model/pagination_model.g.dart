// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginationModel<T> _$PaginationModelFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => PaginationModel<T>(
  total: parseToInt(json['total']),
  models:
      (json['models'] as List<dynamic>?)?.map(fromJsonT).toList() ?? const [],
);

Map<String, dynamic> _$PaginationModelToJson<T>(
  PaginationModel<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'total': instance.total,
  'models': instance.models.map(toJsonT).toList(),
};
