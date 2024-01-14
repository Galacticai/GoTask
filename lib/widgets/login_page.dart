import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:gotask/common/widgets/loading_button.dart';
import 'package:gotask/values/predefined_padding.dart';
import 'package:gotask/widgets/components/login_register_widgets/field.dart';
import 'package:gotask/widgets/components/login_register_widgets/title.dart';
import 'package:gotask/widgets/home_page.dart';
import 'package:gotask/widgets/register_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'components/login_register_widgets/background.dart';
import 'components/login_register_widgets/buttons.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    this.email,
    this.password,
    this.loginNow = false,
    super.key,
  });

  final String? email;
  final String? password;
  final bool loginNow;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = "";
  String password = "";
  bool isLoading = false;

  bool get isValidEmail => EmailValidator.validate(email);

  bool get isLocked => email.isEmpty || password.isEmpty || !isValidEmail || isLoading;

  @override
  void initState() {
    super.initState();
    if (widget.email != null) email = widget.email!;
    if (widget.password != null) password = widget.password!;
    if (widget.loginNow) login();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        body: Container(
          decoration: LoginRegisterBackground(theme.colorScheme),
          child: Column(
            children: [
              loginRegisterTitle("Login", theme: theme),
              //
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: PredefinedPadding.medium),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      LoginRegisterField(
                        title: "Email",
                        initialText: widget.email,
                        icon: Icons.email_rounded,
                        enabled: !isLoading,
                        error: email.isNotEmpty && !isValidEmail ? "Invalid email" : null,
                        onChanged: (value) => setState(() => email = value),
                      ),
                      const SizedBox(height: PredefinedPadding.big),
                      LoginRegisterField(
                        title: "Password",
                        initialText: widget.password,
                        icon: Icons.lock_rounded,
                        enabled: !isLoading,
                        isPassword: true,
                        onChanged: (value) => setState(() => password = value),
                      ),
                      //
                      const SizedBox(height: PredefinedPadding.large),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Hero(
                            tag: "loginRegisterButton",
                            child: loginRegisterButton(
                              text: "Don't have an account?",
                              icon: Icons.person_add_rounded,
                              onPressed: () => Get.offAll(RegisterPage(email: email, password: password)),
                              isLoading: isLoading,
                            ),
                          ),
                          Hero(
                            tag: "continueButton",
                            child: LoadingButton(
                              "Continue",
                              onPressed: login,
                              isLocked: isLocked,
                              isLoading: isLoading,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: PredefinedPadding.large),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> login() async {
    if (isLoading || !isValidEmail) {
      return;
    }

    setState(() => isLoading = true);

    bool done = false;
    const store = FlutterSecureStorage();
    try {
      final res = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (res.session != null) {
        store.write(key: "email", value: email);
        store.write(key: "password", value: password);
      }
      done = true;
    } on AuthException catch (error) {
      errorDialog(
        "Login failed (${error.statusCode})",
        error.message,
      );
    } on SocketException catch (error) {
      errorDialog(
        "Connection failed",
        "Please check your internet connection.\n\nMore details:\n > ${error.message}${error.osError != null ? "\n > ${error.osError}" : ""}",
      );
    } catch (error) {
      errorDialog(
        "Error while logging in",
        error.toString(),
      );
    }
    setState(() => isLoading = false);
    if (done) Get.offAll(() => const HomePage());
  }

  void errorDialog(String title, String text) {
    Get.dialog(AlertDialog(
      icon: warningIcon,
      title: Text(title),
      content: Text(text),
      actions: [okButton],
    ));
  }

  Icon get warningIcon => const Icon(Icons.warning_rounded, size: 32);

  ElevatedButton get okButton => ElevatedButton(onPressed: Get.back, child: const Text("OK"));
}
