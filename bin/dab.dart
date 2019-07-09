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
    print(out);
    await File(parseOptions(args).filename).writeAsString(out, flush: true);
  }
}
