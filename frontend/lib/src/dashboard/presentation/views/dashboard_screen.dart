import 'package:flutter/material.dart';
import 'package:frontend/src/dashboard/utils/dashboard_utils.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, required this.state, required this.child});
  final GoRouterState state;
  final Widget child;
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: DashboardUtils.scaffoldKey,
      body: const Scaffold(
        body: Center(
          child: Text("Dashboard Screen"),
        ),
      ),
    );
  }
}
