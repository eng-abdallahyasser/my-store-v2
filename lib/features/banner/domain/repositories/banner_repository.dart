import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store_app_v2/features/banner/domain/models/banner_model.dart';
import 'package:store_app_v2/features/banner/domain/models/others_banner_model.dart';
import 'package:store_app_v2/features/banner/domain/models/promotional_banner_model.dart';
import 'package:store_app_v2/features/banner/domain/repositories/banner_repository_interface.dart';

class BannerRepository implements BannerRepositoryInterface {
  final FirebaseFirestore firestore;
  BannerRepository({required this.firestore});

  @override
  Future getList({int? offset, bool isBanner = false, bool isTaxiBanner = false, bool isFeaturedBanner = false, bool isParcelOtherBanner = false, bool isPromotionalBanner = false}) async {
    if (isBanner) {
      return await _getBannerList();
    } else if (isTaxiBanner) {
      return await _getTaxiBannerList();
    } else if (isFeaturedBanner) {
      return await _getFeaturedBannerList();
    } else if (isParcelOtherBanner) {
      return await _getParcelOtherBannerList();
    } else if (isPromotionalBanner) {
      return await _getPromotionalBannerList();
    }
  }

  Future<BannerModel?> _getBannerList() async {
    try {
      final snapshot = await firestore.collection('banners').get();
      final banners = snapshot.docs.map((doc) => Banner.fromJson(doc.data())).toList();
      return BannerModel(banners: banners);
    } catch (e) {
      return null;
    }
  }

  Future<BannerModel?> _getTaxiBannerList() async {
    // Assuming taxi banners have a 'type' field set to 'taxi'
    try {
      final snapshot = await firestore.collection('banners').where('type', isEqualTo: 'taxi').get();
      final banners = snapshot.docs.map((doc) => Banner.fromJson(doc.data())).toList();
      return BannerModel(banners: banners);
    } catch (e) {
      return null;
    }
  }

  Future<BannerModel?> _getFeaturedBannerList() async {
    // Assuming featured banners have a 'featured' field set to true
    try {
      final snapshot = await firestore.collection('banners').where('featured', isEqualTo: true).get();
      final banners = snapshot.docs.map((doc) => Banner.fromJson(doc.data())).toList();
      return BannerModel(banners: banners);
    } catch (e) {
      return null;
    }
  }

  Future<ParcelOtherBannerModel?> _getParcelOtherBannerList() async {
    // This model seems different, assuming it's in a separate collection 'parcel_banners'
    try {
      final snapshot = await firestore.collection('parcel_banners').get();
      final banners = snapshot.docs.map((doc) => Banners.fromJson(doc.data())).toList();
      return ParcelOtherBannerModel(banners: banners);
    } catch (e) {
      return null;
    }
  }

  Future<PromotionalBanner?> _getPromotionalBannerList() async {
    // This model also seems different, assuming it's in a separate document 'promotional_banners/default'
    try {
      final snapshot = await firestore.collection('promotional_banners').doc('default').get();
      return PromotionalBanner.fromJson(snapshot.data() as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  Future add(value) {
    throw UnimplementedError();
  }

  Future delete(int? id) {
    throw UnimplementedError();
  }

  Future get(String? id) {
    throw UnimplementedError();
  }

  Future update(Map<String, dynamic> body, int? id) {
    throw UnimplementedError();
  }

}