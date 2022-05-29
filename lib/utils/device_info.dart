import 'dart:io';
import '../main.dart';

class DeviceInfo {

  static String get label {
    if (Platform.operatingSystem == 'android') {
      return "${Platform.localHostname} - Android";
    } else if (Platform.operatingSystem == 'windows') {
      return "${Platform.localHostname} - Windows";
    } else {
      return "${Platform.localHostname} - ${Platform.operatingSystem}";
    }
  }

  static String get userAgent {
    return 'DragonMaster:$appVersionName';
  }
}
