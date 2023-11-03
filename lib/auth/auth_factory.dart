import 'package:oasis_dni/auth/auth_provider.dart';
import 'package:oasis_dni/auth/impl/simple_auth.dart';

class AuthFactory {
  static AuthFactory? _auth;

  static AuthFactory get instance {
    _auth ??= AuthFactory();
    return _auth!;
  }

  final IAuthProvider _authProvider = SimpleAuth();

  IAuthProvider get authProvider => _authProvider;
}
