// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MediaModel _$MediaModelFromJson(Map<String, dynamic> json) => MediaModel(
  url: json['url'] as String?,
  fileName: json['fileName'] as String?,
  width: (json['width'] as num?)?.toInt(),
  height: (json['height'] as num?)?.toInt(),
  ratio: (json['ratio'] as num?)?.toDouble(),
  type:
      $enumDecodeNullable(_$MediaTypeEnumMap, json['type']) ?? MediaType.image,
  duration: (json['duration'] as num?)?.toDouble() ?? 0,
  thumbnail: json['thumbnail'] as String?,
);

Map<String, dynamic> _$MediaModelToJson(MediaModel instance) =>
    <String, dynamic>{
      'url': instance.url,
      'fileName': instance.fileName,
      'width': instance.width,
      'height': instance.height,
      'ratio': instance.ratio,
      'type': _$MediaTypeEnumMap[instance.type]!,
      'thumbnail': instance.thumbnail,
      'duration': instance.duration,
    };

const _$MediaTypeEnumMap = {
  MediaType.all: 'all',
  MediaType.image: 'image',
  MediaType.video: 'video',
};
