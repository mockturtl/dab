import 'package:args/command_runner.dart';

import '../io.dart';
import '../options.dart';
import '../parse.dart';

/// Remove a dependency.
class RemoveCommand extends Command<String> {
  @override
  String get description => 'Remove a package from the pubspec.';

  @override
  String get name => 'rm';

  Future<String> run() async {
    var pkg = await latestVersion(argResults.rest.first);
    var opts = Options.from(globalResults);
    var pubspec = await loadPubspec(opts.filename);

    var k = pkg.name;
    pubspec.dependencies.remove(k);
    pubspec.devDependencies.remove(k);
    pubspec.dependencyOverrides.remove(k);

    return toYaml(pubspec, opts.sort, opts.scpSyntax);
  }
}
