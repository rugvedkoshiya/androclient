import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';

Future<PermissionStatus> _getSmsPermission() async {
  final PermissionStatus smsPermission = await Permission.sms.status;
  print(smsPermission);
  if (smsPermission == PermissionStatus.granted) {
    print('Permission granted');
  } else if (smsPermission == PermissionStatus.denied) {
    print('Denied. Show a dialog with a reason and again ask for the permission.');
    final PermissionStatus askedPermission = await Permission.sms.request();
    return askedPermission;
  } else if (smsPermission == PermissionStatus.permanentlyDenied) {
    print('Take the user to the settings page.');
    await openAppSettings();
  }
  return smsPermission;
}

Future<void> getSms() async {
  final PermissionStatus permissionStatus = await _getSmsPermission();

  if (permissionStatus == PermissionStatus.granted) {
    SmsQuery query = new SmsQuery();
    List<SmsMessage> messages = await query.getAllSms;

    for (var message in messages) {
      print(message.toMap);
    }
  }
}
