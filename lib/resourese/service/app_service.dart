import 'package:somics_os/resourese/auth/auth_repository.dart';
import 'package:somics_os/resourese/auth/iauth_repository.dart';
import 'package:get/get.dart';

class AppService {
  static Future<void> initAppService() async {
    Get.put<IAuthRepository>(AuthRepository());
  }
}
