import 'package:ecommerce_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayPayment extends StatefulWidget {
  final paymentPrice;
  const RazorpayPayment({super.key, required this.paymentPrice});

  @override
  State<RazorpayPayment> createState() => _RazorpayPaymentState();
}

class _RazorpayPaymentState extends State<RazorpayPayment> {
  @override
  late Razorpay _razorpay;
  TextEditingController amountController = TextEditingController();
  void openCheckout(amount) async {
    amount = amount * 100;
    var option = {
      'key': 'rzp_test_1DP5mmOlF5G5ag',
      'amount': amount,
      'name': 'Testing RazorPay',
      'description': 'Fine T-Shirt',
      'prefill': {'contact': '1234567890', 'email': 'dreammy827@gmail.com'},
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      _razorpay.open(option);
    } catch (e) {
      debugPrint("Error +::=> $e");
    }
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    debugPrint("Payment Success");
    Utils.toastSuccessMessage("payment succesful ${response.paymentId}");
  }

  void handlePaymentError(PaymentFailureResponse response) {
    debugPrint("Payment Success");
    Utils.toastErrorMessage("payment failed ${response.message}");
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    debugPrint("Payment Success");
    Utils.toastSuccessMessage("External Wallet ${response.walletName}");
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  void initState() {
    super.initState();
    amountController.text = widget.paymentPrice.toString();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            Image.network(
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSEzHTRfO-BS6NfMWXr8zbb3d-pcOCPNgJX9A&s",
                height: 100,
                width: 300),
            const SizedBox(
              height: 10,
            ),
            const Text(
              textAlign: TextAlign.center,
              "Welcomr to Razorpay Payment Gateway",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(
              height: 40,
            ),
            Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                    controller: amountController,
                    validator: (v) {
                      if (v!.isEmpty) {
                        return "Amount is required";
                      }
                      return null;
                    },
                    autofocus: false,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Enter Amount",
                      hintStyle: const TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              width: 1.0, color: Colors.white)),
                      errorStyle:
                          TextStyle(color: Colors.redAccent, fontSize: 15),
                    ))),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                if (amountController.text.isEmpty) {
                  Utils.toastErrorMessage("Amount is required");
                  setState(() {
                    int amount = int.parse(amountController.text.toString());
                    if (amount < 1) {
                      Utils.toastErrorMessage("Amount must be greater than 0");
                      return;
                    } else {
                      openCheckout(amount.toDouble());
                    }
                  });
                } else {
                  openCheckout(double.parse(amountController.text));
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Text("Pay Now"),
              ),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
