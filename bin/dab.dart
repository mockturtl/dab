import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dab/cmd.dart';

main(List<String> args) async {
  final r = CommandRunner<String>('dab', 'The dart+pub companion.')
    ..addCommand(DepCommand())
    ..addCommand(DevDepCommand())
    ..addCommand(RemoveCommand());

  Options.populate(r.argParser);

  final out = await r.run(args);

  if (out != null) {
//    print(out);
    var f = parseOptions(args).filename;
    await File(f).writeAsString(out, flush: true);
    print("\nUpdated $f. Running 'pub get'...");
    var res = await Process.run('pub', ['get']);
    print(res.exitCode == 0 ? 'Done!' : 'ERROR: ${res.exitCode}');
  }
}
