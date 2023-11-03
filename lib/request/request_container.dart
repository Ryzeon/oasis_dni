import 'package:oasis_dni/request/impl/dni_request.dart';
import 'package:oasis_dni/request/request.dart';

class RequestContainer {
  // Create singleton to get instance of RequestContainer
  static final RequestContainer _instance = RequestContainer._internal();
  factory RequestContainer() => _instance;
  RequestContainer._internal();

  // Create variables to store data
  final Map<String, IRequest> _requests = Map.from({
    "dni": DNIRequest(),
  });

  IRequest<T> getRequest<T>(String key) {
    return _requests[key] as IRequest<T>;
  }
}
