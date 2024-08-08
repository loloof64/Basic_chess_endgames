# Basic chess endgames

Generate a chess position from your criterias and play it against your device.

## Usage

### Examples

You can generate a position from an example script. In the list, there also icons in order to know if we can hope for a win or for a draw.

But you can clone an example and adapt it for your own needs. And you can also see the code of an example.

### Custom scripts

You can also define your custom scripts : each section is written in a subset of the Lua language. There's also a manual in the script editor page.

You can also see the predefined variables of each script section, as well as their types. And you can insert them in your code by selecting them.

### Game

Once the position is generated, you can play it against the computer, and abort it at any time.

Whenever game is finished, you can see the history of moves.

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
