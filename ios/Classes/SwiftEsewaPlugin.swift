import Flutter
import UIKit
import EsewaSDK

public class SwiftEsewaPlugin: NSObject, FlutterPlugin, EsewaSDKPaymentDelegate {

    var result: FlutterResult?
    var sdk: EsewaSDK?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "esewa_plugin", binaryMessenger: registrar.messenger())
    let instance = SwiftEsewaPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if call.method == "payWithEsewa" {
        let arguments = call.arguments
        let merchantInfo = arguments[0] as [Any:Any]
        let paymentInfo = arguments[1] as [Any:Any]

        // merchant/client detail
        let clientId = merchantInfo["clientId"] as String
        let clientSecretKey = merchantInfo["clientSecret"] as String

        // app environment and callback url
        let callbackUrl = merchantInfo["callbackUrl"] as String
        let appEnvironment = (merchantInfo["environment"] as String) == "live" ? EsewaSDKEnvironment.production : EsewaSDKEnvironment.development
        
        // payment detail
        let amount = paymentInfo["amount"] as String
        let productName = paymentInfo["productName"] as String
        let referenceId = paymentInfo["referenceId"] as String

        sdk = EsewaSDK(inViewController: self, environment: appEnvironment, delegate: self)

        sdk?.initiatePayment(merchantId: clientId, merchantSecret: clientSecret, productName: productName, productAmount: productAmount, productId: productId, callbackUrl: referenceId)
    }
  }

  func onEsewaSDKPaymentSuccess(info:[String:Any]) {
      // Called when the payment is success. Info contains the detail of transaction.
      self.result(info)
  }

  func onEsewaSDKPaymentError(errorDescription: String) {
      // Called when there is error with the description of the error.
      self.result(errorDescription)
  }
}
