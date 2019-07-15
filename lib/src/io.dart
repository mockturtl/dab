import 'dart:convert';
import 'dart:io';

import 'package:dab/src/model/release.dart';
import 'package:http/http.dart' as http;
import 'package:pubspec_parse/pubspec_parse.dart';

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
