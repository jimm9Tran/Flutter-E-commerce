part of 'router.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: rootNavigatorKey,
  debugLogDiagnostics: true,
  initialLocation: '/',
  routes: [
    GoRoute(
        path: '/',
        redirect: (context, state) {
          final cacheHelper = sl<CacheHelper>()
            ..getSesstionToken()
            ..getUserId();
          if ((Cache.instance.sessionToken == null ||
                  Cache.instance.userId == null) &&
              !cacheHelper.isFirstTime()) {
            return LoginScreen.path;
          }

          if (state.extra == 'home') {
            return HomeView.path;
          }
          return null;
        },
        builder: (_, __) {
          final cacheHelper = sl<CacheHelper>()
            ..getSesstionToken()
            ..getUserId();
          if (cacheHelper.isFirstTime()) {
            return const OnBoardingScreen();
          }
          return const SplashScreen();
        }),
    GoRoute(path: LoginScreen.path, builder: (_, __) => const LoginScreen()),
    ShellRoute(
        builder: (context, state, child) {
          return DashboardScreen(
            state: state,
            child: child,
          );
        },
        routes: [
          GoRoute(path: HomeView.path, builder: (_, __) => const HomeView())
        ])
  ],
);
