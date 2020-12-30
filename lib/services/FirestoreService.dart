import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:productos/models/Product.dart';

class FirestoreService {
  FirebaseFirestore _db = FirebaseFirestore.instance;

  addProduct(Map<String, dynamic> data) {
    _db.collection('productos').add(data);
  }

  Future<void> updateProduct(Product data) {
    return _db.collection('productos').doc(data.id).update(data.toMap());
  }

  Future<void> deleteProduct(String id) {
    return _db.collection('productos').doc(id).delete();
  }
}
