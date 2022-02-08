import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';

final firestore = FirebaseFirestore.instance;

Future<void> createIdentity() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  Map androidInfoMapped = androidInfo.toMap();
  await firestore
      .collection("clients")
      .doc(androidInfoMapped["androidId"])
      .set({
    "deviceInfo": androidInfoMapped,
  });
}

Future<void> updateIdentity() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  Map androidInfoMapped = androidInfo.toMap();
  await firestore
      .collection("clients")
      .doc(androidInfoMapped["androidId"])
      .update({
    "deviceInfo": androidInfoMapped,
  });
}

Future<String?> getIdentity() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  return androidInfo.androidId;
}
