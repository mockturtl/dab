import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dab/cmd.dart';

main(List<String> args) async {
  final r = CommandRunner<String>('dab', 'The dart+pub companion.  ヽ( •_)ᕗ')
    ..addCommand(DepCommand())
    ..addCommand(DevDepCommand())
    ..addCommand(RemoveCommand());

  Options.populate(r.argParser);

  final out = await r.run(args);
  var opts = parseOptions(args);

  if (opts.dryRun) {
    print(out);
    return;
  }

  if (out == null) return;

  var f = opts.filename;
  await File(f).writeAsString(out, flush: true);

  if (opts.update) {
    print("Running 'pub get'...");
    var res = await Process.run('pub', ['get']);
    print(res.exitCode == 0 ? 'Done!' : 'ERROR: ${res.exitCode}');
  }
}
