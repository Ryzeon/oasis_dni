import 'package:oasis_dni/model/dni.dart';
import 'package:oasis_dni/request/request.dart';

class DNIRequest extends IRequest {
  @override
  String getPath() {
    return "/customer/dni_fully/";
  }

  @override
  DNI getModel(Map<String, dynamic> json) {
    return DNI.fromJson(json);
  }
}