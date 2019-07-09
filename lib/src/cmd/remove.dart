import 'package:args/command_runner.dart';

import '../io.dart';
import '../options.dart';
import '../parse.dart';

class RemoveCommand extends Command<String> {
  @override
  String get description => 'Removes a dependency from pubspec.yaml.';

  @override
  String get name => 'rm';

  Future<String> run() async {
    var pkg = await latest(argResults.rest.first);
    var opts = Options.from(globalResults);

    var pubspec = await load(opts.filename);

    await remove(pubspec, pkg);

    return toYaml(pubspec, opts.sort);
  }
}
