import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotask/controllers/login_controller.dart';
import 'package:gotask/controllers/notes_controller.dart';
import 'package:gotask/values/predefined_style.dart';
import 'package:gotask/widgets/login_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  Brightness get defaultBrightness => Brightness.dark;

  ColorScheme get defaultColorScheme => ColorScheme(
        brightness: defaultBrightness,
        //
        primary: Colors.teal,
        primaryContainer: Colors.teal.shade800,
        onPrimary: Colors.black,
        secondary: Colors.white,
        onSecondary: Colors.black,
        outline: Colors.teal.withOpacity(.5),
        //
        background: Colors.black,
        onBackground: Colors.white,
        surface: Colors.grey.shade900,
        onSurface: Colors.white70,
        surfaceVariant: Colors.black87,
        onSurfaceVariant: Colors.white70,
        surfaceTint: Colors.tealAccent,
        //
        error: Colors.red,
        // Red color for error
        onError: Colors.white,
      );

  ThemeData get defaultTheme => ThemeData(
        brightness: defaultBrightness,
        colorScheme: defaultColorScheme,
        useMaterial3: true,
      );

  ThemeData get defaultThemeWithGoogleFont => defaultTheme.copyWith(
        textTheme: GoogleFonts.cairoTextTheme(defaultTheme.textTheme),
      );

  @override
  Widget build(BuildContext context) {
    initControllers();

    SystemChrome.setSystemUIOverlayStyle(
      PredefinedStyle.systemUiOverlay(defaultThemeWithGoogleFont),
    );

    return GetMaterialApp(
      title: "GoTask",
      theme: defaultThemeWithGoogleFont,
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
    );
  }

  void initControllers() {
    Get.put<LoginController>(LoginController(), permanent: true);
    Get.put<NotesController>(NotesController(), permanent: true);
  }
}
