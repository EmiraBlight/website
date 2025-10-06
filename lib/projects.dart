import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
class ProjectsPage extends StatefulWidget {
const ProjectsPage({super.key});

@override
State<ProjectsPage> createState() => _ProjectsPageState();
}




class _ProjectsPageState extends State<ProjectsPage> {




final List<Map<String, String>> _projects = [
{
  "title": "Encryption Tool",
  "summary":
  "A custom encryption/decryption algorithm with a 64-bit key system implemented in the go language.",
  "details":
  "This project implements a custom block cipher engine in Go. Inspired by the Skipjack and DES algorithms it shares features with"
  "many algorithms still in use today. More information can be found under the \"encryption\" tab"
},
{
  "title": "Wordle Helper",
  "summary":
  "Assists in solving any wordle by taking set of given hints and uses entropy theory to return 5 best next guesses.",
  "details":
  "Takes hints and eliminates all possible wordle words (All valid guesses provied by NYT) and uses entropy theory to"
  "select the 5 next guesses most likely to eliminate the most ammount of remaining words. "
  "Can be interacted with in \"wordle\" page and source code is available here: https://github.com/EmiraBlight/WordleRust"
},
{
  "title": "Portfolio Website",
  "summary":
  "A clean, responsive personal site showcasing my previous and current work as an software developer",
  "details":
  "Developed with the Flutter framework and REST APIs in Rust and Go this site shows many of my projects in and out of"
  "school. Although this project is only deployed to the web, with one command it could be deployed on linux, windows, android IOS or MacOS."
  "This is the reason I often choose to build websites and aplications through the flutter framework."
},
{
  "title": "Anonymous chat app",
  "summary":
  "Uses ring signatures to provide partial ananymotiy in a group chat",
  "details":
  "Currently under construction. Feel free to reach out to me about this at sammy@dev-crypt.com"
},
];

final Set<int> _expanded = {};

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text("Projects Showcase"),
centerTitle: true,
),
  body: Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 700),
      child: ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: _projects.length,
      itemBuilder: (context, index) {
      final project = _projects[index];
      final isExpanded = _expanded.contains(index);

          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    project["title"]!,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                      
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    project["summary"]!,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          if (isExpanded) {
                            _expanded.remove(index);
                          } else {
                            _expanded.add(index);
                          }
                        });
                      },
                      child: Text(
                        isExpanded ? "Hide Details" : "View Details",
                      ),
                    ),
                  ),
                  if (isExpanded) ...[
                    const SizedBox(height: 10),
                    Text(
                      project["details"]!,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ]
                ],
              ),
            ),
          );
        },
      ),
    ),
  ),
);

}
}
