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
import 'package:provider/provider.dart';

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

  bool goToPayment = false;
  String addressToBeUsed = "";
  final _addressFormKey = GlobalKey<FormState>();
  final AddressServices addressServices = AddressServices();
  List<String> checkoutSteps = ["Địa chỉ", "Vận chuyển", "Đặt hàng"];

  @override
  void dispose() {
    areaController.dispose();
    cityController.dispose();
    pincodeController.dispose();
    flatBuildingController.dispose();
    super.dispose();
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
        showSnackBar(context: context, text: "Vui lòng nhập đầy đủ thông tin");
      }
    } else if (addressFromProvider.isNotEmpty) {
      addressToBeUsed = addressFromProvider;
      setState(() {
        goToPayment = true;
      });
    } else {
      showSnackBar(context: context, text: "Lỗi trong phần địa chỉ");
    }

    // Lưu địa chỉ nếu người dùng chưa có địa chỉ được lưu
    if (Provider.of<UserProvider>(context, listen: false)
        .user
        .address
        .isEmpty) {
      addressServices.saveUserAddress(
          context: context, address: addressToBeUsed);
    }
  }

  void placeOrder() {
    // Gọi hàm từ AddressServices để lưu đơn hàng xuống database
    addressServices.placeOrder(
      context: context,
      address: addressToBeUsed,
      totalSum: num.parse(widget.totalAmount),
    );

    // Hiển thị thông báo đơn hàng thành công
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Colors.black12, width: 4),
        ),
        title: Image.asset("assets/images/croppedsuccess.gif", height: 150),
        content: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Đặt hàng thành công",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Mã đơn hàng: 1234567890\nThời gian: ${DateTime.now().hour}:${DateTime.now().minute}",
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Sau khi đặt hàng thành công, có thể điều hướng về màn hình chính hoặc trang đơn hàng của người dùng.
            },
            child: const Text("OK"),
          )
        ],
      ),
    );
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
          title: "Đặt hàng",
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * .02),
            child: Column(
              children: [
                // Hiển thị các bước checkout
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
                            color: goToPayment
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
                                side: (i == 0) ||
                                        (goToPayment && i == 1) ||
                                        (goToPayment && i == 2)
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
                // Nếu người dùng đã xác nhận địa chỉ thì hiển thị tóm tắt đơn hàng và nút "Đặt hàng"
                goToPayment
                    ? Column(
                        children: [
                          SizedBox(height: mq.height * .02),
                          Container(
                              alignment: Alignment.centerLeft,
                              child: const Text("Tóm tắt đơn hàng",
                                  style: TextStyle(fontSize: 20))),
                          SizedBox(height: mq.height * .02),
                          ListView.builder(
                            scrollDirection: Axis.vertical,
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: user.cart.length,
                            itemBuilder: (context, index) {
                              return DeliveryProduct(index: index);
                            },
                          ),
                          SizedBox(height: mq.height * .02),
                          CustomButton(
                            text: "Đặt hàng",
                            onTap: () {
                              placeOrder();
                            },
                            color: const Color.fromARGB(255, 108, 255, 255),
                          ),
                        ],
                      )
                    // Nếu chưa chọn địa chỉ, hiển thị form nhập địa chỉ hoặc địa chỉ có sẵn của người dùng
                    : Column(
                        children: [
                          const Text("Chọn địa chỉ giao hàng",
                              style: GlobalVariables.appBarTextStyle),
                          address.isNotEmpty
                              ? Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black12),
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
                                    border: Border.all(color: Colors.black12),
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
                                  hintText: "Tòa nhà, Số nhà",
                                ),
                                SizedBox(height: mq.height * .01),
                                CustomTextField(
                                  controller: areaController,
                                  hintText: "Khu vực, Đường",
                                ),
                                SizedBox(height: mq.height * .01),
                                CustomTextField(
                                  controller: pincodeController,
                                  hintText: "Mã bưu điện",
                                  inputType: TextInputType.number,
                                ),
                                SizedBox(height: mq.height * .01),
                                CustomTextField(
                                  controller: cityController,
                                  hintText: "Thành phố/Tỉnh",
                                ),
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
}
