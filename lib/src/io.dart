import 'dart:convert';
import 'dart:io';

import 'package:dab/src/model/release.dart';
import 'package:http/http.dart' as http;
import 'package:pub_semver/pub_semver.dart' show VersionConstraint;
import 'package:pubspec_parse/pubspec_parse.dart';

Pubspec addDependency(Pubspec pubspec, Release res) {
  pubspec.dependencies.putIfAbsent(res.name, () => _toHostedDependency(res));
  _printWarning();
  return pubspec;
}

Pubspec addDevDependency(Pubspec pubspec, Release res) {
  pubspec.devDependencies.putIfAbsent(res.name, () => _toHostedDependency(res));
  _printWarning();
  return pubspec;
}

Future<PackageResponse> allVersions(String packageName) async {
  final res = await http.get('https://pub.dev/api/packages/$packageName');
  // FIXME: handle errors
  final Map<String, dynamic> json = jsonDecode(res.body);
  return PackageResponse.fromJson(json);
}

Future<Release> latestVersion(String packageName) async =>
    (await allVersions(packageName)).latest;

Future<Pubspec> loadPubspec([String filename = 'pubspec.yaml']) async =>
    Pubspec.parse(await File(filename).readAsString());

Pubspec remove(Pubspec pubspec, Release res) {
  var k = res.name;
  pubspec.dependencies.remove(k);
  pubspec.devDependencies.remove(k);
  pubspec.dependencyOverrides.remove(k);
  _printWarning();
  return pubspec;
}

void _printWarning() {
  print('BEWARE: The current version of dab could mangle your pubspec!');
  print("In particular, it WILL eat your 'executables' section, pending");
  print('https://github.com/dart-lang/pubspec_parse/issues/49');
  print("Verify the changes: 'git diff pubspec.yaml'");
  print(
      'Did something break? Surprised? File an issue: https://github.com/mockturtl/dab/issues/new\n');
}

Dependency _toHostedDependency(Release res) =>
    HostedDependency(version: VersionConstraint.parse('^${res.version}'));
