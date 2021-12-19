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

Future<void> getStorage() async {
  final PermissionStatus permissionStatus = await _getStoragePermission();

  if (permissionStatus == PermissionStatus.granted) {
    // method 1
    final albums = await PhotoManager.getAssetPathList();
    for (var album in albums) {
      print(album.albumType);
      print(album.assetCount);
      print(album.id);
      print(album.name);
      final subAlbum = await album.getAssetListRange(start:0, end:1000000);
      print(subAlbum.length);
      for (var sub in subAlbum) {
          print(sub.createDateTime);
          print(sub.file);
          print(sub.height);
          print(sub.id);
          print(sub.isFavorite);
          print(sub.mimeType);
          print(sub.originFile);
          print(sub.originBytes);
          print(sub.title);
          print(sub.thumbData);
          break;
        }
      break;
    }
  }
}
