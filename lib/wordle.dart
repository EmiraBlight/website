import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

enum LetterState { absent, yellow, green }

class Letter {
  String letter;
  LetterState state;
  Letter({this.letter = '', this.state = LetterState.absent});
}

class WordlePage extends StatefulWidget {
  const WordlePage({super.key});

  @override
  State<WordlePage> createState() => _WordlePageState();
}

class _WordlePageState extends State<WordlePage> {
  static const int maxCols = 5;
  List<List<Letter>> rows = [];
  int activeRow = 0;
  List<String> suggestions = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    rows.add(List.generate(maxCols, (_) => Letter()));
  }

  Color _getColor(LetterState state) {
    switch (state) {
      case LetterState.green:
        return Colors.green;
      case LetterState.yellow:
        return Colors.yellow;
      case LetterState.absent:
      default:
        return Colors.grey.shade300;
    }
  }

  void _toggleLetterState(int row, int col) {
    setState(() {
      final current = rows[row][col].state;
      if (current == LetterState.absent) {
        rows[row][col].state = LetterState.yellow;
      } else if (current == LetterState.yellow) {
        rows[row][col].state = LetterState.green;
      } else {
        rows[row][col].state = LetterState.absent;
      }
    });
  }

  void _handleKey(RawKeyEvent event) {
    if (event is! RawKeyDownEvent) return; // only handle key down once

    final key = event.logicalKey.keyLabel.toUpperCase();

    if (key.length == 1 && key.contains(RegExp(r'[A-Z]'))) {
      // Type a letter
      for (int i = 0; i < maxCols; i++) {
        if (rows[activeRow][i].letter.isEmpty) {
          setState(() {
            rows[activeRow][i].letter = key;
          });
          break;
        }
      }
    } else if (event.logicalKey == LogicalKeyboardKey.backspace) {
      // Delete last letter
      for (int i = maxCols - 1; i >= 0; i--) {
        if (rows[activeRow][i].letter.isNotEmpty) {
          setState(() {
            rows[activeRow][i].letter = '';
          });
          break;
        }
      }
    } else if (event.logicalKey == LogicalKeyboardKey.enter) {
      // Submit row
      final currentRowLetters = rows[activeRow].map((l) => l.letter).join();
      if (currentRowLetters.length != 5) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Complete the current 5-letter word before pressing Enter'),
          ),
        );
        return;
      }

      if (rows.length < 6) {
        setState(() {
          rows.add(List.generate(maxCols, (_) => Letter()));
          activeRow = rows.length - 1;
        });
      }
    }
  }

  Future<void> _getSuggestions() async {
    final payload = <Map<String, String>>[];

    for (final row in rows) {
      final word = row.map((l) => l.letter.toLowerCase()).join();
      if (word.length != 5) continue; // Only full words

      final hint = row.map((l) {
        switch (l.state) {
          case LetterState.green:
            return 'G';
          case LetterState.yellow:
            return 'y';
          case LetterState.absent:
          default:
            return 'g';
        }
      }).join();

      payload.add({'word': word, 'hint': hint});
    }

    if (payload.isEmpty) return;

    setState(() {
      isLoading = true;
      suggestions = [];
    });

    try {
      final response = await http.post(
        Uri.parse('https://srv915664.hstgr.cloud/best_guesses'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final List<String> results =
            (decoded['guesses'] as List<dynamic>).cast<String>();
        setState(() {
          suggestions = results;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("API error: ${response.statusCode}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch suggestions: $e")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: const Text("Wordle Helper",textAlign: TextAlign.center,))),
      body: RawKeyboardListener(
        focusNode: FocusNode()..requestFocus(),
        onKey: _handleKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                "Type letters directly. Use Enter to submit and Backspace to delete.",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Column(
                children: List.generate(rows.length, (r) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(maxCols, (c) {
                        final letter = rows[r][c].letter;
                        return GestureDetector(
                          onTap: () => _toggleLetterState(r, c),
                          child: Container(
                            width: 50,
                            height: 50,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: _getColor(rows[r][c].state),
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              letter,
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      }),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _getSuggestions,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Get Suggestions"),
              ),
              const SizedBox(height: 20),
              if (suggestions.isNotEmpty) ...[
                const Text(
                  "Top Suggestions:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: suggestions.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        leading: Text("${index + 1}"),
                        title: Text(
                          suggestions[index],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
