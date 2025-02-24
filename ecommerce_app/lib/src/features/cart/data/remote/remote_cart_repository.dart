import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:ecommerce_app/src/features/cart/domain/cart.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'remote_cart_repository.g.dart';

/// API for reading, watching and writing cart data for a specific user ID
class RemoteCartRepository {
  RemoteCartRepository(this._firestore);
  final FirebaseFirestore _firestore;

  /// Récupère les données du panier pour un utilisateur spécifique
  Future<Cart> fetchCart(UserID uid) async {
    // Référence au document du panier de l'utilisateur dans Firestore
    final ref = _cartRef(uid);
    // Récupère un instantané du document
    final snapshot = await ref.get();
    // Retourne les données du panier ou un panier vide si les données sont nulles
    return snapshot.data() ?? const Cart();
  }

  /// Écoute les changements en temps réel des données du panier pour un utilisateur spécifique
  Stream<Cart> watchCart(UserID uid) {
    // Référence au document du panier de l'utilisateur dans Firestore
    final ref = _cartRef(uid);
    // Écoute les instantanés du document et retourne les données du panier ou un panier vide si les données sont nulles
    return ref.snapshots().map((snapshot) => snapshot.data() ?? const Cart());
  }

  /// Met à jour les données du panier pour un utilisateur spécifique
  Future<void> setCart(UserID uid, Cart cart) async {
    // Référence au document du panier de l'utilisateur dans Firestore
    final ref = _cartRef(uid);
    // Met à jour les données du document avec les données du panier
    await ref.set(cart);
  }

  /// Crée une référence au document du panier de l'utilisateur dans Firestore avec un convertisseur pour Cart
  DocumentReference<Cart> _cartRef(UserID uid) =>
      _firestore.doc('cart/$uid').withConverter(
            fromFirestore: (doc, _) => Cart.fromMap(doc.data()!),
            toFirestore: (cart, _) => cart.toMap(),
          );
}

/// Fournisseur Riverpod pour RemoteCartRepository avec une durée de vie prolongée
@Riverpod(keepAlive: true)
RemoteCartRepository remoteCartRepository(Ref ref) {
  return RemoteCartRepository(FirebaseFirestore.instance);
}
