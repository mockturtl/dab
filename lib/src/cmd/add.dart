import 'package:args/command_runner.dart';

import '../io.dart';
import '../options.dart';
import '../parse.dart';
import 'mixin.dart';

const _dev = 'dev';

/// Add a package dependency.
class AddCommand extends Command<void> with WriterMixin {
  AddCommand() {
    argParser.addFlag(_dev, help: 'Add the package as a dev_dependency.');
  }

  @override
  String get description => 'Add a package dependency.';

  @override
  String get invocation => 'dab add [package]';

  @override
  String get name => 'add';

  Future<void> run() async {
    var pkg = await latestVersion(argResults.rest.first);
    var opts = Options.from(globalResults);
    var pubspec = await loadPubspec(opts.filename);

    var s = argResults[_dev] ? pubspec.devDependencies : pubspec.dependencies;
    s.putIfAbsent(pkg.name, () => pkg.asDependency);

    var out = toYaml(pubspec, opts.sort, opts.scpSyntax);
    write(opts, out);
  }
}
