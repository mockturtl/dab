import 'package:args/command_runner.dart';

import '../io.dart';
import '../options.dart';
import '../parse.dart';

class DevDepCommand extends Command<String> {
  @override
  String get description =>
      "Add a package to the pubspec's `dev_dependency` section.";

  @override
  String get name => 'devdep';

  Future<String> run() async {
    var pkg = await latestVersion(argResults.rest.first);
    var opts = Options.from(globalResults);
    var pubspec = await loadPubspec(opts.filename);

    addDevDependency(pubspec, pkg);

    return toYaml(pubspec, opts.sort);
  }
}
