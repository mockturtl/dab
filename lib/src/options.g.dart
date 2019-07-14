// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'options.dart';

// **************************************************************************
// CliGenerator
// **************************************************************************

Options _$parseOptionsResult(ArgResults result) => Options(
    result['filename'] as String,
    result['sort'] as bool,
    result['update'] as bool,
    result['dry-run'] as bool,
    result['scp'] as bool);

ArgParser _$populateOptionsParser(ArgParser parser) => parser
  ..addFlag('scp', help: 'Write ssh URLs with scp syntax.', defaultsTo: true)
  ..addOption('filename',
      abbr: 'f', help: 'Pubspec file to edit', defaultsTo: 'pubspec.yaml')
  ..addFlag('dry-run',
      abbr: 'n',
      help: 'Only print the modified pubspec, without overwriting the file.',
      defaultsTo: false)
  ..addFlag('sort',
      abbr: 's', help: 'Sort list output alphabetically.', defaultsTo: true)
  ..addFlag('update',
      abbr: 'u',
      help: 'Run "pub get" with the new pubspec.',
      defaultsTo: false);

final _$parserForOptions = _$populateOptionsParser(ArgParser());

Options parseOptions(List<String> args) {
  final result = _$parserForOptions.parse(args);
  return _$parseOptionsResult(result);
}
