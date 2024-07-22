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

## Credits

### SvgRepo

Some pictures have been downloaded from [Svg Repo](https://www.svgrepo.com/) :
* https://www.svgrepo.com/svg/398519/trophy
* https://www.svgrepo.com/svg/300894/handshake
* https://www.svgrepo.com/svg/477108/computer
* https://www.svgrepo.com/svg/467434/user-8

Chess vectors have been downloaded from [WikiMedia Commons](https://commons.wikimedia.org/wiki/Category:SVG_chess_pieces).

### Fonts

Font freeSerif was downloaded from [FontSpace](https://www.fontspace.com/freeserif-font-f13277).
