**ARCHIVED**.  `dart pub` now has native `add, remove` subcommands.

----

dab adds package dependencies to your pubspec, saving you a trip to [pub.dev](https://pub.dev)
to look up the latest version.

### setup

Assuming the [Dart SDK][sdk] is available on your `$PATH`, to
install (or update) the top-level `dab` command, run:

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
-h, --help         Print this usage information.
    --[no-]scp     Write ssh URLs with scp syntax.
                   (defaults to on)

-f, --filename     Pubspec file to edit
                   (defaults to "pubspec.yaml")

-n, --dry-run      Only print the modified pubspec, without overwriting the file.
-s, --[no-]sort    Sort list output alphabetically.
                   (defaults to on)

-u, --update       Run "pub get" with the new pubspec.

Available commands:
  add    Add a package dependency.
  help   Display help information for dab.
  rm     Remove a package from the pubspec.

Run "dab help <command>" for more information about a command.
```

### known issues

- TODO: error handling
- TODO: tests
- It **WILL** eat the `executables` section, pending
[dart-lang/pubspec_parse#49](https://github.com/dart-lang/pubspec_parse/issues/49).
- It **WILL** eat comments.
- It **WILL** sort dependencies alphabetically.

It's always a good idea review the changes: `git diff pubspec.yaml`.

### hacking

Run `tool/gen_{once,watch}` to update the generated code `*.g.dart`.  This is idempotent.

### see also

- [Pubspec Assist](https://github.com/jeroen-meijer/pubspec-assist) for VS Code
- https://github.com/flutter/flutter-intellij/issues/2313
- [pubx](https://pub.dev/packages/pubx)

