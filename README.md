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

### Buildind an AppImage for Linux

1. Setup Docker (docker-ce-cli is free) on your Linux Host
2. Go into the root of the project from your terminal
3. Build the base image : `docker build -t basic_chess_endgames_build .`
4. Build the AppImage inside a container: `docker run -ti --mount type=bind,source=$(pwd),target=/home/developer/project basic_chess_endgames_build bash`
5. Inside the container, run `cd project`
6. Go on with the following command `flutter clean`
7. Now `flutter build linux --release`
8. Run `appimage-builder --recipe AppImageBuilder.yml`

Your AppImage should have been generated in the root of the project, so you can close the running Docker container (run `exit`).
For further builds, you may want to restart from step 4, and so saving a lot of time.

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
