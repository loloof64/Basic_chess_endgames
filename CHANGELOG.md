## 4.4.0

* Added random testing feature where you can preview generated positions from your script, as well as the rejected generated position because of being illegal.
* Little improvement : giving the focus back to the user when he inserts a predefined variable in script editor
* We can set the dark mode

## 4.3.3

* More robust error handling when checking/execting scripts
* Bug fix for when setting other pieces global/indexed/mutal scripts

## 4.3.2

Fix AppImage runtime error : failing to load libstockfish_chess_engine.so

## 4.3.1

Upgrade flutter sdk so that the CI/CD can build for windows

## 4.3.0

* Using package stockfish_chess_engine 0.8.1, which
    * is based on Stockfish 17
    * has code for ios and macos
    * will use a little NNUE on mobile device
* Limiting number of shown errors, in order to avoid freezing the UI
* Using Lua VM instead of Antlr4 :
    * you're are more free in your scripts
    * meanwhile, in case of error, you get a less precise info and in english, but you still have the error line
    * all samples work fine now
    * adapted syntax manual

## 4.2.14

* Minor fixes
* Rename window title in desktop version
* Set board reversed by default if player has black side
* Showing several errors at once instead of just the first error for scripts
* Caution ! The scripts checker does not warn you any more for being too restrictive
* We can see predefined variables even when reading at a sample code, but this time -of course- we cannot insert them
* (Android) (bug fix) : sometimes could not run long scripts
* (bug fix) : script types in some errors were not precise enough : sometimes we missed the piece kind
* (bug fix) : script error "parenthesis without expression" made program crash instead of reporting it
* (bug fix) : script error where there's a missing operand made program crash (same for wrong type of operand)
* sometimes we had an error and we could not know on which position it happened
* (Windows) Changed the application icon

## 4.0.148

Initial desktop release (Windows 11 x64, and Linux x64)