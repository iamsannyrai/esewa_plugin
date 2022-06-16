import Flutter
import UIKit
import EsewaSDK

public class SwiftEsewaPlugin: NSObject, FlutterPlugin, EsewaSDKPaymentDelegate {

    var result: FlutterResult?
    var sdk: EsewaSDK?
    public var viewController: UIViewController
    public var channel:FlutterMethodChannel
    
    public init(viewController:UIViewController, channel:FlutterMethodChannel) {
           self.viewController = viewController
           self.channel = channel
       }

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "esewa_plugin", binaryMessenger: registrar.messenger())
    let viewController: UIViewController =
            (UIApplication.shared.delegate?.window??.rootViewController)!;
    let instance = SwiftEsewaPlugin(viewController: viewController, channel: channel)
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {

     if call.method == "payWithEsewa" {
        
         guard let arguments = call.arguments as? [Any] else {
            return
         }
         let merchantInfo = arguments[0] as? [String:Any]
         let paymentInfo = arguments[1] as? [String:Any]

         // merchant/client detail
        let clientId = merchantInfo?["clientId"] as? String
        let clientSecretKey = merchantInfo?["clientSecret"] as? String

         // app environment and callback url
         let callbackUrl = merchantInfo?["callbackUrl"] as? String
         let appEnvironment = (merchantInfo?["environment"] as? String) == "live" ? EsewaSDKEnvironment.production : EsewaSDKEnvironment.development

         // payment detail
         let amount = paymentInfo?["amount"] as? String
         let productName = paymentInfo?["productName"] as? String
         let referenceId = paymentInfo?["referenceId"] as? String

         sdk = EsewaSDK(inViewController: viewController, environment: appEnvironment, delegate: self)

        sdk?.initiatePayment(merchantId: clientId!, merchantSecret: clientSecretKey!, productName: productName!, productAmount: amount!, productId: referenceId!, callbackUrl: callbackUrl!)
     }
  }

    public func onEsewaSDKPaymentSuccess(info:[String:Any]) {
      // Called when the payment is success. Info contains the detail of transaction.
//       self.result(info)

        self.channel.invokeMethod("onSuccess", arguments: info)
  }

    public func onEsewaSDKPaymentError(errorDescription: String) {
      // Called when there is error with the description of the error.
//       self.result(errorDescription)
         if (errorDescription=="Payment process is cancelled by user.") {
            channel.invokeMethod("onCancel", arguments: errorDescription)
         }else {
            channel.invokeMethod("onError", arguments: errorDescription)
         }
  }
}
