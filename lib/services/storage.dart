import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Storage {
  Future uploadImageToFirebase(File _imageFile) async {
    firebase_storage.Reference storageReference = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('images/${_imageFile.path}');
    firebase_storage.UploadTask uploadTask =
        storageReference.putFile(_imageFile);
    await uploadTask.whenComplete(() => print('uploaded image'));
  }

  Future<Uint8List> loadImages(String path) async {
    path = 'images' + path;
    final firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref().child(path);
    var url;
    await ref
        .getData()
        .then((value) => url = value);
    return url;
  }

  Future<Uint8List> deleteImages(String path) async {
    path = 'images' + path;
    print(path);
    final firebase_storage.Reference ref =
    firebase_storage.FirebaseStorage.instance.ref().child(path);
    var url;
    await ref.delete();
    //print(url);
    return url;
  }
}
