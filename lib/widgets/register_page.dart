import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gotask/common/widgets/loading_button.dart';
import 'package:gotask/controllers/login_controller.dart';
import 'package:gotask/values/predefined_padding.dart';
import 'package:gotask/widgets/components/login_register_widgets/buttons.dart';
import 'package:gotask/widgets/components/login_register_widgets/field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'components/login_register_widgets/background.dart';
import 'components/login_register_widgets/title.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({
    this.email,
    this.password,
    super.key,
  });

  final String? email;
  final String? password;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isLoading = false;

  String email = "";
  String password = "";
  String passwordRepeat = "";

  bool get isValidEmail => EmailValidator.validate(email);

  bool get isValidPassword => LoginController.validPassword(password);

  bool get isLocked =>
      email.isEmpty || //
      password.isEmpty ||
      passwordRepeat.isEmpty ||
      //
      !isPasswordConfirmed ||
      !isValidPassword ||
      !isValidEmail ||
      isLoading;

  bool get isPasswordConfirmed =>
      isValidPassword && //
      password.isNotEmpty &&
      password == passwordRepeat;

  bool get isPasswordError => password.isNotEmpty && !isValidPassword;

  bool get isPasswordRepeatError =>
      password.isNotEmpty &&
      passwordRepeat.isNotEmpty && //
      (password != passwordRepeat || !isValidPassword);

  @override
  void initState() {
    super.initState();
    if (widget.email != null) email = widget.email!;
    if (widget.password != null) password = widget.password!;
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
              loginRegisterTitle("Register", theme: theme),
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
                        error: email.isNotEmpty && !isValidEmail ? "Invalid email" : null,
                        enabled: !isLoading,
                        onChanged: (value) => setState(() => email = value),
                      ),
                      //
                      const SizedBox(height: PredefinedPadding.big),
                      //
                      LoginRegisterField(
                        title: "Password",
                        initialText: widget.password,
                        icon: Icons.lock_rounded,
                        enabled: !isLoading,
                        error: isPasswordError
                            ? isValidPassword
                                ? ""
                                : "6+ characters required. Must contain letters & numbers. Other characters are allowed"
                            : null,
                        isPassword: true,
                        onChanged: (value) => setState(() => password = value),
                      ),
                      //
                      const SizedBox(height: PredefinedPadding.big),
                      //
                      LoginRegisterField(
                        title: "Repeat password",
                        icon: Icons.lock_reset_rounded,
                        enabled: !isLoading,
                        error: isPasswordRepeatError
                            ? isValidPassword
                                ? "Incorrect password"
                                : "Invalid password"
                            : null,
                        isPassword: true,
                        onChanged: (value) => setState(() => passwordRepeat = value),
                      ),
                      //
                      const SizedBox(height: PredefinedPadding.large),
                      //
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Hero(
                            tag: "loginRegisterButton",
                            child: loginRegisterButton(
                              text: "Already have an account?",
                              icon: Icons.login_rounded,
                              onPressed: () => Get.offAll(() => LoginPage(email: email, password: password)),
                              isLoading: isLoading,
                            ),
                          ),
                          Hero(
                            tag: "continueButton",
                            child: LoadingButton(
                              "Continue",
                              onPressed: register,
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

  Future<void> register() async {
    if (!isPasswordConfirmed || !isValidEmail) {
      return;
    }

    setState(() => isLoading = true);
    bool fail = true;
    try {
      await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );

      fail = false;
    } on AuthException catch (error) {
      Get.dialog(AlertDialog(
        icon: warningIcon,
        title: Text("Login failed (${error.statusCode})"),
        content: Text(error.message),
        actions: [okButton],
      ));
    } on SocketException catch (error) {
      Get.dialog(AlertDialog(
        icon: warningIcon,
        title: const Text("Connection failed"),
        content: Text(
          "Please check your internet connection.\n\nMore details:\n > ${error.message}${error.osError != null ? "\n > ${error.osError}" : ""}",
        ),
        actions: [okButton],
      ));
    } catch (error) {
      Get.dialog(AlertDialog(
        title: const Text("Error while registering"),
        content: Text(error.toString()),
      ));
    }
    setState(() => isLoading = false);
    if (!fail) {
      await Get.dialog(const AlertDialog(
        title: Text("Almost there!"),
        content: Text(
            "You will receive a confirmation email very soon. Please check your inbox.\nIf you don't see it, check your spam folder."),
      ));
      Get.offAll(() => LoginPage(email: email, password: password));
    }
  }

  void errorSnack(ThemeData theme, String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      colorText: theme.colorScheme.error,
    );
  }

  Icon get warningIcon => const Icon(Icons.warning_rounded, size: 32);

  ElevatedButton get okButton => ElevatedButton(onPressed: Get.back, child: const Text("OK"));
}
