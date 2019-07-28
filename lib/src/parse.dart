import 'dart:collection';
import 'dart:developer';

import 'package:logging/logging.dart';
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:yaml/yaml.dart';

const _assets = 'assets';

const _family = 'family';

const _flutter = 'flutter';

const _fontAsset = 'asset';

const _fonts = 'fonts';

const _style = 'style';

const _tag = 'dab.parse';

const _usesMaterialDesign = 'uses-material-design';

const _weight = 'weight';

/// Write a [Pubspec] to a YAML file according to https://dart.dev/tools/pub/pubspec.
String toYaml(Pubspec p, [bool sort = true, bool scpSyntax = true]) {
  final buf = StringBuffer()..writeln('name: ${p.name}');

  _writelnIfNonnull(buf, 'version', p.version);

  _writelnIfNonempty(buf, 'description', p.description);

  if (_has(p.authors)) {
    buf.writeln('authors:');
    for (var a in p.authors) {
      buf.writeln('  - ${a}');
    }
  }

  // FIXME: this is specified as a link, not a string
  _writelnIfNonempty(buf, 'homepage', p.homepage);

  _writelnIfNonnull(buf, 'repository', p.repository);

  _writelnIfNonnull(buf, 'issue_tracker', p.issueTracker);

  _writelnIfNonempty(buf, 'documentation', p.documentation);

  if (_has(p.dependencies)) {
    buf.writeln();
    buf.writeln('dependencies:');
    _depsToYaml(p.dependencies, buf, sort, scpSyntax);
  }

  if (_has(p.devDependencies)) {
    buf.writeln();
    buf.writeln('dev_dependencies:');
    _depsToYaml(p.devDependencies, buf, sort, scpSyntax);
  }

  if (_has(p.dependencyOverrides)) {
    buf.writeln();
    buf.writeln('dependency_overrides:');
    _depsToYaml(p.dependencyOverrides, buf, sort, scpSyntax);
  }

  if (_has(p.environment)) {
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

  _flutterToYaml(buf, p.flutter);

  return buf.toString();
}

void _depsToYaml(Map<String, Dependency> map, StringBuffer buf, bool sort,
    bool useScpSyntax) {
  if (sort) map = SplayTreeMap.from(map);

  // always sort Flutter to the top
  if (map.containsKey(_flutter)) {
    var flutterDep = map.remove(_flutter);
    _writeDependency(buf, _flutter, flutterDep, false);
  }
  map.forEach((k, v) => _writeDependency(buf, k, v, useScpSyntax));
}

void _flutterToYaml(StringBuffer buf, Map<String, dynamic> flutter) {
  if (!_has(flutter)) return;

  buf.writeln();
  buf.writeln('flutter:');

  _writelnIfNonnull(
      buf, '  $_usesMaterialDesign', flutter[_usesMaterialDesign]);

  if (_has(flutter[_assets])) {
    buf.writeln('  assets:');
    var assets = List.castFrom<dynamic, String>(flutter[_assets]);
    assets.forEach((a) => buf.writeln('    - $a'));
  }

  if (_has(flutter[_assets])) {
    buf.writeln('  fonts:');
    var families = List.castFrom<dynamic, YamlMap>(flutter[_fonts]);
    families.forEach((fam) {
      buf.writeln('    - family: ${fam[_family]}');
      buf.writeln('      fonts:');
      var fonts = List.castFrom<dynamic, YamlMap>(fam[_fonts]);
      fonts.forEach((f) {
        buf.writeln('        - asset: ${f[_fontAsset]}');
        _writelnIfNonnull(buf, '          weight', f[_weight]);
        _writelnIfNonnull(buf, '          style', f[_style]);
      });
    });
  }
}

_has(dynamic prop) => prop != null && prop.isNotEmpty;

void _writeDependency(
    StringBuffer buf, String package, Dependency value, bool useScpSyntax) {
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
      w = _GitDepWriter(useScpSyntax);
      break;
    default:
      log('dependency $package has unhandled concrete type. Check your pubspec.',
          level: Level.SEVERE.value, name: _tag);
  }

  w.write(buf, package, value);
}

void _writelnIfNonempty(
    StringBuffer buf, String yamlKey, dynamic pubspecValue) {
  if (_has(pubspecValue)) buf.writeln('$yamlKey: $pubspecValue');
}

void _writelnIfNonnull(StringBuffer buf, String yamlKey, dynamic pubspecValue) {
  if (pubspecValue != null) buf.writeln('$yamlKey: $pubspecValue');
}

class _GitDepWriter implements _Writer {
  final bool isScpSyntax;

  _GitDepWriter(this.isScpSyntax);

  @override
  void write(StringBuffer buf, String package, covariant GitDependency value) {
    buf.writeln('  $package:');
    buf.write('    git:');

    var hasRef = _has(value.ref);
    var hasPath = _has(value.path);
    var url = '${value.url}';
    if (isScpSyntax) url = _sshToScp(url);

    if (!hasRef && !hasPath) {
      buf.writeln(' $url');
      return;
    }

    buf.writeln();
    buf.writeln('      url: $url');
    if (hasRef) buf.writeln('      ref: ${value.ref}');
    if (hasPath) buf.writeln('      path: ${value.path}');
  }

  // pubspec_parse accepts scp syntax for git links.  See _tryParseScpUri.
  // https://github.com/dart-lang/pubspec_parse/blob/master/lib/src/dependency.dart#L136
  String _sshToScp(String url) => (url.contains('ssh://'))
      ? url.replaceFirst('ssh://', '').replaceFirst('/', ':')
      : url;
}

class _HostedDepWriter implements _Writer {
  @override
  void write(
      StringBuffer buf, String package, covariant HostedDependency value) {
    buf.write('  $package:');
    if (value.hosted == null) {
      buf.writeln(' ${value.version}');
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
    buf.writeln('    path: ${value.path}');
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
