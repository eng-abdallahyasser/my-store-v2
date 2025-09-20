import 'package:package_info_plus/package_info_plus.dart';

class AppUtils {
  static Future<String> getAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    final version = info.version; // e.g. 1.0.1
    final buildNumber = info.buildNumber; // e.g. 2
    return 'v$version ($buildNumber)';
  }
}