import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class EncryptPage extends StatefulWidget {
const EncryptPage({super.key});

@override
State<EncryptPage> createState() => _EncryptPageState();
}

class _EncryptPageState extends State<EncryptPage> {
final TextEditingController _textController = TextEditingController();
final TextEditingController _keyController = TextEditingController();
bool _decrypt = false;
String? _result;
bool _isLoading = false;

static final BigInt maxKey = BigInt.from(2).pow(64);

Future<void> _process() async {
final text = _textController.text.trim();
final keyString = _keyController.text.trim();

if (text.isEmpty || keyString.isEmpty) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("Please enter both phrase and key")),
  );
  return;
}

// Parse and validate key
BigInt? key;
try {
  key = BigInt.parse(keyString);
} catch (_) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("Key must be a number")),
  );
  return;
}

if (key < BigInt.zero || key >= maxKey) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
        content: Text("Key must be between 0 and 2^64 - 1 (unsigned 64-bit)")),
  );
  return;
}

setState(() {
  _isLoading = true;
  _result = null;
});

final url = Uri.parse("Nope");
final payload = {
  "text": text,
  "string": keyString,
  "decrypt": _decrypt,
};

try {
  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(payload),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    setState(() {
      _result = data["Result"] ?? "No result";
    });
  } else {
    setState(() {
      _result = "Error: ${response.statusCode}";
    });
  }
} catch (e) {
  setState(() {
    _result = "Request failed: $e";
  });
} finally {
  setState(() {
    _isLoading = false;
  });
}

}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(title: const Text("Encrypt / Decrypt"),centerTitle: true,),
body: Center(
child: ConstrainedBox(
constraints: const BoxConstraints(maxWidth: 500),
child: SingleChildScrollView(
padding: const EdgeInsets.all(30),
child: Card(
elevation: 4,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(16)),
child: Padding(
padding: const EdgeInsets.all(24),
child: Column(
mainAxisSize: MainAxisSize.min,
children: [
const Text(
"WSU Crypt",
style: TextStyle(
fontSize: 22,
fontWeight: FontWeight.bold,
color: Colors.deepPurple),
textAlign: TextAlign.center,
),
const SizedBox(height: 20),
TextField(
controller: _textController,
decoration: const InputDecoration(
labelText: "Phrase",
border: OutlineInputBorder(),
),
),
const SizedBox(height: 15),
TextField(
controller: _keyController,
decoration: const InputDecoration(
labelText: "Key (unsigned 64-bit integer)",
border: OutlineInputBorder(),
),
keyboardType: TextInputType.number,
inputFormatters: [FilteringTextInputFormatter.digitsOnly],
),
const SizedBox(height: 15),
SwitchListTile(
title: const Text("Decrypt instead of Encrypt"),
value: _decrypt,
onChanged: (val) => setState(() => _decrypt = val),
),
const SizedBox(height: 20),
SizedBox(
width: double.infinity,
child: ElevatedButton(
onPressed: _isLoading ? null : _process,
child: _isLoading
? const CircularProgressIndicator(
color: Colors.white)
: const Text("Submit"),
),
),
const SizedBox(height: 30),
if (_result != null) ...[
const Text(
"Result:",
style: TextStyle(
fontWeight: FontWeight.bold, fontSize: 18),
),
const SizedBox(height: 10),
SelectableText(
_result!,
style: const TextStyle(
fontSize: 18, fontWeight: FontWeight.w500),
textAlign: TextAlign.center,
),
],
const SizedBox(height: 40),
const Divider(),
const Text(
"WSU Crypt",
style:
TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
textAlign: TextAlign.center,
),
const SizedBox(height: 10),
const Text(
"This algorithm is taught at WSU for educational purposes. It is based on skipjack and DES and uses a 64 bit key."
" This is why the key accepts any 64 bit number. By no means is this algorithm safe for real encryption work, "
"it is merly for learning purposes. I have this on my site because I have a personal fascination with cryptographic algorithms."
"\n\nOne day I hope to revisit this project and make it safe for use by increasing the key size. Key size is the main weakness of this design"
"With modifications to the key size and substituion box method used in the original design, I belive I could create a robust encryption algorithm of my own.",
textAlign: TextAlign.center,
),
const Text(
"Basic algorithm",
style:
TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
textAlign: TextAlign.center,
),
const Text(
"The setup includes a fiestel structure that is iterated 16 times, each cycle containing and permutation "
"step and a substitution step. This allows for maximum diffusion, making the encrypted text very difficult to reconstruct",
textAlign: TextAlign.center,
),
const Text(
"Fiestel structure",
style:
TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
textAlign: TextAlign.center,
),
const Text(
  "A Fiestel structure is a Cryptographic algorithm that encrypts half of a block of content while the other half remains unchanged."
  "This provies defence against crypanalysis.Fiestel structured encryption algorithms also have the side effect of being reversable. This means that the"
  "Same algorithm that encrypts can also decrypt. The onlt difference is that the order of the subkeys generated from the key are put in reverse",
  textAlign: TextAlign.center,
),

const Text(
"Pre/Post fiestel structure",
style:
TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
textAlign: TextAlign.center,
),

const Text(
"Before the fiestel structure is implemented a \"whitening\" step is applied to the key."
 "This includes performing an xor bit shift operation on the key with the block of text being encrypted. This makes it more"
 " difficult for an attacker to reverse engineer the key.",
 textAlign: TextAlign.center,
),
const Text(
"Code and how this site works",
style:
TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
textAlign: TextAlign.center,
),
const Text(
"The source code for this project is unforunatly not in my git repo or made public. This is because the instructor of the class"
" has asked me to keep it private to prevent cheating in future semesters. This web app allows you to interact with the algorithm without"
"making my source code public.\n\nThe site takes a phrase (ASCII characters) and a key and passes them through a REST API that encrypts the contents and"
" returns the result. Since the end goal of the algorithm is to translate your message into a gibrish of 0s and 1s the result is displayed here as a "
"hexedecimal number where every 16 letters/numbers represents 8 characters of plain text encrypted. In real practice this number is never read by the naked eye, but to make sure no special characters are displayed I chose to convert the binary to hexidecimal instead of text",
textAlign: TextAlign.center,
),
],
),
),
),
),
),
),
);
}
}
