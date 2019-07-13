import 'dart:collection';
import 'dart:developer';

import 'package:logging/logging.dart';
import 'package:pubspec_parse/pubspec_parse.dart';

const _flutter = 'flutter';

const _tag = 'dab.parse';

/// Write a pubspec to a YAML file according to https://dart.dev/tools/pub/pubspec.
String toYaml(Pubspec p, [bool sort = true]) {
  final buf = StringBuffer()..writeln('name: ${p.name}');

  _writelnIfNonnull(buf, 'version', p.version);

  _writelnIfNonempty(buf, 'description', p.description);

  if (_exists(p.authors)) {
    buf.writeln('authors:');
    for (var a in p.authors) buf.writeln('  - ${a}');
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
    _writelnIfNonnull(buf, '  sdk',
        "'${p.environment['sdk']}'"); // upper sdk bound requires single-quote wrapping
    _writelnIfNonnull(buf, '  flutter', p.environment['flutter']);
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

String _getVersion(Dependency d) => d.toString().split('Dependency: ')[1];

void _mapToYaml(Map<String, Dependency> map, StringBuffer buf, bool sort) {
  if (sort) map = SplayTreeMap.from(map);

  // always sort Flutter to the top
  if (map.containsKey(_flutter)) {
    var flutterDep = map.remove(_flutter);
    _writeDependency(buf, _flutter, flutterDep);
  }
  map.forEach((k, v) => _writeDependency(buf, k, v));
}

void _writeDependency(StringBuffer buf, String package, Dependency value) {
  _Writer w = _NilDepWriter();
  switch (value.runtimeType) {
    case HostedDependency:
      w = _HostedDepWriter();
      break;
    case PathDependency:
      w = _PathDepWriter();
      break;
    case SdkDependency:
      w = _SdkDepWriter();
      break;
    case GitDependency:
      w = _GitDepWriter();
      break;
    default:
      log('dependency $package has unhandled concrete type. Check your pubspec.',
          level: Level.SEVERE.value, name: _tag);
  }

  w.write(buf, package, value);
}

void _writelnIfNonempty(
    StringBuffer buf, String yamlKey, dynamic pubspecValue) {
  if (_exists(pubspecValue)) buf.writeln('$yamlKey: $pubspecValue');
}

void _writelnIfNonnull(StringBuffer buf, String yamlKey, dynamic pubspecValue) {
  if (pubspecValue != null) buf.writeln('$yamlKey: $pubspecValue');
}

class _GitDepWriter implements _Writer {
  @override
  void write(StringBuffer buf, String package, covariant GitDependency value) {
    buf.writeln('  $package:');
    buf.write('    git:');

    var hasRef = _exists(value.ref);
    var hasPath = _exists(value.path);
    var url =
        '$value'.split('GitDependency: url@')[1].replaceFirst('ssh://', '');
    // if userinfo is present, parsing replaces the separator with a slash
    if (url.contains('@')) url = url.replaceFirst('/', ':');

    if (!hasRef && !hasPath) {
      buf.writeln(' $url');
      return;
    }

    buf.writeln();
    buf.writeln('      url: $url');
    if (hasRef) buf.writeln('      ref: ${value.ref}');
    if (hasPath) buf.writeln('      path: ${value.path}');
  }
}

class _HostedDepWriter implements _Writer {
  @override
  void write(
      StringBuffer buf, String package, covariant HostedDependency value) {
    buf.write('  $package:');
    if (value.hosted == null) {
      buf.writeln(' ${_getVersion(value)}');
      return;
    }
    var h = value.hosted;
    buf.writeln();
    buf.writeln('    hosted:');
    buf.writeln('      name: ${h.name}');
    buf.writeln('      url: ${h.url}');
  }
}

class _NilDepWriter implements _Writer {
  @override
  void write(StringBuffer buf, String package, Dependency value) {
    buf.writeln('  //FIXME: $package: $value');
  }
}

class _PathDepWriter implements _Writer {
  @override
  void write(StringBuffer buf, String package, covariant PathDependency value) {
    buf.writeln('  $package:');
    var path = '$value'.split('@')[1];
    buf.writeln('    path: $path');
  }
}

class _SdkDepWriter implements _Writer {
  @override
  void write(StringBuffer buf, String package, covariant SdkDependency value) {
    buf.writeln('  $package:');
    buf.writeln('    sdk: ${value.sdk}');
    _writelnIfNonnull(buf, '    version', value.version);
  }
}

abstract class _Writer {
  void write(StringBuffer buf, String package, Dependency value);
}
