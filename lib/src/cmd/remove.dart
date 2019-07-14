import 'package:args/command_runner.dart';

import '../io.dart';
import '../options.dart';
import '../parse.dart';

class RemoveCommand extends Command<String> {
  @override
  String get description => 'Remove a package from the pubspec.';

  @override
  String get name => 'rm';

  Future<String> run() async {
    var pkg = await latestVersion(argResults.rest.first);
    var opts = Options.from(globalResults);
    var pubspec = await loadPubspec(opts.filename);

    remove(pubspec, pkg);

    return toYaml(pubspec, opts.sort, opts.scpSyntax);
  }
}
