import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/product_entity.dart';

abstract class ProductsRemoteDatasource {
  Future<List<ProductEntity>> fetchProducts({String? targetCategory});
  Future<List<ProductEntity>> fetchCustomProducts({String? userId});
  Future<List<ProductEntity>> fetchPurchasedProducts({String? userId});
  Future<List<CategoryEntity>> fetchCategories();
  Future<void> addCustomProduct(ProductEntity product, {String? userId});
}

class ProductsRemoteDatasourceImpl implements ProductsRemoteDatasource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ProductsRemoteDatasourceImpl({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : firestore = firestore ?? FirebaseFirestore.instance,
        auth = auth ?? FirebaseAuth.instance;

  String _getUserId(String? userId) {
    return userId ?? auth.currentUser?.uid ?? 'guest_user';
  }

  @override
  Future<List<ProductEntity>> fetchProducts({String? targetCategory}) async {
    Query<Map<String, dynamic>> query = firestore.collection('products');
    if (targetCategory != null && targetCategory.isNotEmpty && targetCategory != 'All') {
      query = query.where('category', isEqualTo: targetCategory);
    }
    final snapshot = await query.get();

    return snapshot.docs.map((docSnap) {
      final data = docSnap.data();
      final rawPrice = data['price'];
      final rawOrigPrice = data['originalPrice'] ?? data['oldPrice'];
      final rawRating = data['rating'];
      final rawReviews = data['reviewsCount'];

      return ProductEntity(
        id: docSnap.id,
        name: data['name'] ?? data['title'] ?? 'RO Water Purifier',
        photoUrl: data['imageUrl'] ?? data['cloudinary_url'] ?? data['photoUrl'],
        warrantyDetails: data['warranty'] ?? data['warrantyDetails'] ?? '1 Year Official Warranty',
        purchaseDate: data['createdAt'] != null ? data['createdAt'].toString() : 'Available',
        isCustom: data['isCustom'] ?? false,
        price: rawPrice != null ? (rawPrice as num).toDouble() : 0.0,
        originalPrice: rawOrigPrice != null ? (rawOrigPrice as num).toDouble() : null,
        category: data['category'] ?? data['categoryId'] ?? 'RO Water Purifiers',
        rating: rawRating != null ? (rawRating as num).toDouble() : 4.8,
        reviewsCount: rawReviews != null ? (rawReviews as num).toInt() : 0,
        description: data['description'] ?? 'High quality water purification system and parts.',
        inStock: data['inStock'] ?? true,
      );
    }).toList();
  }

  @override
  Future<List<ProductEntity>> fetchCustomProducts({String? userId}) async {
    final uid = _getUserId(userId);
    QuerySnapshot<Map<String, dynamic>> snapshot;
    try {
      snapshot = await firestore
          .collection('customers')
          .doc(uid)
          .collection('custom_products')
          .orderBy('createdAt', descending: true)
          .limit(15)
          .get();
    } catch (_) {
      snapshot = await firestore
          .collection('customers')
          .doc(uid)
          .collection('custom_products')
          .limit(15)
          .get();
    }

    return snapshot.docs.map((docSnap) {
      final data = docSnap.data();
      final rawPrice = data['price'];
      final rawRating = data['rating'];
      final rawReviews = data['reviewsCount'];

      return ProductEntity(
        id: docSnap.id,
        name: data['name'] ?? 'Custom Product',
        photoUrl: data['photoUrl'] ?? data['imageUrl'],
        warrantyDetails: data['warrantyDetails'] ?? data['warranty'] ?? '1 Year Warranty',
        purchaseDate: data['purchaseDate'] ?? 'Available',
        isCustom: true,
        price: rawPrice != null ? (rawPrice as num).toDouble() : 0.0,
        category: data['category'] ?? 'Custom Product',
        rating: rawRating != null ? (rawRating as num).toDouble() : 5.0,
        reviewsCount: rawReviews != null ? (rawReviews as num).toInt() : 0,
        description: data['description'] ?? '',
        inStock: true,
      );
    }).toList();
  }

  @override
  Future<List<ProductEntity>> fetchPurchasedProducts({String? userId}) async {
    final uid = _getUserId(userId);
    final List<ProductEntity> purchasedProducts = [];
    QuerySnapshot<Map<String, dynamic>> snapshot;
    try {
      snapshot = await firestore
          .collection('orders')
          .where('userId', isEqualTo: uid)
          .get();
    } catch (_) {
      try {
        snapshot = await firestore.collection('orders').get();
      } catch (_) {
        return [];
      }
    }

    for (final docSnap in snapshot.docs) {
      final data = docSnap.data();
      final orderUserId = data['userId'] ?? 'guest_user';
      if (orderUserId != uid && uid != 'guest_user') continue;

      final status = (data['status'] ?? '').toString().toLowerCase();
      if (status == 'confirmed' || status == 'delivered') {
        final items = data['items'] as List<dynamic>? ?? [];
        final orderDate = data['date'] ??
            (data['createdAt'] != null ? data['createdAt'].toString() : 'Purchased');

        if (items.isNotEmpty) {
          for (final item in items) {
            if (item is Map<String, dynamic>) {
              final rawPrice = item['price'];
              purchasedProducts.add(
                ProductEntity(
                  id: item['id'] ?? item['productId'] ?? 'PUR-${docSnap.id}',
                  name: item['name'] ?? 'Purchased Product',
                  photoUrl: item['imageUrl'] ?? item['photoUrl'],
                  warrantyDetails: item['warranty'] ?? item['warrantyDetails'] ?? '1 Year Warranty',
                  purchaseDate: orderDate,
                  isCustom: false,
                  price: rawPrice != null ? (rawPrice as num).toDouble() : 0.0,
                  category: item['category'] ?? 'Water Purifiers',
                  rating: 5.0,
                  reviewsCount: 0,
                  description: item['description'] ?? 'Purchased from Aqua Point',
                  inStock: true,
                ),
              );
            }
          }
        } else if (data['title'] != null || data['name'] != null) {
          final rawPrice = data['totalAmount'] ?? data['amount'] ?? data['price'];
          purchasedProducts.add(
            ProductEntity(
              id: docSnap.id,
              name: data['title'] ?? data['name'] ?? 'Purchased Purifier',
              photoUrl: data['imageUrl'] ?? data['photoUrl'],
              warrantyDetails: data['warranty'] ?? '1 Year Warranty',
              purchaseDate: orderDate,
              isCustom: false,
              price: rawPrice != null ? (rawPrice as num).toDouble() : 0.0,
              category: data['category'] ?? 'Water Purifiers',
              rating: 5.0,
              reviewsCount: 0,
              description: data['description'] ?? 'Purchased from Aqua Point',
              inStock: true,
            ),
          );
        }
      }
    }
    return purchasedProducts;
  }

  @override
  Future<List<CategoryEntity>> fetchCategories() async {
    final snapshot = await firestore.collection('categories').limit(15).get();
    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.map((docSnap) {
        final data = docSnap.data();
        return CategoryEntity(
          id: docSnap.id,
          name: data['name'] ?? data['title'] ?? 'Category',
          icon: data['icon'],
          imageUrl: data['imageUrl'],
          productCount: (data['productCount'] as num?)?.toInt() ?? 0,
        );
      }).toList();
    }
    return [];
  }

  @override
  Future<void> addCustomProduct(ProductEntity product, {String? userId}) async {
    final uid = _getUserId(userId);
    await firestore
        .collection('customers')
        .doc(uid)
        .collection('custom_products')
        .add({
      'name': product.name,
      'photoUrl': product.photoUrl,
      'imageUrl': product.photoUrl,
      'warrantyDetails': product.warrantyDetails,
      'purchaseDate': product.purchaseDate,
      'isCustom': true,
      'price': product.price,
      'category': product.category ?? 'Custom Product',
      'description': product.description ?? '',
      'userId': uid,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
