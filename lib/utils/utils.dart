import "package:flutter/foundation.dart";
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:oasis_dni/env/environment.dart';
import 'package:oasis_dni/utils/request_helper.dart';

class Utils {
  static const String dniRegex = r"^[0-9]{8}$";

  static PlatformType getPlatformType() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return PlatformType.android;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return PlatformType.web;
    } else if (defaultTargetPlatform == TargetPlatform.windows) {
      return PlatformType.windows;
    } else if (defaultTargetPlatform == TargetPlatform.linux) {
      return PlatformType.linux;
    } else if (defaultTargetPlatform == TargetPlatform.macOS) {
      return PlatformType.macos;
    } else {
      return PlatformType.web;
    }
  }

  static bool validateDNI(String dni) {
    final RegExp dniExp = RegExp(dniRegex);
    return dniExp.hasMatch(dni);
  }

  static bool isCellPhoneSize(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  static showError(BuildContext context, String message) {
    MotionToast.error(
            title: const Text("Error!"),
            description: Text(message),
            position: MotionToastPosition.bottom)
        .show(context);
  }

  static showSuccess(BuildContext context, String message) {
    MotionToast.success(
            title: const Text("Success!"),
            description: Text(message),
            position: MotionToastPosition.bottom)
        .show(context);
  }

  static Future<bool> isInternetAvailable() async {
    // try {
    //   final Response response =
    //       await RequestHelper.getRequestToServer("https://www.google.com");
    //   return response.statusCode == 200;
    // } catch (e) {
    //   return false;
    // }
    return true;
  }

  static Future<bool> isBackendOnline() async {
    String checkUrl = "status/ping";
    try {
      final Response response = await RequestHelper.getRequestToServer(
          "${Envionment.apiUrl}/$checkUrl");
      if (response.statusCode == 200) {
        return response.body == "Pong!";
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}

enum PlatformType {
  android,
  web,
  windows,
  linux,
  macos;

  bool get hasLocateCredentials => this == PlatformType.android;

  bool get canPrint =>
      this == PlatformType.web ||
      this == PlatformType.windows ||
      this == PlatformType.linux ||
      this == PlatformType.macos;

  String get name => toString().split('.').last;
}
