import 'package:ecommerce_major_project/constants/global_variables.dart';
import 'package:ecommerce_major_project/features/home/widgets/carousel_image.dart';
import 'package:ecommerce_major_project/features/home/widgets/deal_of_day.dart';
import 'package:ecommerce_major_project/features/home/widgets/top_categories.dart';
import 'package:ecommerce_major_project/features/search_delegate/my_search_screen.dart';
import 'package:ecommerce_major_project/main.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: GlobalVariables.getAppBar(
            context: context,
            wantBackNavigation: false,
            onClickSearchNavigateTo: MySearchScreen()),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: mq.width * .02),
              const CarouselImage(),
              SizedBox(height: mq.width * .01),
              const TopCategories(),
              const DealOfDay(),
            ],
          ),
        ),
      ),
    );
  }
}
