import 'package:args/args.dart';
import 'package:build_cli_annotations/build_cli_annotations.dart';

part 'options.g.dart';

@CliOptions()
class Options {
  @CliOption(
      abbr: 'f', defaultsTo: 'pubspec.yaml', help: 'Pubspec file to edit')
  final String filename;

  @CliOption(
      abbr: 's',
      defaultsTo: true,
      help: 'If true, dependencies will sort alphabetically.')
  final bool sort;

  @CliOption(
      abbr: 'u', defaultsTo: false, help: 'If true, runs pub get immediately.')
  final bool update;

  const Options(this.filename, this.sort, this.update);

  factory Options.from(ArgResults value) => _$parseOptionsResult(value);

  static populate(ArgParser parser) => _$populateOptionsParser(parser);
}

class Opts {
  static const filename = 'filename';
  static const sort = 'sort';
}
