import 'package:get/get.dart';
import 'package:somics_os/ui/pages/home_page.dart';

part 'routes.dart';

abstract final class AppPages {
  static final pages = [
    GetPage<void>(name: Routes.HOME, page: () => const HomePage()),
  ];
}
