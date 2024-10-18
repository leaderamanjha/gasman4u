import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  static Future<bool> requestLocationPermission() async {
    var status = await Permission.location.request();
    return status.isGranted;
  }

  static Future<bool> requestMicrophonePermission() async {
    var status = await Permission.microphone.request();
    return status.isGranted;
  }

  static Future<Map<Permission, bool>> requestAllPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.microphone,
    ].request();

    return {
      Permission.location: statuses[Permission.location]!.isGranted,
      Permission.microphone: statuses[Permission.microphone]!.isGranted,
    };
  }
}
