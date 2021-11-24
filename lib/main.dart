import 'package:dargon2_flutter/dargon2_flutter.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 100),
                ElevatedButton(
                  child: const Text('Run long calculations'),
                  onPressed: () {
                    setState(() {
                      _isPressed = !_isPressed;
                    });
                  },
                ),
                SizedBox(height: 40),
                _isPressed ? const Result() : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Result extends StatelessWidget {
  const Result({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _hash(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const LinearProgressIndicator();
        }

        if (snapshot.hasError) {
          return const Text('An error occurred');
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('${snapshot.data}'),
        );
      },
    );
  }

  Future<String> _hash() async {
    DArgon2Result result = await argon2.hashPasswordString('input text',
        salt: Salt.newSalt(), iterations: 256, parallelism: 8);
    return result.hexString;
  }
}
