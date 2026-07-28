import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../posts/presentation/pages/posts_page.dart';
import '../../../todos/presentation/pages/todos_page.dart';
import '../../../users/presentation/pages/users_page.dart';
import '../controllers/main_controller.dart';

class MainPage extends GetView<MainController> {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: IndexedStack(
          index: controller.selectedIndex.value,
          children: const [
            UsersPage(),
            PostsPage(),
            TodosPage(),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: controller.changeTab,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.people_outline),
              selectedIcon: Icon(Icons.people),
              label: 'Users',
            ),
            NavigationDestination(
              icon: Icon(Icons.article_outlined),
              selectedIcon: Icon(Icons.article),
              label: 'Posts',
            ),
            NavigationDestination(
              icon: Icon(Icons.check_circle_outline),
              selectedIcon: Icon(Icons.check_circle),
              label: 'Todos',
            ),
          ],
        ),
      ),
    );
  }
}
