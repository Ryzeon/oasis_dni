import 'package:oasis_dni/utils/login/login_utils.dart';

class RetrieveSession {
  final String user;
  final String password;

  RetrieveSession(this.user, this.password);

  bool isValid() {
    return user.isNotEmpty && password.isNotEmpty;
  }

  Future<bool> isValidLogin() async{
    return await LoginUtils.login(user, password);
  }
}