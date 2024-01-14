import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:gotask/widgets/home_page.dart';
import 'package:gotask/widgets/login_page.dart';
import 'package:gotask/widgets/register_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginController extends GetxController {
  final Rx<AuthChangeEvent> event = AuthChangeEvent.initialSession.obs;
  final Rx<Session?> session = Rx<Session?>(null);

  bool isLoggedIn = false;

  @override
  void onInit() {
    super.onInit();
    Supabase.instance.client.auth.onAuthStateChange.listen(_onAuthStateChange);
  }

  Future<void> _onAuthStateChange(AuthState state) async {
    event(state.event);
    session(state.session);

    const store = FlutterSecureStorage();
    const didLoginKey = 'didLogin';

    //? Keeping for future reference
    switch (state.event) {
      // case AuthChangeEvent.initialSession:
      //   break;
      // case AuthChangeEvent.passwordRecovery:
      //   break;
      case AuthChangeEvent.signedIn:
        isLoggedIn = true;
        await store.write(key: didLoginKey, value: 'true');
        Get.offAll(() => const HomePage());
        break;

      default:
        isLoggedIn = false;
        final didLogin = (await store.read(key: didLoginKey)) == 'true';

        final email = await store.read(key: 'email');
        final password = await store.read(key: 'password');

        if (didLogin) {
          if (email != null && password != null) {
            Get.offAll(() => LoginPage(email: email, password: password, loginNow: true));
          } else {
            Get.offAll(() => const LoginPage());
          }
        } else {
          Get.offAll(() => const RegisterPage());
        }
        break;
      // case AuthChangeEvent.tokenRefreshed:
      //   break;
      // case AuthChangeEvent.userUpdated:
      //   break;
      // case AuthChangeEvent.userDeleted:
      //   break;
      // case AuthChangeEvent.mfaChallengeVerified:
      //   break;
    }
  }

  static void logout() {
    Supabase.instance.client.auth.signOut();
    const store = FlutterSecureStorage();
    store.delete(key: 'email');
    store.delete(key: 'password');
  }

  static bool validPassword(String password) {
    if (password.length < 6) return false;
    //! 1 by 1 to enforce AND logic without complicated regex
    if (!RegExp(r"[a-zA-Z]").hasMatch(password)) return false;
    if (!RegExp(r"[0-9]").hasMatch(password)) return false;
    return true;
  }
}
