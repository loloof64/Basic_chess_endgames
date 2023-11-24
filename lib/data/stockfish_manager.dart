import 'package:flutter_stockfish_plugin/stockfish.dart';
import 'package:flutter_stockfish_plugin/stockfish_state.dart';

class StockfishManager {
  Stockfish? _stockfish;

  void init() async {
    _stockfish = Stockfish();
  }

  void dispose() {
    _stockfish?.dispose();
  }

  void sendCommand(String command) {
    if (_stockfish?.state.value != StockfishState.ready) return;
    _stockfish?.stdin = command;
  }

  bool isReady() {
    if (_stockfish == null) return false;
    return _stockfish!.state.value == StockfishState.ready;
  }

  Stream<String> geOutputStream() {
    if (_stockfish == null) throw "Stockfish is still uninitialized !";
    if (_stockfish!.state.value != StockfishState.ready) throw "Stockfish is not yet ready !";
    return _stockfish!.stdout;
  } 
}

StockfishManager stockfishManager = StockfishManager();