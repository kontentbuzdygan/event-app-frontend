// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewEvent _$NewEventFromJson(Map<String, dynamic> json) => NewEvent(
      title: json['title'] as String,
      description: json['description'] as String,
      startsAt: DateTime.parse(json['startsAt'] as String),
      endsAt: json['endsAt'] == null
          ? null
          : DateTime.parse(json['endsAt'] as String),
    );

Map<String, dynamic> _$NewEventToJson(NewEvent instance) => <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'startsAt': instance.startsAt.toIso8601String(),
      'endsAt': instance.endsAt?.toIso8601String(),
    };
