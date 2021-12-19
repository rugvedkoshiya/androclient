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
    var contacts = await ContactsService.getContacts();
    for (var contact in contacts) {
      print(contact.androidAccountName);
      print(contact.displayName);
      print(contact.birthday);
      for (var email in contact.emails!) {
        print(email.value);
      }
      for (var phone in contact.phones!) {
        print(phone.value);
      }
    }
  }
}
