// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mindfulness_media_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MindfulnessMediaModel _$MindfulnessMediaModelFromJson(
        Map<String, dynamic> json) =>
    MindfulnessMediaModel(
      name: json['name'] as String,
      duration: (json['duration'] as num).toInt(),
      src: json['src'] as String,
      type: $enumDecode(_$MindfulnessMediaTypeEnumMap, json['type']),
      isVideo: json['isVideo'] as bool? ?? false,
      cover: json['cover'] as String?,
    );

Map<String, dynamic> _$MindfulnessMediaModelToJson(
        MindfulnessMediaModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'duration': instance.duration,
      'isVideo': instance.isVideo,
      'src': instance.src,
      'type': _$MindfulnessMediaTypeEnumMap[instance.type]!,
      'cover': instance.cover,
    };

const _$MindfulnessMediaTypeEnumMap = {
  MindfulnessMediaType.other: 'other',
  MindfulnessMediaType.soga: 'soga',
  MindfulnessMediaType.meditation: 'meditation',
  MindfulnessMediaType.bodyScanning: 'bodyScanning',
  MindfulnessMediaType.walk: 'walk',
  MindfulnessMediaType.breathe: 'breathe',
  MindfulnessMediaType.diet: 'diet',
  MindfulnessMediaType.compassion: 'compassion',
};
