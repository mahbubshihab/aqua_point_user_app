import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/product_entity.dart';

class ProductsMockDatasource {
  final List<ProductEntity> _products = [];

  Future<List<ProductEntity>> fetchProducts() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('products').get();
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((docSnap) {
          final data = docSnap.data();
          return ProductEntity(
            id: docSnap.id,
            name: data['name'] ?? data['title'] ?? 'RO Purifier System',
            photoUrl: data['imageUrl'] ?? data['cloudinary_url'] ?? data['photoUrl'],
            warrantyDetails: data['warranty'] ?? '1 Year Official Warranty',
            purchaseDate: data['createdAt'] != null ? data['createdAt'].toString() : 'Active',
            isCustom: false,
          );
        }).toList();
      }
    } catch (e) {
      // Fallback to local memory if offline
    }
    return List.unmodifiable(_products);
  }

  Future<void> addProduct(ProductEntity product) async {
    try {
      await FirebaseFirestore.instance.collection('products').add({
        'name': product.name,
        'imageUrl': product.photoUrl,
        'warranty': product.warrantyDetails,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // Fallback
    }
    _products.insert(0, product);
  }
}

