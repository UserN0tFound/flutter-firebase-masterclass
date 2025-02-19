import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:ecommerce_app/src/features/products_admin/data/image_upload_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'admin_product_upload_controller.g.dart';

@riverpod
class AdminProductUploadController extends _$AdminProductUploadController {
  @override
  FutureOr<void> build() {
    // no-op
  }

  Future<void> uploadProduct(Product product) async {
  try {
    // Met à jour l'état pour indiquer que le téléchargement est en cours
    state = const AsyncLoading();
    
    // Télécharge l'image du produit vers Firebase Storage et obtient l'URL de téléchargement
    final downloadUrl = await ref
        .read(imageUploadRepositoryProvider)
        .uploadProductImageFromAsset(product.imageUrl, product.id);
    
    // TODO: Enregistrer l'URL de téléchargement dans Firestore
    
    // Met à jour l'état pour indiquer que le téléchargement est terminé avec succès
    state = const AsyncData(null);
    
    // TODO: En cas de succès, rediriger vers la page de modification du produit
  } on Exception catch (e, st) {
    // Met à jour l'état pour indiquer qu'une erreur s'est produite
    state = AsyncError(e, st);
  }
}
}
