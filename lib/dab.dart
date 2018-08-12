import 'dart:convert';

import 'package:dab/src/model/release.dart';
import 'package:http/http.dart' as http;

export 'src/model/release.dart';

Future<PackageResponse> all(String packageName) async {
  final res = await http.get('https://pub.dev/api/packages/$packageName');

  // FIXME: handle errors
  print('${res.statusCode}');

  final Map<String, dynamic> json = jsonDecode(res.body);
  final out = PackageResponse.fromJson(json);

  print('${out.versions.length} versions');

  return out;
}

Future<Release> latest(String packageName) async =>
    (await all(packageName)).latest;
