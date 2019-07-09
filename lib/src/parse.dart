import 'dart:collection';

import 'package:pubspec_parse/pubspec_parse.dart';

String toYaml(Pubspec p, [bool sort = true]) {
  final buf = StringBuffer()
    ..writeln('name: ${p.name}')
    ..writeln('description: ${p.description}')
    ..writeln('version: ${p.version}');

  if (_exists(p.authors)) {
    buf.writeln(p.authors.length == 1
        ? 'author: ${p.authors.first}'
        : 'authors: ${p.authors}');
  }

  if (_exists(p.homepage)) buf.writeln('homepage: ${p.homepage}');

// TODO: executables
//  if (_exists(p.executables)) {
//    buf.writeln();
//    buf.writeln('executables:');
//  }

  if (_exists(p.environment)) {
    buf.writeln();
    buf.writeln('environment:');
    buf.writeln("  sdk: '${p.environment['sdk']}'");
  }

  if (_exists(p.dependencies)) {
    buf.writeln();
    buf.writeln('dependencies:');
    _mapToYaml(p.dependencies, buf, sort);
  }

  if (_exists(p.devDependencies)) {
    buf.writeln();
    buf.writeln('dev_dependencies:');
    _mapToYaml(p.devDependencies, buf, sort);
  }

  if (_exists(p.dependencyOverrides)) {
    buf.writeln();
    buf.writeln('dependency_overrides:');
    _mapToYaml(p.dependencyOverrides, buf, sort);
  }

  return buf.toString();
}

bool _exists(dynamic prop) => prop != null && prop.isNotEmpty;

String _getGit(GitDependency d) {
  var path = '$d'.split('@')[1];
  return '\n    git: $path';
}

String _getPath(PathDependency d) {
  var path = '$d'.split('@')[1];
  return '\n    path: $path';
}

String _getSdk(SdkDependency d) {
  return '\n    sdk: flutter\n    version: ${_getVersion(d)}';
}

String _getVersion(Dependency d) => d.toString().split('Dependency: ')[1];

void _mapToYaml(Map<String, Dependency> map, StringBuffer buf, bool sort) {
  if (sort) map = SplayTreeMap.from(map);
  map.forEach((k, v) {
    buf.writeln('  $k: ${_toYaml(v)}');
  });
}

String _toYaml(Dependency d) {
  if (d is HostedDependency) return _getVersion(d); // FIXME: name, url
  if (d is PathDependency) return _getPath(d);
  if (d is SdkDependency) return _getSdk(d); // FIXME: sdk, version
  if (d is GitDependency) return _getGit(d); // FIXME: ref, path
  return '//FIXME: $d';
}
