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
      desc: json['desc'] as String?,
    );

Map<String, dynamic> _$MindfulnessMediaModelToJson(
        MindfulnessMediaModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'duration': instance.duration,
      'isVideo': instance.isVideo,
      'src': instance.src,
      'desc': instance.desc,
      'type': _$MindfulnessMediaTypeEnumMap[instance.type]!,
      'cover': instance.cover,
    };

const _$MindfulnessMediaTypeEnumMap = {
  MindfulnessMediaType.other: '其他',
  MindfulnessMediaType.soga: '瑜伽',
  MindfulnessMediaType.meditation: '静坐',
  MindfulnessMediaType.bodyScanning: '身体扫描',
  MindfulnessMediaType.walk: '行走',
  MindfulnessMediaType.breathe: '呼吸',
  MindfulnessMediaType.diet: '饮食',
  MindfulnessMediaType.compassion: '慈悲心',
  MindfulnessMediaType.sport: '运动',
};
