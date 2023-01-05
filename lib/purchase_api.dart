import 'dart:core';
import 'dart:io';
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchaseApi {
  // static const _apiKeyApple = 'appl_RkKCvYPRjmfomPPpMxizUTNDtWh';
  static const _apiKeyGoogle = 'goog_TdSxvDRwPARfGFUNbMRFcmVcXuR';
  static Future init() async {
    await Purchases.setDebugLogsEnabled(true);
    await Purchases.configure(PurchasesConfiguration(_apiKeyGoogle));
  }

  static Future<bool> purchasePackage(Package package) async {
    try {
      await Purchases.purchasePackage(package);
      return true;
    } catch (e) {
      return false;
    }
  }
}
