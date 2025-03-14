import 'package:flutter/material.dart';
import 'package:frontend/core/common/app/cache_helper.dart';
import 'package:frontend/core/common/widgets/ecomly_logo.dart';
import 'package:frontend/core/res/styles/colours.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/services/injection_container.dart';

import 'package:frontend/core/utils/core_utils.dart';
import 'package:frontend/src/auth/presentation/app/adapter/auth_adapter.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authAdapterProvider().notifier).verifyToken();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authAdapterProvider(), (previous, next) async {
      if (next is TokenVerified) {
        if (next.isValid) {
          // ref.read(provider)
        } else {
          await sl<CacheHelper>().resetSesstion();
          CoreUtils.postFrameCall(() => context.go('/'));
        }
      } else if (next is AuthError) {
        if (next.message.startsWith('401')) {
          await sl<CacheHelper>().resetSesstion();
          CoreUtils.postFrameCall(() => context.go('/'));
          return;
        }
      }
    });
    return const Scaffold(
      backgroundColor: Colours.lightThemePrimaryColour,
      body: Center(child: EcomlyLogo()),
    );
  }
}
