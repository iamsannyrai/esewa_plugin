import 'package:flutter/material.dart';

@immutable
class MerchantInfo {
  /// Client Id of the client/merchant
  final String clientId;

  /// Secret key of the client/merchant
  final String clientSecret;

  /// API exposed at merchant/client`server where eSewa sends
  /// a copy of proof of payment after successful payment
  final String callbackUrl;

  const MerchantInfo({
    @required this.clientId,
    @required this.clientSecret,
    @required this.callbackUrl,
  });

  @override
  String toString() {
    return "MerchantInfo(clientId: $clientId, clientSecret: $clientSecret, callbackUrl: $callbackUrl)";
  }
}
