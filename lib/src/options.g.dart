// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'options.dart';

// **************************************************************************
// CliGenerator
// **************************************************************************

Options _$parseOptionsResult(ArgResults result) => Options(
    result['filename'] as String,
    result['sort'] as bool,
    result['update'] as bool);

ArgParser _$populateOptionsParser(ArgParser parser) => parser
  ..addOption('filename',
      abbr: 'f', help: 'Pubspec file to edit', defaultsTo: 'pubspec.yaml')
  ..addFlag('sort',
      abbr: 's',
      help: 'If true, list output is sorted alphabetically.',
      defaultsTo: true)
  ..addFlag('update',
      abbr: 'u', help: 'If true, runs pub get immediately.', defaultsTo: false);

final _$parserForOptions = _$populateOptionsParser(ArgParser());

Options parseOptions(List<String> args) {
  final result = _$parserForOptions.parse(args);
  return _$parseOptionsResult(result);
}
