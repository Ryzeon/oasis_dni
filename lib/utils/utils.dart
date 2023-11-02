import "package:flutter/foundation.dart";
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';

class Utils {
  static const String DNI_REGEX = r"^[0-9]{8}$";

  static PlatformType getPlatformType() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return PlatformType.Android;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return PlatformType.Web;
    } else if (defaultTargetPlatform == TargetPlatform.windows) {
      return PlatformType.Windows;
    } else if (defaultTargetPlatform == TargetPlatform.linux) {
      return PlatformType.Linux;
    } else if (defaultTargetPlatform == TargetPlatform.macOS) {
      return PlatformType.MacOS;
    } else {
      return PlatformType.Web;
    }
  }

  static bool validateDNI(String dni) {
    final RegExp dniExp = RegExp(DNI_REGEX);
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
}

enum PlatformType {
  Android,
  Web,
  Windows,
  Linux,
  MacOS;

  bool get hasLocateCredentials => this == PlatformType.Android;

  bool get canPrint =>
      this == PlatformType.Web ||
      this == PlatformType.Windows ||
      this == PlatformType.Linux ||
      this == PlatformType.MacOS;

  String get name => toString().split('.').last;
}
