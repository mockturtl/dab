import 'dart:io';

import 'package:dab/dab.dart';
import 'package:pub_semver/pub_semver.dart' show VersionConstraint;
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:yamlicious/yamlicious.dart' show writeYamlString;

main(List<String> arguments) async {
  if (arguments.isEmpty) {
    print('No package provided.');
    exit(1);
  }
  var pkg = arguments.first ?? '';
  print('Fetching $pkg...');
  var res = (await latest(pkg));
  print('${res.name} ${res.version}');

  var p = Pubspec.parse(await File('pubspec.yaml').readAsString());
  print('${p.name} ${p.dependencies}');
  p.dependencies.putIfAbsent(
      res.name,
      () => HostedDependency(
          version: VersionConstraint.parse('^${res.version}')));
  print('${p.name} ${p.dependencies}');

  var g = File('test.yaml').openWrite();

  writeYamlString(p.toJson(), g);
}
