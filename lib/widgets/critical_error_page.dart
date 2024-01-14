import 'dart:io';

import 'package:flutter/material.dart';

class CriticalErrorPage extends StatelessWidget {
  const CriticalErrorPage({
    required this.error,
    this.stackTrace,
    super.key,
  });

  final Object error;
  final StackTrace? stackTrace;

  @override
  Widget build(BuildContext context) {
    const mono = TextStyle(fontFamily: "monospace");
    return Scaffold(
      body: Column(
        children: [
          Flexible(
            child: Column(
              children: [
                const Text("Critical Error!"),
                const Text("The application cannot continue with this error." +
                    "Check the error details and stack trace for more information."),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(error.toString(), style: mono),
                  ),
                ),
                const SizedBox(height: 16),
                if (stackTrace != null)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(stackTrace.toString(), style: mono),
                    ),
                  ),
              ],
            ),
          ),
          ElevatedButton(
            style: ButtonStyle(foregroundColor: MaterialStateProperty.all(Colors.red)),
            onPressed: () => exit(1),
            child: const Text("Exit"),
          ),
        ],
      ),
    );
  }
}
