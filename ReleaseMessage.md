* Minor fixes
* Rename window title in desktop version
* Set board reversed by default if player has black side
* Showing several errors at once instead of just the first error for scripts
* Caution ! The scripts checker does not warn you any more for being too restrictive
* We can see predefined variables even when reading at a sample code, but this time -of course- we cannot insert them
* (bug fix) : script types in some errors were not precise enough : sometimes we missed the piece kind
* (bug fix) : script error "parenthesis without expression" made program crash instead of reporting it
* (bug fix) : script error where there's a missing operand made program crash (same for wrong type of operand)
* sometimes we had an error and we could not know on which position it happened
* (Windows) Changed the application icon