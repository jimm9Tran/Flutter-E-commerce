import 'package:ecommerce_major_project/common/widgets/color_loader_2.dart';
import 'package:ecommerce_major_project/constants/global_variables.dart';
import 'package:ecommerce_major_project/features/account/services/account_services.dart';
import 'package:ecommerce_major_project/features/admin/models/sales.dart';
import 'package:ecommerce_major_project/features/admin/services/admin_services.dart';
import 'package:ecommerce_major_project/features/admin/widgets/sales_graph/sales_graph.dart';
import 'package:ecommerce_major_project/main.dart';
import 'package:flutter/material.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final AdminServices adminServices = AdminServices();
  num? totalSales;
  List<Sales>? earnings;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    getEarnings();
  }

  getEarnings() async {
    var earningData = await adminServices.getEarnings(context);
    totalSales = earningData['totalEarnings'];
    earnings = earningData['sales'];
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  List<double> weeklySummary = [4.4, 5.05, 50.3, 99.9, 0, 78.98, 10.75];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalVariables.getAdminAppBar(
        title: "Phân tích",
        context: context,
      ),
      body: isLoading
          ? const Center(child: ColorLoader2())
          : earnings == null || totalSales == null
              ?
              // Nếu không có dữ liệu doanh thu
              Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/no-orderss.png",
                        height: mq.height * .25,
                      ),
                      const Text(
                        "Không có dữ liệu doanh thu",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                )
              :
              // Nếu có dữ liệu doanh thu -> hiển thị biểu đồ cột
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: mq.width * .04),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Text("Tổng doanh thu đạt được: $totalSalesđ",
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w100)),
                      const SizedBox(height: 80),
                      SizedBox(
                          height: 300,
                          child: SalesGraph(
                              salesSummary: earnings!
                                  .map((data) => data.earning)
                                  .toList())),
                      const SizedBox(height: 20),
                      for (int index = 0; index < 5; index++)
                        Text(
                          "${earnings![index].label} : ${earnings![index].earning}đ",
                          textAlign: TextAlign.left,
                        ),
                    ],
                  ),
                ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 10,
        icon: Icon(Icons.logout_outlined, color: Colors.white),
        onPressed: () {
          AccountServices().logOut(context);
        },
        backgroundColor: Colors.deepPurple.shade600,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        label: Text("Đăng xuất",
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ),
    );
  }
}
