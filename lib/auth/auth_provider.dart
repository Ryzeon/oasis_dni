
import 'package:oasis_dni/auth/model/user.dart';

class IAuthProvider {

  Future<User> signInWithDNIAndPassword(String dni, String password) async {
    throw UnimplementedError();
  }

  Future<void> refresh() async {
    throw UnimplementedError();
  }

  Future<String> getToken() async {
    throw UnimplementedError();
  }

  Future<User> getUser() async {
    throw UnimplementedError();
  }

  void dispose() {}
}

