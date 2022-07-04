import 'package:androclient/constant/firebase.constant.dart';
import 'package:device_info_plus/device_info_plus.dart';

Future<void> createIdentity() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  await firestore.collection("client").doc(androidInfo.id).set(
    {
      "deviceInfo": androidInfo.toMap(),
    },
  );
}

Future<void> updateIdentity() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  await firestore
      .collection("client")
      .doc(androidInfo.id)
      .update({
    "deviceInfo": androidInfo.toMap(),
  });
}

Future<String?> getIdentity() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  return androidInfo.id;
}
