
import 'package:http/http.dart';
import 'package:oasis_dni/auth/auth_provider.dart';
import 'package:oasis_dni/auth/exception/invalid_auth_exception.dart';
import 'package:oasis_dni/auth/model/login.dart';
import 'package:oasis_dni/auth/model/user.dart';
import 'package:oasis_dni/request/request_method.dart';
import 'package:oasis_dni/utils/request_helper.dart';

class SimpleAuth implements IAuthProvider {
  User? _loggedUser;

  String? _pwd;


  @override
  Future<User> getUser() async {
    if (_loggedUser == null) {
      throw InvalidAuthException("User is not logged in");
    }
    return Future.value(_loggedUser);
  }

  @override
  void dispose() {
    _loggedUser = null;
    _pwd = null;
  }

  @override
  Future<String> getToken() async {
    if (_loggedUser == null) {
      throw InvalidAuthException("User is not logged in");
    }
    return Future.value(_loggedUser!.token);
  }


  @override
  Future<User> signInWithDNIAndPassword(String id, String password) async {
    _pwd = password;
    Login login = Login(username: id, password: password);
    try {
      Response response = await RequestHelper.getRequestToServer("/auth/signin",
          bodydata: login.toJson(), requestMethod: RequestMethod.POST);
      if (response.statusCode != 200) {
        throw InvalidAuthException("Invalid credentials");
      }
      Map<String, dynamic> json = RequestHelper.getJsonFromResponse(response);
      _loggedUser = User.fromJson(json);
      return Future.value(_loggedUser);
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  @override
  Future<void> refresh() async {
    if (_loggedUser == null) {
      throw InvalidAuthException("User is not logged in");
    }
    await signInWithDNIAndPassword(_loggedUser!.username, _pwd!);
    return Future.value();
  }
}
