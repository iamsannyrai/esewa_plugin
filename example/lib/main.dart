import 'package:esewa_plugin/esewa_plugin.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Esewa _esewa;
  MerchantInfo _merchantInfo;

  @override
  void initState() {
    super.initState();
    _merchantInfo = MerchantInfo(
      clientId: "JB0BBQ4aD0UqIThFJwAKBgAXEUkEGQUBBAwdOgABHD4DChwUAB0R",
      clientSecret: "BhwIWQQADhIYSxILExMcAgFXFhcOBwAKBgAXEQ==",
      callbackUrl: "",
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              _esewa = Esewa(
                price: '10.0',
                productName: 'Monitor',
                referenceId: '1625497530',
                merchantInfo: _merchantInfo,
              );

              _esewa.makePayment(
                onSuccess: (successResponse) {
                  print("success: $successResponse");
                },
                onError: (errorResponse) {
                  print("error: $errorResponse");
                },
                onCancelled: (cancelledResponse) {
                  print("cancelled: $cancelledResponse");
                },
              );
            },
            child: Text('Pay with Esewa'),
          ),
        ),
      ),
    );
  }
}
