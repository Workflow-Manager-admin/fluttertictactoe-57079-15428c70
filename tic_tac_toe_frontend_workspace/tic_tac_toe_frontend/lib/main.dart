import 'package:flutter/material.dart';

// App colors from requirements
const Color kPrimaryColor = Color(0xFF1976D2);
const Color kSecondaryColor = Color(0xFF424242);
const Color kAccentColor = Color(0xFFFFCA28);

void main() {
  runApp(const TicTacToeApp());
}

// PUBLIC_INTERFACE
class TicTacToeApp extends StatelessWidget {
  /// Main App with light, minimalistic theme, providing the TicTacToeScreen.
  const TicTacToeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.light(
          primary: kPrimaryColor,
          secondary: kSecondaryColor,
          surfaceTint: Colors.white,
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          color: Colors.white,
          foregroundColor: kPrimaryColor,
          elevation: 0,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: kPrimaryColor,
            textStyle: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ),
      home: const TicTacToeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// PUBLIC_INTERFACE
class TicTacToeScreen extends StatefulWidget {
  /// Responsive, minimalistic screen for two-player tic-tac-toe.
  const TicTacToeScreen({super.key});

  @override
  State<TicTacToeScreen> createState() => _TicTacToeScreenState();
}

enum Player { X, O }

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  static const int boardSize = 3;
  late List<List<Player?>> _board; // 3x3
  Player _currentPlayer = Player.X;
  String _statusMessage = '';
  bool _gameOver = false;
  int _moveCount = 0;

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  // PUBLIC_INTERFACE
  void _startNewGame() {
    /// Reset the board and game status for a new game session.
    setState(() {
      _board = List.generate(
        boardSize,
        (_) => List<Player?>.filled(boardSize, null),
      );
      _currentPlayer = Player.X;
      _moveCount = 0;
      _statusMessage = "Player X's Turn";
      _gameOver = false;
    });
  }

  // PUBLIC_INTERFACE
  void _handleTileTap(int row, int col) {
    /// Handle a player's move. Update the board and check for win/draw.
    if (_board[row][col] != null || _gameOver) return;

    setState(() {
      _board[row][col] = _currentPlayer;
      _moveCount += 1;

      if (_checkWin(row, col, _currentPlayer)) {
        _statusMessage = "Player ${_playerStr(_currentPlayer)} Wins!";
        _gameOver = true;
      } else if (_moveCount == boardSize * boardSize) {
        _statusMessage = "It's a Draw!";
        _gameOver = true;
      } else {
        _currentPlayer = _currentPlayer == Player.X ? Player.O : Player.X;
        _statusMessage = "Player ${_playerStr(_currentPlayer)}'s Turn";
      }
    });
  }

  // PUBLIC_INTERFACE
  bool _checkWin(int lastRow, int lastCol, Player player) {
    /// Check for win after latest move at [lastRow],[lastCol] for [player].
    // Check row
    if (_board[lastRow].every((p) => p == player)) return true;
    // Check column
    if (_board.every((row) => row[lastCol] == player)) return true;
    // Check main diagonal
    if (lastRow == lastCol &&
        List.generate(boardSize, (i) => _board[i][i]).every((p) => p == player)) {
      return true;
    }
    // Check anti-diagonal
    if (lastRow + lastCol == boardSize - 1 &&
        List.generate(boardSize, (i) => _board[i][boardSize - 1 - i])
            .every((p) => p == player)) {
      return true;
    }
    return false;
  }

  String _playerStr(Player? player) => player == Player.X ? 'X' : 'O';

  @override
  Widget build(BuildContext context) {
    // Responsiveness: board size scales, buttons are accessible, layout is vertically centered
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: kPrimaryColor,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double size = constraints.maxWidth < constraints.maxHeight
              ? constraints.maxWidth * 0.9
              : constraints.maxHeight * 0.6;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Status display & new game button
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    _statusMessage,
                    style: TextStyle(
                      color: kSecondaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                // Game board
                Container(
                  width: size, // Square board
                  height: size,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: _buildBoard(size),
                  ),
                ),
                const SizedBox(height: 10),
                // Action buttons row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      ),
                      onPressed: _startNewGame,
                      icon: const Icon(Icons.refresh),
                      label: const Text('New Game'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // PUBLIC_INTERFACE
  Widget _buildBoard(double size) {
    /// Builds a 3x3 tic-tac-toe board, centered and responsive.
    double tileSize = size / boardSize;
    return Material(
      color: Colors.white,
      elevation: 2,
      borderRadius: BorderRadius.circular(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          boardSize,
          (row) => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              boardSize,
              (col) => _buildTile(row, col, tileSize),
            ),
          ),
        ),
      ),
    );
  }

  // PUBLIC_INTERFACE
  Widget _buildTile(int row, int col, double tileSize) {
    /// Builds one tile in the board, with correct X/O display and tap handling.
    final Player? tilePlayer = _board[row][col];
    return GestureDetector(
      onTap: () => _handleTileTap(row, col),
      child: Container(
        width: tileSize,
        height: tileSize,
        decoration: BoxDecoration(
          border: Border(
            top: row == 0
                ? BorderSide.none
                : BorderSide(color: kSecondaryColor.withAlpha(36), width: 2),
            left: col == 0
                ? BorderSide.none
                : BorderSide(color: kSecondaryColor.withAlpha(36), width: 2),
            right: col == boardSize - 1
                ? BorderSide.none
                : BorderSide(color: kSecondaryColor.withAlpha(36), width: 2),
            bottom: row == boardSize - 1
                ? BorderSide.none
                : BorderSide(color: kSecondaryColor.withAlpha(36), width: 2),
          ),
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 225),
            transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
            child: tilePlayer == null
                ? const SizedBox.shrink()
                : Text(
                    _playerStr(tilePlayer),
                    key: ValueKey(tilePlayer),
                    style: TextStyle(
                      fontSize: tileSize * 0.6,
                      color: tilePlayer == Player.X ? kPrimaryColor : kAccentColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
