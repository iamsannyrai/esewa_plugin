import 'esewa_enum.dart';
import 'merchant_info.dart';
import 'payment_response.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class Esewa {
  static const MethodChannel _channel = const MethodChannel('esewa_plugin');

  /// Price of Product or Service
  final String price;

  /// Name of Product or Service
  final String productName;

  /// Unique Id for particular product or services
  final String referenceId;

  /// Instance of MerchantInfo
  final MerchantInfo merchantInfo;

  /// Environment integrating for i.e. LIVE (live) or DEVELOPMENT (test)
  EsewaEnvironment environment;

  Esewa(
      {this.price,
      this.productName,
      this.referenceId,
      this.merchantInfo,
      this.environment: EsewaEnvironment.test})
      : assert(price != null),
        assert(productName != null),
        assert(referenceId != null),
        assert(merchantInfo != null),
        assert(environment != null);

  void makePayment(
      {@required Function(PaymentResponse) onSuccess,
      @required Function(String) onError,
      @required Function(String) onCancelled}) {
    try {
      final Map<String, String> _merchantInfo = {
        "clientId": merchantInfo.clientId,
        "clientSecret": merchantInfo.clientSecret,
        "callbackUrl": merchantInfo.callbackUrl,
        "environment": describeEnum(environment),
      };

      final Map<String, dynamic> _paymentInfo = {
        "amount": price,
        "productName": productName,
        "referenceId": referenceId,
      };

      _channel.invokeMethod('payWithEsewa', [_merchantInfo, _paymentInfo]);

      _channel.setMethodCallHandler(
        (call) async {
          switch (call.method) {
            case "onSuccess":
              PaymentResponse paymentResponse = PaymentResponse.fromJson(
                Map<String, dynamic>.from(call.arguments),
              );
              onSuccess(paymentResponse);
              break;
            case "onError":
              onError(call.arguments);
              break;
            case "onCancel":
              onCancelled(call.arguments);
              break;
          }
        },
      );
    } catch (e) {
      throw e;
    }
  }
}
