import 'package:flutter/material.dart';
import 'package:mall/model/serviceModel.dart';
import 'package:mall/screens/customer/booking/parlor/parlor_bookings.dart';
import 'package:mall/screens/customer/shopping/my_orders.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../constant/utils/utilities.dart';
import '../../controller/auth.dart';
import 'booking/parlor/confirm_booking.dart';

class Payment extends StatefulWidget {
  final double amount;
  String? sellerId;
  List? sellerIds;
  String? productId;
  List? productIds;
  Map<String, List<String>>? map;
  String? shopId;
  String? shopName;
  DateTime? date;
  String? time;
 ServiceModel? serviceModel;
  bool isAppointment;
  String? mode;
  Payment(
      {super.key,
      required this.amount,
      this.sellerIds,
      this.productId,
      this.productIds,
      this.map,
      this.isAppointment = false,
      this.shopId,
      this.shopName,
      this.date,
      this.time,
      this.serviceModel,
      this.sellerId,this.mode});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  var _razorPay = Razorpay();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _razorPay.clear();
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    if (widget.isAppointment) {
      final dateTime = DateTime.now().millisecondsSinceEpoch.toString();
      await Auth.customerRef
          .doc(Auth.auth.currentUser!.uid)
          .collection('bookings')
          .doc(widget.shopId)
          .set({'shopId': widget.shopId, 'shopName': widget.shopName});
      await Auth.customerRef
          .doc(Auth.auth.currentUser!.uid)
          .collection('bookings')
          .doc(widget.shopId)
          .collection('parlor')
          .doc(dateTime)
          .set({
        'bookingId': dateTime,
        'date': "${widget.date}".toString(),
        'time': "${widget.time}".toString(),
        'customerId': Auth.auth.currentUser!.uid,
        'shopId': widget.shopId,
        'serviceName': widget.serviceModel!.serviceName,
        'serviceId': widget.serviceModel!.serviceId,
        'amount': widget.amount,
        'shopName': widget.shopName,
        'cancelled':false
      }).then((value) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ConfirmBooking(
                      shopId: widget.shopId,
                      bookingId: dateTime,
                  serviceModel: widget.serviceModel,
                  date: widget.date,
                  time: widget.time,
                    )));
      });
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('Error ${response.message}');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
    print('Wallet ${response.walletName}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
        centerTitle: true,
      ),
      body: Center(
        child: InkWell(
          onTap: () {
            var options = {
              'key': 'rzp_test_hsfoAtMk3TFoZA',
              'amount': (widget.amount * 100).round(),
              'name': 'ClosetHunt',
              'description': 'Fine T-Shirt',
              'timeout': 120,
            };
            try {
              _razorPay.open(options);
            } on Exception catch (e) {
              Utilities().showMessage(e.toString());
            }
          },
          child: Container(
            width: 100,
            height: 40,
            child:
                Center(child: Text('Pay ${widget.amount.toStringAsFixed(2)}')),
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
    );
  }
}

//test id rzp_test_hsfoAtMk3TFoZA
//key secret 3rBl4t7gsIKp0ZDp68JTx40M
