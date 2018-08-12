// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'release.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PackageResponse _$PackageResponseFromJson(Map<String, dynamic> json) {
  return PackageResponse(
      json['name'] as String,
      (json['versions'] as List)
          ?.map((e) =>
              e == null ? null : Release.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['latest'] == null
          ? null
          : Release.fromJson(json['latest'] as Map<String, dynamic>));
}

Map<String, dynamic> _$PackageResponseToJson(PackageResponse instance) =>
    <String, dynamic>{
      'name': instance.name,
      'versions': instance.versions,
      'latest': instance.latest
    };

Release _$ReleaseFromJson(Map<String, dynamic> json) {
  return Release(
      Uri.parse(json['archive_url'] as String),
      Pubspec.fromJson(json['pubspec'] as Map<String, dynamic>),
      json['version'] as String);
}

Map<String, dynamic> _$ReleaseToJson(Release instance) => <String, dynamic>{
      'archive_url': instance.archiveUrl.toString(),
      'pubspec': instance.pubspec,
      'version': instance.version
    };
