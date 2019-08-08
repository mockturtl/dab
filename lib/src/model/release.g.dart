// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'release.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PackageResponse _$PackageResponseFromJson(Map<String, dynamic> json) {
  return $checkedNew('PackageResponse', json, () {
    final val = PackageResponse(
      $checkedConvert(json, 'name', (v) => v as String),
      $checkedConvert(
          json,
          'versions',
          (v) => (v as List)
              .map((e) => Release.fromJson(e as Map<String, dynamic>))
              .toList()),
      $checkedConvert(
          json, 'latest', (v) => Release.fromJson(v as Map<String, dynamic>)),
    );
    return val;
  });
}

Map<String, dynamic> _$PackageResponseToJson(PackageResponse instance) =>
    <String, dynamic>{
      'name': instance.name,
      'versions': instance.versions,
      'latest': instance.latest,
    };

Release _$ReleaseFromJson(Map<String, dynamic> json) {
  return $checkedNew('Release', json, () {
    final val = Release(
      $checkedConvert(json, 'archive_url', (v) => Uri.parse(v as String)),
      $checkedConvert(
          json, 'pubspec', (v) => Pubspec.fromJson(v as Map<String, dynamic>)),
      $checkedConvert(json, 'version', (v) => v as String),
    );
    return val;
  }, fieldKeyMap: const {'archiveUrl': 'archive_url'});
}

Map<String, dynamic> _$ReleaseToJson(Release instance) => <String, dynamic>{
      'archive_url': instance.archiveUrl.toString(),
      'pubspec': instance.pubspec,
      'version': instance.version,
    };
