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