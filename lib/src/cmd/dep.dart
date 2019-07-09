import 'package:args/command_runner.dart';

import '../io.dart';
import '../options.dart';
import '../parse.dart';

class DepCommand extends Command<String> {
  @override
  String get description => 'Adds a dependency to pubspec.yaml.';

  @override
  String get name => 'dep';

  Future<String> run() async {
    var pkg = await latest(argResults.rest.first);
    var opts = Options.from(globalResults);

    var pubspec = await load(opts.filename);

    await addDependency(pubspec, pkg);

    return toYaml(pubspec, opts.sort);
  }
}
