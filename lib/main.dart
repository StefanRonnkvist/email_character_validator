import "package:flutter/material.dart";
import "email_split.dart";

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late String title;
  String text = "No eMail Entered";
  String textSpanText = "No eMail Entered";
  bool runRichText = false;

  void _setText() {
    setState(() {
      text = title;
      runRichText = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Comity'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 300,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: TextField(
                  decoration: const InputDecoration(labelText: 'eMail'),
                  onChanged: (value) => title = value,
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            ElevatedButton(
                onPressed: _setText,
                style: ButtonStyle(
                    elevation: WidgetStateProperty.all(8),
                    backgroundColor: WidgetStateProperty.all(Colors.green)),
                child: const Text('Submit')),
            const SizedBox(
              height: 20,
            ),
            if (runRichText) ...{
              buildTextSpan(text),
            },
          ],
        ),
      ),
    );
  }
}
