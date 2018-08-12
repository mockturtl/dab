import 'dart:io';

import 'package:dab/dab.dart';

main(List<String> arguments) async {
  if (arguments.isEmpty) {
    print('No package provided.');
    exit(1);
  }
  var pkg = arguments.first ?? '';
  print('Fetching $pkg...');
  var res = (await latest(pkg));
  print('${res.name} ${res.version}');
}
