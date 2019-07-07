import 'package:args/command_runner.dart';
import 'package:dab/cmd.dart';
import 'package:dab/dab.dart';

main(List<String> args) async {
  final r = CommandRunner<String>('dab', 'The dart+pub companion.')
    ..addCommand(DepCommand())
    ..addCommand(DevDepCommand())
    ..addCommand(RemoveCommand());

  addOptions(r.argParser);

  final out = await r.run(args);

  if (out != null) {
    print(out);
//    await File(_pubspec).writeAsString(out, flush: true);
  }
}
