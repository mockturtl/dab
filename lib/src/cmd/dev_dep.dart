import 'package:args/command_runner.dart';

import '../io.dart';
import '../options.dart';
import '../parse.dart';

class DevDepCommand extends Command<String> {
  @override
  String get description => 'Adds a dev_dependency to pubspec.yaml.';

  @override
  String get name => 'devdep';

  Future<String> run() async {
    var pkg = await latest(argResults.rest.first);

    var pubspec = await load(globalResults[Opts.filename]);

    await addDevDependency(pubspec, pkg);

    return toYaml(pubspec, globalResults[Opts.sort]);
  }
}
