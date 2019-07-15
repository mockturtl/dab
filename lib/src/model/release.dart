import 'package:json_annotation/json_annotation.dart';
import 'package:pub_semver/pub_semver.dart' show VersionConstraint;
import 'package:pubspec_parse/pubspec_parse.dart';

part 'release.g.dart';

@JsonSerializable()
class PackageResponse {
  static final nil = PackageResponse('', [], Release.nil);

  final String name;
  final List<Release> versions;
  final Release latest;

  const PackageResponse(this.name, this.versions, this.latest);

  factory PackageResponse.fromJson(Map<String, dynamic> json) =>
      _$PackageResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PackageResponseToJson(this);

  @override
  String toString() => toJson().toString();
}

@JsonSerializable()
class Release {
  static final nil = Release(Uri.parse(''), Pubspec(''), '');

  @JsonKey(fromJson: Uri.parse)
  final Uri archiveUrl;
  final Pubspec pubspec;
  final String version;

  const Release(
    this.archiveUrl,
    this.pubspec,
    this.version,
  );

  factory Release.fromJson(Map<String, dynamic> json) =>
      _$ReleaseFromJson(json);

  HostedDependency get asDependency =>
      HostedDependency(version: VersionConstraint.parse('^$version'));

  String get name => pubspec.name;

  Map<String, dynamic> toJson() => _$ReleaseToJson(this);

  @override
  String toString() => toJson().toString();
}
