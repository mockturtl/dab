import 'package:args/args.dart';
import 'package:build_cli_annotations/build_cli_annotations.dart';

part 'options.g.dart';

void addOptions(ArgParser psr) {
  psr.addOption(
    Opts.filename,
    abbr: 'f',
    defaultsTo: 'pubspec.yaml',
    help: 'pubspec filename',
  );
  psr.addFlag(
    Opts.sort,
    abbr: 's',
    help: 'sort dependencies alphabetically?',
    defaultsTo: true,
  );
}

@CliOptions()
// FIXME: nice idea, but no way to use with CommandRunner?
class Options {
  @CliOption(
    abbr: 'f',
    defaultsTo: 'pubspec.yaml',
    help: 'Pubspec file to edit',
  )
  final String f;

  @CliOption(
      abbr: 's',
      help: 'If true, dependencies will sort alphabetically.',
      defaultsTo: true)
  final bool sort;

  Options(this.f, this.sort);
}

class Opts {
  static const filename = 'filename';
  static const sort = 'sort';
}
