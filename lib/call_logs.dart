import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:call_log/call_log.dart';

Future<PermissionStatus> _getCallLogPermission() async {
  final PermissionStatus callLogPermission = await Permission.phone.status;
  print(callLogPermission);
  if (callLogPermission == PermissionStatus.granted) {
    print('Permission granted');
  } else if (callLogPermission == PermissionStatus.denied) {
    print(
        'Denied. Show a dialog with a reason and again ask for the permission.');
    final PermissionStatus askedpermission = await Permission.phone.request();
    return askedpermission;
  } else if (callLogPermission == PermissionStatus.permanentlyDenied) {
    print('Take the user to the settings page.');
    await openAppSettings();
  }
  return callLogPermission;
}

Future<void> getCallLogs() async {
  final PermissionStatus permissionStatus = await _getCallLogPermission();
  
  if (permissionStatus == PermissionStatus.granted) {

    // method 1
    Iterable<CallLogEntry> logs = await CallLog.get();
    for (var log in logs) {
      print(log.callType);
      print(log.duration);
      print(log.formattedNumber);
      print(log.name);
      print(log.number);
      print(log.timestamp);
    }

    // method 2 (last 60 days)
    // var now = DateTime.now();
    // int from = now.subtract(const Duration(days: 60)).millisecondsSinceEpoch;
    // int to = now.subtract(const Duration(days: 30)).millisecondsSinceEpoch;
    // Iterable<CallLogEntry> logs2 = await CallLog.query(
    //       dateFrom: from,
    //       dateTo: to,
    //       durationFrom: 0,
    //       durationTo: 60,
    //     );
  }
}
