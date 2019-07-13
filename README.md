# dab

The dart+pub companion.  ヽ( •_)ᕗ

### setup

Install or update:

```shell
$ pub global activate dab
```

### about

```sh
$ dab help
The dart+pub companion.  ヽ( •_)ᕗ

Usage: dab <command> [arguments]

Global options:
-h, --help            Print this usage information.
-f, --filename        Pubspec file to edit
                      (defaults to "pubspec.yaml")

-s, --[no-]sort       If true, sort list output alphabetically.
                      (defaults to on)

-n, --[no-]dry-run    If true, only print the modified pubspec, without overwriting the file.
-u, --[no-]update     If true, run `pub get` with the new pubspec.

Available commands:
  dep      Add a package to the pubspec's `dependency` section.
  devdep   Add a package to the pubspec's `dev_dependency` section.
  help     Display help information for dab.
  rm       Remove a package from the pubspec.

Run "dab help <command>" for more information about a command.
The dart+pub companion.  ヽ( •_)ᕗ

Usage: dab <command> [arguments]

Global options:
-h, --help            Print this usage information.
-f, --filename        Pubspec file to edit
                      (defaults to "pubspec.yaml")

-s, --[no-]sort       If true, sort list output alphabetically.
                      (defaults to on)

-n, --[no-]dry-run    If true, only print the modified pubspec, without overwriting the file.
-u, --[no-]update     If true, run `pub get` with the new pubspec.

Available commands:
  dep      Add a package to the pubspec's `dependency` section.
  devdep   Add a package to the pubspec's `dev_dependency` section.
  help     Display help information for dab.
  rm       Remove a package from the pubspec.

Run "dab help <command>" for more information about a command.
```