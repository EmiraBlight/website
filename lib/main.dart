import 'package:flutter/material.dart';
import 'resume.dart';
import 'wordle.dart';
import 'encryption.dart';
import 'projects.dart';
import 'contact.dart';
import 'game.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dev-Crypt',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const MainPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<String> _tabs = [
    "Resume",
    "Wordle",
    "Contact",
    "Projects",
    "Encryption",
    "Game",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          color: Colors.white,
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                const double tabWidth = 120.0;
                final double totalWidth = tabWidth * _tabs.length;

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Container(
                    // This forces the container to be at least as wide as the screen
                    // to allow the Center widget to actually center the content.
                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                    child: Center(
                      child: SizedBox(
                        width: totalWidth,
                        height: 50,
                        child: Stack(
                          alignment: Alignment.bottomLeft,
                          children: [
                            // Sliding underline
                            AnimatedPositioned(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              left: _selectedIndex * tabWidth,
                              bottom: 0,
                              child: Container(
                                width: tabWidth,
                                height: 3,
                                color: Colors.deepPurple,
                              ),
                            ),
                            Row(
                              children: List.generate(_tabs.length, (index) {
                                final bool isSelected = _selectedIndex == index;
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedIndex = index;
                                    });
                                  },
                                  child: Container(
                                    width: tabWidth,
                                    height: 50,
                                    color: Colors.transparent, // Improves tap area
                                    child: Center(
                                      child: Text(
                                        _tabs[index],
                                        style: TextStyle(
                                          color: isSelected
                                              ? Colors.deepPurple
                                              : Colors.black54,
                                          fontWeight: isSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          ResumePage(),
          WordlePage(),
          ContactPage(),
          ProjectsPage(),
          EncryptPage(),
          WebSocketGamePage(),
        ],
      ),
    );
  }
}
