import 'package:oasis_dni/auth/auth_factory.dart';
import 'package:oasis_dni/auth/model/retrieve_session.dart';
import 'package:oasis_dni/auth/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginUtils {
  static bool isDNI(String dni) {
    final dniExp = RegExp(r"^[0-9]{8}$");
    return dniExp.hasMatch(dni);
  }

  static Future<bool> login(String user, String password) async {
    if (!isDNI(user)) {
      return false;
    }
    try {
      User loggedUser = await AuthFactory.instance.authProvider
          .signInWithDNIAndPassword(user, password);
      return loggedUser.username == user;
    } catch (e) {
      return false;
    }
  }

  static Future<RetrieveSession> retrieveLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? user = prefs.getString("user");
    final String? password = prefs.getString("password");
    if (user == null || password == null) {
      return RetrieveSession("", "");
    }
    return RetrieveSession(user, password);
  }

  static void saveSession(String user, String password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("user", user);
    prefs.setString("password", password);
  }

  static void logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("user");
    prefs.remove("password");
    AuthFactory.instance.authProvider.dispose();
  }
}
