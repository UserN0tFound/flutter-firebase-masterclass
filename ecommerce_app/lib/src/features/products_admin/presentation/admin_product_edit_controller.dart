import 'package:ecommerce_app/src/features/products/data/products_repository.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:ecommerce_app/src/features/products_admin/application/image_upload_service.dart';
import 'package:ecommerce_app/src/routing/app_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'admin_product_edit_controller.g.dart';

@riverpod
class AdminProductEditController extends _$AdminProductEditController {
  @override
  FutureOr<void> build() {
    // no-op
  }

  Future<bool> updateProduct({
    required Product product,
    required String title,
    required String description,
    required String price,
    required String availableQuantity,
  }) async {
    final productRepository = ref.read(productsRepositoryProvider);

    final updatedProduct = product.copyWith(
      title: title,
      description: description,
      price: double.parse(price),
      availableQuantity: int.parse(availableQuantity),
    );

    state = const AsyncLoading();

    await AsyncValue.guard(
        () => productRepository.updateProduct(updatedProduct));

    final success = state.hasError == false;

    if (success) {
      ref.read(goRouterProvider).pop();
    }
    return success;
  }

  Future<void> deleteProduct(Product product) async {
    final imageUploadService = ref.read(imageUploadServiceProvider);

    state = const AsyncLoading();

    await AsyncValue.guard(() => imageUploadService.deleteProduct(product));

    final success = state.hasError == false;

    if (success) {
      ref.read(goRouterProvider).pop();
    }
  }
}
