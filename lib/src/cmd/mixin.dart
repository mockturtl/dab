import 'dart:io';

import '../options.dart';

class WriterMixin {
  void write(Options opts, String output) async {
    if (opts.dryRun) {
      print(output);
      return;
    }

    if (output == null) return;

    var f = opts.filename;
    await File(f).writeAsString(output, flush: true);

    if (opts.update) {
      print("Running 'pub get'...");
      var res = await Process.run('pub', ['get']);
      if (res.exitCode != 0) print('ERROR: ${res.exitCode}');
    }
  }
}
