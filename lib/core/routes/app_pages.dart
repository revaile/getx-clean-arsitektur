import 'package:get/get.dart';

import '../../features/main/presentation/bindings/main_binding.dart';
import '../../features/main/presentation/pages/main_page.dart';
import '../../features/posts/presentation/bindings/posts_binding.dart';
import '../../features/posts/presentation/pages/posts_page.dart';
import '../../features/users/presentation/bindings/users_binding.dart';
import '../../features/users/presentation/pages/users_page.dart';
import 'app_routes.dart';

class AppPages {
  const AppPages._();

  static final pages = <GetPage<dynamic>>[
    GetPage(
      name: AppRoutes.main,
      page: () => const MainPage(),
      binding: MainBinding(),
    ),
    GetPage(
      name: AppRoutes.users,
      page: () => const UsersPage(),
      binding: UsersBinding(),
    ),
    GetPage(
      name: AppRoutes.posts,
      page: () => const PostsPage(),
      binding: PostsBinding(),
    ),
  ];
}
