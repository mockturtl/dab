

### setup

Assuming the [Dart SDK][sdk] is available on your `$PATH`, this will
install (or update) the top-level `dab` command:

```sh
$ pub global activate dab
```

[sdk]: https://www.dartlang.org/tutorials/server/get-started

### usage

```sh
$ dab help
The dart+pub companion.  ヽ( •_)ᕗ

Usage: dab <command> [arguments]

Global options:
-h, --help            Print this usage information.
-f, --filename        Pubspec file to edit
                      (defaults to "pubspec.yaml")

-s, --[no-]sort       Sort list output alphabetically.
                      (defaults to on)

-n, --[no-]dry-run    Only print the modified pubspec, without overwriting the file.
-u, --[no-]update     Run "pub get" with the new pubspec.

Available commands:
  dep      Add a package to the pubspec's `dependency` section.
  devdep   Add a package to the pubspec's `dev_dependency` section.
  help     Display help information for dab.
  rm       Remove a package from the pubspec.

Run "dab help <command>" for more information about a command.
```

### hacking

Run `tool/gen_{once,watch}` to update the generated code `*.g.dart`.  This is idempotent.

### see also

- [Pubspec Assist](https://github.com/jeroen-meijer/pubspec-assist) for VS Code
- https://github.com/flutter/flutter-intellij/issues/2313
