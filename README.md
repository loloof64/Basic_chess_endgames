# Basic chess endgames

Generate a chess position from your criterias and play it against your device.

## Developpers

### Antlr4

If you want to generate Antlr4 base from the Lua.g4, simply go into the lib/antlr4 folder, and run :

```
antlr4 -o generated -no-listener -visitor -Dlanguage=Dart Lua.g4

```

### Translations

In order to update translations, run

```
dart run slang
```
