
import 'esewa_enum.dart';
import 'merchant_info.dart';
import 'payment_response.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class Esewa {
  static const MethodChannel _channel = const MethodChannel('esewa_plugin');

  /// Price of Product or Service
  final String _price;

  /// Name of Product or Service
  final String _productName;

  /// Unique Id for particular product or services
  final String _referenceId;

  /// Instance of MerchantInfo
  final MerchantInfo _merchantInfo;

  /// Environment integrating for i.e. LIVE (live) or DEVELOPMENT (test)
  final EsewaEnvironment _environment;

  const Esewa(
      {@required String price,
      @required String productName,
      @required String referenceId,
      @required MerchantInfo merchantInfo,
      EsewaEnvironment environment: EsewaEnvironment.test})
      : assert(price != null),
        assert(productName != null),
        assert(referenceId != null),
        assert(merchantInfo != null),
        assert(environment != null),
        _price = price,
        _productName = productName,
        _referenceId = referenceId,
        _merchantInfo = merchantInfo,
        _environment = environment;

  void makePayment(
      {@required Function(PaymentResponse) onSuccess,
      @required Function(String) onError,
      @required Function(String) onCancelled}) {
    try {
      Map<String, String> merchantInfo = {
        "clientId": _merchantInfo.clientId,
        "clientSecret": _merchantInfo.clientSecret,
        "callbackUrl": _merchantInfo.callbackUrl,
        "environment": describeEnum(_environment),
      };

      Map<String, dynamic> paymentInfo = {
        "amount": _price,
        "productName": _productName,
        "referenceId": _referenceId,
      };

      _channel.invokeMethod('payWithEsewa', [merchantInfo, paymentInfo]);

      _channel.setMethodCallHandler((call) async {
        switch (call.method) {
          case "onSuccess":
            PaymentResponse paymentResponse = PaymentResponse.fromJson(
                Map<String, dynamic>.from(call.arguments));
            onSuccess(paymentResponse);
            break;
          case "onError":
            onError(call.arguments);
            break;
          case "onCancel":
            onCancelled(call.arguments);
            break;
        }
      });
    } catch (e) {
      throw e;
    }
  }
}
