import 'package:get/get.dart';
import 'dart:developer' as dev;
import 'package:store_app_v2/features/banner/domain/models/banner_model.dart';
import 'package:store_app_v2/features/banner/domain/models/others_banner_model.dart';
import 'package:store_app_v2/features/banner/domain/models/promotional_banner_model.dart';
import 'package:store_app_v2/features/banner/domain/services/banner_service_interface.dart';

class BannerController extends GetxController implements GetxService {
  final BannerServiceInterface bannerServiceInterface;
  BannerController({required this.bannerServiceInterface});

  @override
  void onInit() {
    super.onInit();
    // Load banners on controller initialization
    getBannerList(false);
    getFeaturedBanner();
  }

  List<String?>? _bannerImageList;
  List<String?>? get bannerImageList => _bannerImageList;

  List<String?>? _taxiBannerImageList;
  List<String?>? get taxiBannerImageList => _taxiBannerImageList;

  List<String?>? _featuredBannerList;
  List<String?>? get featuredBannerList => _featuredBannerList;

  List<dynamic>? _bannerDataList;
  List<dynamic>? get bannerDataList => _bannerDataList;

  List<dynamic>? _taxiBannerDataList;
  List<dynamic>? get taxiBannerDataList => _taxiBannerDataList;

  List<dynamic>? _featuredBannerDataList;
  List<dynamic>? get featuredBannerDataList => _featuredBannerDataList;

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  ParcelOtherBannerModel? _parcelOtherBannerModel;
  ParcelOtherBannerModel? get parcelOtherBannerModel => _parcelOtherBannerModel;

  PromotionalBanner? _promotionalBanner;
  PromotionalBanner? get promotionalBanner => _promotionalBanner;

  Future<void> getFeaturedBanner() async {
    BannerModel? bannerModel =
        await bannerServiceInterface.getFeaturedBannerList();
    _featuredBannerList = [];
    _featuredBannerDataList = [];

    List<int?> moduleIdList = bannerServiceInterface.moduleIdList();

    // Safe iterate campaigns list
    final campaigns = bannerModel?.campaigns ?? const [];
    for (final campaign in campaigns) {
      _featuredBannerList!.add(campaign.image);
      _featuredBannerDataList!.add(campaign);
    }
    // Safe iterate banners list
    final banners = bannerModel?.banners ?? const [];
    for (final banner in banners) {
      _featuredBannerList!.add(banner.image);
      if (banner.item != null &&
          moduleIdList.contains(banner.item!.moduleId)) {
        _featuredBannerDataList!.add(banner.item);
      } else if (banner.store != null &&
          moduleIdList.contains(banner.store!.moduleId)) {
        _featuredBannerDataList!.add(banner.store);
      } else if (banner.type == 'default') {
        _featuredBannerDataList!.add(banner.link);
      } else {
        _featuredBannerDataList!.add(null);
      }
    }

    // Dev logs: featured banners fetched
    dev.log('Featured banners fetched: ${_featuredBannerList?.length ?? 0}');
    if (_featuredBannerList != null) {
      for (var i = 0; i < _featuredBannerList!.length; i++) {
        final img = _featuredBannerList![i];
        final data = _featuredBannerDataList != null && _featuredBannerDataList!.length > i
            ? _featuredBannerDataList![i]
            : null;
        dev.log('Featured[$i]: image=$img | dataType=${data?.runtimeType}');
      }
    }

    update();
  }

  Future<void> getBannerList(bool reload) async {
    if (_bannerImageList == null || reload) {
      _bannerImageList = null;
      BannerModel? bannerModel = await bannerServiceInterface.getBannerList();
      _bannerImageList = [];
      _bannerDataList = [];
      // Safe iterate campaigns list
      final campaigns = bannerModel?.campaigns ?? const [];
      for (final campaign in campaigns) {
        _bannerImageList!.add(campaign.image);
        _bannerDataList!.add(campaign);
      }
      // Safe iterate banners list
      final banners = bannerModel?.banners ?? const [];
      for (final banner in banners) {
        _bannerImageList!.add(banner.image);
        if (banner.item != null) {
          _bannerDataList!.add(banner.item);
        } else if (banner.store != null) {
          _bannerDataList!.add(banner.store);
        } else if (banner.type == 'default') {
          _bannerDataList!.add(banner.link);
        } else {
          _bannerDataList!.add(null);
        }
      }

      // Dev logs: general banners fetched
      dev.log('Banners fetched: ${_bannerImageList?.length ?? 0}');
      if (_bannerImageList != null) {
        for (var i = 0; i < _bannerImageList!.length; i++) {
          final img = _bannerImageList![i];
          final data = _bannerDataList != null && _bannerDataList!.length > i ? _bannerDataList![i] : null;
          dev.log('Banner[$i]: image=$img | dataType=${data?.runtimeType}');
        }
      }

      update();
    }
  }

  Future<void> getTaxiBannerList(bool reload) async {
    if (_taxiBannerImageList == null || reload) {
      _taxiBannerImageList = null;
      BannerModel? bannerModel =
          await bannerServiceInterface.getTaxiBannerList();
      _taxiBannerImageList = [];
      _taxiBannerDataList = [];
      // Safe iterate campaigns list
      final campaigns = bannerModel?.campaigns ?? const [];
      for (final campaign in campaigns) {
        _taxiBannerImageList!.add(campaign.image);
        _taxiBannerDataList!.add(campaign);
      }
      // Safe iterate banners list
      final banners = bannerModel?.banners ?? const [];
      for (final banner in banners) {
        _taxiBannerImageList!.add(banner.image);
        if (banner.item != null) {
          _taxiBannerDataList!.add(banner.item);
        } else if (banner.store != null) {
          _taxiBannerDataList!.add(banner.store);
        } else if (banner.type == 'default') {
          _taxiBannerDataList!.add(banner.link);
        } else {
          _taxiBannerDataList!.add(null);
        }
      }

      // Only duplicate first element if list is not empty
      if (_taxiBannerImageList!.isNotEmpty && _taxiBannerDataList!.isNotEmpty) {
        _taxiBannerImageList!.add(_taxiBannerImageList![0]);
        _taxiBannerDataList!.add(_taxiBannerDataList![0]);
      }
          update();
    }
  }

  Future<void> getParcelOtherBannerList(bool reload) async {
    if (_parcelOtherBannerModel == null || reload) {
      ParcelOtherBannerModel? parcelOtherBannerModel =
          await bannerServiceInterface.getParcelOtherBannerList();
      _parcelOtherBannerModel = parcelOtherBannerModel;
          update();
    }
  }

  Future<void> getPromotionalBannerList(bool reload) async {
    if (_promotionalBanner == null || reload) {
      PromotionalBanner? promotionalBanner =
          await bannerServiceInterface.getPromotionalBannerList();
      _promotionalBanner = promotionalBanner;
          update();
    }
  }

  void setCurrentIndex(int index, bool notify) {
    _currentIndex = index;
    if (notify) {
      update();
    }
  }
}
