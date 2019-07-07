import 'dart:convert';
import 'dart:io';

import 'package:dab/src/model/release.dart';
import 'package:http/http.dart' as http;
import 'package:pub_semver/pub_semver.dart' show VersionConstraint;
import 'package:pubspec_parse/pubspec_parse.dart';

Future<Pubspec> addDependency(Pubspec pubspec, Release res) async {
  pubspec.dependencies.putIfAbsent(
      res.name,
      () => HostedDependency(
          version: VersionConstraint.parse('^${res.version}')));
  return pubspec;
}

Future<Pubspec> addDevDependency(Pubspec pubspec, Release res) async {
  pubspec.devDependencies.putIfAbsent(
      res.name,
      () => HostedDependency(
          version: VersionConstraint.parse('^${res.version}')));
  return pubspec;
}

Future<PackageResponse> all(String packageName) async {
  final res = await http.get('https://pub.dev/api/packages/$packageName');
  // FIXME: handle errors
  final Map<String, dynamic> json = jsonDecode(res.body);
  return PackageResponse.fromJson(json);
}

Future<Release> latest(String packageName) async =>
    (await all(packageName)).latest;

Future<Pubspec> load([String filename = 'pubspec.yaml']) async {
  return Pubspec.parse(await File(filename).readAsString());
}

Future<Pubspec> remove(Pubspec pubspec, Release res) async {
  var k = res.name;
  pubspec.dependencies.remove(k);
  pubspec.devDependencies.remove(k);
  pubspec.dependencyOverrides.remove(k);
  return pubspec;
}
