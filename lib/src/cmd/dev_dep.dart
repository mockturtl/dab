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
    var opts = Options.from(globalResults);

    var pubspec = await load(opts.filename);

    await addDevDependency(pubspec, pkg);

    return toYaml(pubspec, opts.sort);
  }
}
