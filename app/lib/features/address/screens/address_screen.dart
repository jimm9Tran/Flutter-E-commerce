import 'package:ecommerce_major_project/common/widgets/custom_button.dart';
import 'package:ecommerce_major_project/common/widgets/custom_textfield.dart';
import 'package:ecommerce_major_project/constants/global_variables.dart';
import 'package:ecommerce_major_project/constants/utils.dart';
import 'package:ecommerce_major_project/features/address/services/address_services.dart';
import 'package:ecommerce_major_project/features/address/widgets/delivery_product.dart';
import 'package:ecommerce_major_project/features/search_delegate/my_search_screen.dart';
import 'package:ecommerce_major_project/main.dart';
import 'package:ecommerce_major_project/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:pay/pay.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class AddressScreen extends StatefulWidget {
  static const String routeName = '/address';
  final String totalAmount;

  const AddressScreen({super.key, required this.totalAmount});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  TextEditingController areaController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController flatBuildingController = TextEditingController();

  int totalAmount = 0;
  int currentStep = 0;
  bool goToPayment = false;
  String addressToBeUsed = "";
  final _razorpay = Razorpay();
  bool goToFinalPayment = false;
  List<PaymentItem> paymentItems = [];
  final _addressFormKey = GlobalKey<FormState>();
  final AddressServices addressServices = AddressServices();
  List<String> checkoutSteps = ["Địa chỉ", "Vận chuyển", "Thanh toán"];

  late final Future<PaymentConfiguration> _googlePayConfigFuture;

  @override
  void initState() {
    super.initState();
    _googlePayConfigFuture =
        PaymentConfiguration.fromAsset("google_pay_config.json");
    paymentItems.add(
      PaymentItem(
        label: 'Tổng tiền',
        amount: widget.totalAmount,
        status: PaymentItemStatus.final_price,
      ),
    );

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    totalAmount = double.parse(widget.totalAmount).toInt();
  }

  @override
  void dispose() {
    areaController.dispose();
    cityController.dispose();
    pincodeController.dispose();
    flatBuildingController.dispose();
    super.dispose();
  }

  void onGooglePayResult(paymentResult) {
    if (Provider.of<UserProvider>(context, listen: false)
        .user
        .address
        .isEmpty) {
      addressServices.saveUserAddress(
          context: context, address: addressToBeUsed);
    }

    addressServices.placeOrder(
        context: context,
        address: addressToBeUsed,
        totalSum: num.parse(widget.totalAmount));
  }

  void payPressed(String addressFromProvider) {
    addressServices.placeOrder(
        context: context,
        address: addressToBeUsed,
        totalSum: num.parse(widget.totalAmount));
  }

  void deliverToThisAddress(String addressFromProvider) {
    addressToBeUsed = "";

    bool isFormValid = flatBuildingController.text.isNotEmpty ||
        areaController.text.isNotEmpty ||
        pincodeController.text.isNotEmpty ||
        cityController.text.isNotEmpty;

    if (isFormValid) {
      if (_addressFormKey.currentState!.validate()) {
        addressToBeUsed =
            "${flatBuildingController.text}, ${areaController.text}, ${cityController.text} - ${pincodeController.text}";
        setState(() {
          goToPayment = true;
        });
      } else {
        throw Exception("Vui lòng nhập đầy đủ thông tin");
      }
    } else if (addressFromProvider.isNotEmpty) {
      addressToBeUsed = addressFromProvider;
      setState(() {
        goToPayment = true;
      });
    } else {
      showSnackBar(context: context, text: "Lỗi trong phần địa chỉ");
    }

    if (Provider.of<UserProvider>(context, listen: false)
        .user
        .address
        .isEmpty) {
      addressServices.saveUserAddress(
          context: context, address: addressToBeUsed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    var address = user.address;

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: GlobalVariables.getAppBar(
          context: context,
          onClickSearchNavigateTo: MySearchScreen(),
          title: "Thanh toán",
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * .02),
            child: Column(
              children: [
                SizedBox(
                  width: mq.width * .8,
                  height: mq.height * .06,
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: mq.height * .004,
                            width: mq.width * .3,
                            color: goToPayment
                                ? Colors.black
                                : Colors.grey.shade400,
                          ),
                          Container(
                            height: mq.height * .004,
                            width: mq.width * .3,
                            color: goToFinalPayment
                                ? Colors.black
                                : Colors.grey.shade400,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          for (int i = 0; i < 3; i++)
                            Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side: i == 0
                                    ? const BorderSide(width: 1.5)
                                    : goToPayment && i == 1
                                        ? const BorderSide(width: 1.5)
                                        : goToFinalPayment && i == 2
                                            ? const BorderSide(width: 1.5)
                                            : BorderSide.none,
                              ),
                              child: Container(
                                padding: EdgeInsets.all(mq.height * .01),
                                alignment: Alignment.center,
                                child: Text(checkoutSteps[i]),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                goToPayment
                    ? Column(
                        children: [
                          SizedBox(height: mq.height * .02),
                          Container(
                              alignment: Alignment.centerLeft,
                              child: const Text("Tóm tắt đơn hàng",
                                  style: TextStyle(fontSize: 20))),
                          SizedBox(height: mq.height * .02),
                          SizedBox(
                            child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                physics: BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: user.cart.length,
                                itemBuilder: (context, index) {
                                  return DeliveryProduct(index: index);
                                }),
                          ),
                          SizedBox(height: mq.height * .02),
                          CustomButton(
                              text: "Thanh toán ngay",
                              onTap: () {
                                setState(() {
                                  goToFinalPayment = true;
                                });
                                var options = {
                                  'key': 'rzp_test_7NBmERXaABkUpY',
                                  'amount': 100 * totalAmount,
                                  'name': 'AKR Company',
                                  'description': 'Hóa đơn Ecommerce',
                                  'prefill': {
                                    'contact': '8888888888',
                                    'email': 'test@razorpay.com'
                                  }
                                };

                                try {
                                  _razorpay.open(options);
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Lỗi : $e")));
                                }
                              },
                              color: const Color.fromARGB(255, 108, 255, 255)),
                        ],
                      )
                    : Column(
                        children: [
                          const Text("Chọn địa chỉ giao hàng",
                              style: GlobalVariables.appBarTextStyle),
                          address.isNotEmpty
                              ? Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black12,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(mq.width * .025),
                                    child: Text(
                                      "Giao đến : $address",
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ),
                                )
                              : Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black12,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(mq.width * .025),
                                    child: const Text(
                                      "Giao đến : ",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                          SizedBox(height: mq.height * .025),
                          address.isNotEmpty
                              ? const Text(
                                  "HOẶC",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13),
                                )
                              : const Text("Vui lòng thêm địa chỉ trước",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13)),
                          SizedBox(height: mq.height * .025),
                          Form(
                            key: _addressFormKey,
                            child: Column(
                              children: [
                                CustomTextField(
                                    controller: flatBuildingController,
                                    hintText: "Tòa nhà, Số nhà"),
                                SizedBox(height: mq.height * .01),
                                CustomTextField(
                                    controller: areaController,
                                    hintText: "Khu vực, Đường"),
                                SizedBox(height: mq.height * .01),
                                CustomTextField(
                                    controller: pincodeController,
                                    hintText: "Mã bưu điện",
                                    inputType: TextInputType.number),
                                SizedBox(height: mq.height * .01),
                                CustomTextField(
                                    controller: cityController,
                                    hintText: "Thành phố/Tỉnh"),
                                SizedBox(height: mq.height * .04),
                                CustomButton(
                                  text: "Giao đến địa chỉ này",
                                  onTap: () {
                                    deliverToThisAddress(address);
                                  },
                                  color: Colors.amber[400],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print(
        "\n\nThanh toán thành công : \n\nMã thanh toán :  ${response.paymentId} \n\n Mã đơn hàng : ${response.orderId} \n\n Chữ ký : ${response.signature}");

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Thành công"),
        content: Text(
            "Mã thanh toán : ${response.paymentId}\nMã đơn hàng : ${response.orderId}\nChữ ký : ${response.signature}"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print(
        "Lỗi thanh toán ==> Mã lỗi : ${response.code} \nThông báo : ${response.message}  ");
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Oops, có lỗi xảy ra"),
        content: Text(
            "Lỗi thanh toán ==> Mã lỗi : ${response.code} \nThông báo : ${response.message}"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("Ví ngoài : ${response.walletName}");

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Ví ngoài"),
        content: Text("Ví ngoài : ${response.walletName}"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("OK"),
          )
        ],
      ),
    );
  }
}
