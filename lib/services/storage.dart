import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<String> uploadImage(String path, String fileName) async {
    String downloadURL = await storage.ref('$path/$fileName').getDownloadURL();
    return downloadURL;
  }

  Future deleteImage(String url) async {
    await storage.refFromURL(url).delete();
  }
}
