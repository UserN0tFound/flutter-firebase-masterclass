import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'image_upload_repository.g.dart';

/// Class for uploading images to Firebase Storage
class ImageUploadRepository {
  ImageUploadRepository(this._storage);
  final FirebaseStorage _storage;

  /// Upload an image asset to Firebase Storage and returns the download URL
  Future<String> uploadProductImageFromAsset(
      String assetPath, ProductID productId) async {
    // Charge les données de l'image à partir du chemin d'accès de l'actif
    final byteData = await rootBundle.load(assetPath);

    // Divise le chemin d'accès de l'actif en composants
    final components = assetPath.split('/');

    // Récupère le nom du fichier à partir des composants du chemin d'accès
    final fileName = components[2];

    // Télécharge les données de l'image vers Firebase Storage
    final result = await _uploadAsset(byteData, fileName);

    // Retourne l'URL de téléchargement de l'image
    return result.ref.getDownloadURL();
  }

  UploadTask _uploadAsset(ByteData byteData, String filename) {
    // Convertit les données de l'image en un tableau d'octets
    final bytes = byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);

    // Crée une référence à Firebase Storage en utilisant le chemin 'products/$filename'
    final ref = _storage.ref('products/$filename');

    // Télécharge les données de l'image vers Firebase Storage
    return ref.putData(
      bytes,
      // Définit les métadonnées du fichier, ici le type de contenu est 'image/jpeg'
      SettableMetadata(contentType: 'image/jpeg'),
    );
  }
}

@riverpod
ImageUploadRepository imageUploadRepository(Ref ref) {
  return ImageUploadRepository(FirebaseStorage.instance);
}
