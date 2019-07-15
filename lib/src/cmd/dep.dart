import 'package:args/command_runner.dart';

import '../io.dart';
import '../options.dart';
import '../parse.dart';

/// Add a package dependency.
class DepCommand extends Command<String> {
  @override
  String get description =>
      "Add a package to the pubspec's `dependency` section.";

  @override
  String get name => 'dep';

  Future<String> run() async {
    var pkg = await latestVersion(argResults.rest.first);
    var opts = Options.from(globalResults);
    var pubspec = await loadPubspec(opts.filename);

    pubspec.dependencies.putIfAbsent(pkg.name, () => pkg.asDependency);

    return toYaml(pubspec, opts.sort, opts.scpSyntax);
  }
}
