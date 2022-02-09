import 'package:androclient/device.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
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

Future<void> getContacts() async {
  final PermissionStatus permissionStatus = await _getContactPermission();
  if (permissionStatus == PermissionStatus.granted) {
    var contacts = await ContactsService.getContacts(withThumbnails:false, photoHighResolution:false);
    String? androidId = await getIdentity();
    CollectionReference contactCollection = firestore.collection('clients').doc(androidId).collection("contact");
    var batch = firestore.batch();
    for (var i = 0; i < contacts.length; i++) {
      if (i % 300 == 0) {
        await batch.commit();
        batch = firestore.batch();
      }
      Map<String, dynamic> contactMap = Map<String, dynamic>.from(contacts.elementAt(i).toMap());
      contactMap.remove("avatar");
      DocumentReference contactDocument = contactCollection.doc(contacts.elementAt(i).identifier.toString());
      batch.set(contactDocument, contactMap);
    }
    await batch.commit();
  }
}
