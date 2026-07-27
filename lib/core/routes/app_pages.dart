import 'package:get/get.dart';

import '../../features/users/presentation/bindings/users_binding.dart';
import '../../features/users/presentation/pages/users_page.dart';
import 'app_routes.dart';

class AppPages {
  const AppPages._();

  static final pages = <GetPage<dynamic>>[
    GetPage(
      name: AppRoutes.users,
      page: () => const UsersPage(),
      binding: UsersBinding(),
    ),
  ];
}
