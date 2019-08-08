import 'package:args/command_runner.dart';
import 'package:dab/cmd.dart';

main(List<String> args) async {
  final r = CommandRunner<void>('dab', 'The dart+pub companion.  ヽ( •_)ᕗ')
    ..addCommand(AddCommand())
    ..addCommand(RemoveCommand());

  Options.populate(r.argParser);

  await r.run(args);
}
