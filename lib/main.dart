import 'package:flutter/material.dart';
import 'package:gotask/app.dart';
import 'package:gotask/common/future_value.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  final preResult = await initPre();
  if (preResult is! ValueFinished<bool>) return; // simplified for this project

  runApp(const App());
}

Future<FutureValue<bool>> initPre() async {
  WidgetsFlutterBinding.ensureInitialized();
  return await _initSupabase();
}

const String supabaseUrl = "https://xpvyrjptiuxwjrljfjtt.supabase.co";
const String supabaseAnonKey =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhwdnlyanB0aXV4d2pybGpmanR0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDMyMzY2MDYsImV4cCI6MjAxODgxMjYwNn0.8VXG6sCV9NuxX9P_5qTyCXxwJOWF0-xlWKJCPSLLRzM";

Future<FutureValue<bool>> _initSupabase() async {
  try {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );

    return ValueFinished(value: true);
  } catch (error, stack) {
    return ValueError(error: error, stackTrace: stack);
  }
}
