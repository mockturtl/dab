// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'options.dart';

// **************************************************************************
// CliGenerator
// **************************************************************************

Options _$parseOptionsResult(ArgResults result) =>
    Options(result['filename'] as String, result['sort'] as bool);

ArgParser _$populateOptionsParser(ArgParser parser) => parser
  ..addOption('filename',
      abbr: 'f', help: 'Pubspec file to edit', defaultsTo: 'pubspec.yaml')
  ..addFlag('sort',
      abbr: 's',
      help: 'If true, dependencies will sort alphabetically.',
      defaultsTo: true);

final _$parserForOptions = _$populateOptionsParser(ArgParser());

Options parseOptions(List<String> args) {
  final result = _$parserForOptions.parse(args);
  return _$parseOptionsResult(result);
}
