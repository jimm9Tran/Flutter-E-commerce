import 'package:frontend/core/common/app/cache_helper.dart';
import 'package:frontend/core/services/injection_container.dart';
import 'package:frontend/core/services/router.dart';
import 'package:http/http.dart';
import 'package:go_router/go_router.dart';

abstract class NetworkUtils {
  const NetworkUtils();

  static Future<void> renewToken(Response response) async {
    if (response.headers['authorization'] != null) {
      var token = response.headers['authorization'] as String;
      if (token.startsWith('Bearer ')) {
        token = token.replaceFirst('Bearer', "").trim();
      }
      await sl<CacheHelper>().cacheSesstionToken(token);
    } else if (response.statusCode == 401) {
      rootNavigatorKey.currentContext?.go('/');
    }
  }
}
