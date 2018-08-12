import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:dotenv/dotenv.dart';
import 'package:http/http.dart' as http;

/// Creates a remote repository.
///
/// ## usage
///
///     dab init --help
void main(List<String> args) async {
  load(); // TODO: configurable file
  var opts = _argPsr.parse(args);

  if (opts['help'] == true) {
    _p('init creates a new project through the GitLab API.');
    _help();
    exit(0);
  }

  if (opts.rest.length != 1) {
    _pErr('ERROR: Too many arguments.');
    _help();
    exit(1);
  }

  final name = opts.rest[0];

  validateEnv();

  await _gitlabCreateProject(env['gitlab_token'], name);
}

const gitlab_v4_create = 'https://gitlab.com/api/v4/projects?name=';

final _argPsr = ArgParser()
  ..addFlag('help', abbr: 'h', negatable: false, help: 'Print this help text.');

void validateEnv() {
  const _gitlabToken = 'gitlab_token';
  const _required = [_gitlabToken];

  final out = isEveryDefined(_required);
  if (!out) {
    _pErr('A required env var (${_required}) is missing! Aborting.');
    exit(11);
  }
}

Map<String, String> _buildHeaders(String token) => {"Private-Token": token};

Future _gitlabCreateProject(String token, String name) async {
  final uri = Uri.https('gitlab.com', '/api/v4/projects', {'name': name});
  final res = await http.post(
    uri.toString(),
    headers: _buildHeaders(token),
  );
  final Map<String, dynamic> body = jsonDecode(res?.body);
  switch (res.statusCode) {
    case 201:
      _p('Created ${body['web_url']}');
      break;
    default:
      stderr.writeln('${res.statusCode} body');
  }
}

void _help() {
  _p('Usage: dab init <project_name>');
  _p('  ${_argPsr.usage}');
}

void _p(msg) => stdout.writeln(msg);

void _pErr(msg) => stderr.writeln(msg);
