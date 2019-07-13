import 'dart:collection';

import 'package:pubspec_parse/pubspec_parse.dart';

/// Write a pubspec to a YAML file according to https://dart.dev/tools/pub/pubspec.
String toYaml(Pubspec p, [bool sort = true]) {
  final buf = StringBuffer()..writeln('name: ${p.name}');

  _writelnIfNonnull(buf, 'version', p.version);

  _writelnIfNonempty(buf, 'description', p.description);

  if (_exists(p.authors)) {
    buf.writeln('authors:');
    for (var a in p.authors) buf.writeln('- ${a}');
  }

  // FIXME: this is specified as a link, not a string
  _writelnIfNonempty(buf, 'homepage', p.homepage);

  _writelnIfNonnull(buf, 'repository', p.repository);

  _writelnIfNonnull(buf, 'issue_tracker', p.issueTracker);

  _writelnIfNonempty(buf, 'documentation', p.documentation);

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

  if (_exists(p.environment)) {
    buf.writeln();
    buf.writeln('environment:');
    _writelnIfNonempty(buf, '  sdk', p.environment['sdk']);
    _writelnIfNonempty(buf, '  flutter', p.environment['flutter']);
  }

// TODO: executables
//  if (_exists(p.executables)) {
//    buf.writeln();
//    buf.writeln('executables:');
//  }

  _writelnIfNonempty(buf, 'publish_to', p.publishTo);

  // TODO: flutter

  return buf.toString();
}

_exists(dynamic prop) => prop != null && prop.isNotEmpty;

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
  map.forEach((k, v) => buf.writeln('  $k: ${_toYaml(v)}'));
}

String _toYaml(Dependency d) {
  if (d is HostedDependency) return _getVersion(d); // FIXME: name, url
  if (d is PathDependency) return _getPath(d);
  if (d is SdkDependency) return _getSdk(d); // FIXME: sdk, version
  if (d is GitDependency) return _getGit(d); // FIXME: ref, path
  return '//FIXME: $d';
}

void _writelnIfNonempty(
    StringBuffer buf, String yamlKey, dynamic pubspecValue) {
  if (_exists(pubspecValue)) buf.writeln('$yamlKey: $pubspecValue');
}

void _writelnIfNonnull(StringBuffer buf, String yamlKey, dynamic pubspecValue) {
  if (pubspecValue != null) buf.writeln('$yamlKey: $pubspecValue');
}
