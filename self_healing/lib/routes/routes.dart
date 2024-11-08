import 'package:flutter/material.dart';
import 'package:self_healing/pages/guide/guide1_page.dart';
import 'package:self_healing/pages/guide/guide2_page.dart';
import 'package:self_healing/pages/guide/guide_page.dart';
import 'package:self_healing/pages/index/index_page.dart';
import 'package:self_healing/pages/mindfulness/pages/create/media_create_page.dart';
import 'package:self_healing/pages/mindfulness/pages/details/media_details_page.dart';
import 'package:self_healing/pages/mindfulness/pages/shop/media_shop_page.dart';

class Routes {
  static Routes? _shared;
  static Routes get shared {
    _shared ??= Routes._internal();
    return _shared!;
  }

  Routes._internal();

  static String guide = "guide";
  static String guide1 = "guide1";
  static String guide2 = "guide2";
  static String index = "index";
  static String mindfulnessShop = "mindfulnessShop";
  static String mindfulnessDetails = "mindfulnessDetails";
  static String mindfulnessCreate = "mindfulnessCreate";

  Map<String, WidgetBuilder> pages() {
    return {
      // 引导页面
      guide: (context) => (GuidePage()),
      // 引导页面1
      guide1: (context) => (Guide1Page()),
      // 引导页面2
      guide2: (context) => (Guide2Page()),
      // 首页
      index: (context) => (IndexPage()),
      // 商场
      mindfulnessShop: (context) => (MediaShopPage()),
      // 详情
      mindfulnessDetails: (context) => (MediaDetailsPage()),
      // 创建
      mindfulnessCreate: (context) => (MediaCreatePage()),
      
    };
  }
}
