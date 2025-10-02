import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store_app_v2/data/data_source/base_repository.dart';

class FavoritesRepository extends BaseRepository {
  Future<List<String>> getFavorites(String userID) async {
    DocumentSnapshot userSnapshot =
        await firestore.collection('users').doc(userID).get();

    if (userSnapshot.exists) {
      final data = userSnapshot.data() as Map<String, dynamic>?;
      final List<dynamic> favorites = data?['favorites'] ?? [];
      return List<String>.from(favorites);
    }
    return [];
  }

  Future<int> addToFavorites(String productId, String userId) async {
    DocumentReference docRef = firestore.collection("products").doc(productId);
    DocumentReference userRef = firestore.collection('users').doc(userId);
    int currentFavoriteCount = 0;

    await firestore.runTransaction((transaction) async {
      DocumentSnapshot docSnapshot = await transaction.get(docRef);
      currentFavoriteCount =
          (docSnapshot.data() as Map<String, dynamic>)['favouritecount'] ?? 0;
      if (docSnapshot.exists) {
        transaction.update(docRef, {
          "favouritecount": currentFavoriteCount + 1,
        });
      }

      await userRef.set({
        'favorites': FieldValue.arrayUnion([productId]),
      }, SetOptions(merge: true));
    });

    return currentFavoriteCount + 1;
  }

  Future<int> removeFromFavorites(String productId, String userId) async {
    DocumentReference docRef = firestore.collection("products").doc(productId);
    DocumentReference userRef = firestore.collection('users').doc(userId);
    int newFavoriteCount = 0;

    await firestore.runTransaction((transaction) async {
      DocumentSnapshot docSnapshot = await transaction.get(docRef);

      if (docSnapshot.exists) {
        int currentFavoriteCount =
            (docSnapshot.data() as Map<String, dynamic>)['favouritecount'] ?? 0;
        newFavoriteCount =
            currentFavoriteCount > 0 ? currentFavoriteCount - 1 : 0;
        transaction.update(docRef, {"favouritecount": newFavoriteCount});
      }

      await userRef.update({
        'favorites': FieldValue.arrayRemove([productId]),
      });
    });
    return newFavoriteCount;
  }
}
