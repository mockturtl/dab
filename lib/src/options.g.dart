// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'options.dart';

// **************************************************************************
// CliGenerator
// **************************************************************************

Options _$parseOptionsResult(ArgResults result) => Options(
    result['filename'] as String,
    result['sort'] as bool,
    result['update'] as bool,
    result['dry-run'] as bool);

ArgParser _$populateOptionsParser(ArgParser parser) => parser
  ..addOption('filename',
      abbr: 'f', help: 'Pubspec file to edit', defaultsTo: 'pubspec.yaml')
  ..addFlag('sort',
      abbr: 's',
      help: 'If true, sort list output alphabetically.',
      defaultsTo: true)
  ..addFlag('dry-run',
      abbr: 'n',
      help:
          'If true, only print the modified pubspec, without overwriting the file.',
      defaultsTo: false)
  ..addFlag('update',
      abbr: 'u',
      help: 'If true, run `pub get` with the new pubspec.',
      defaultsTo: false);

final _$parserForOptions = _$populateOptionsParser(ArgParser());

Options parseOptions(List<String> args) {
  final result = _$parserForOptions.parse(args);
  return _$parseOptionsResult(result);
}
