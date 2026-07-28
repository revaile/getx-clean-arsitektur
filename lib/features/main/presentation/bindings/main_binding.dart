import 'package:get/get.dart';

import '../../../posts/presentation/bindings/posts_binding.dart';
import '../../../todos/presentation/bindings/todos_bindings.dart';
import '../../../users/presentation/bindings/users_binding.dart';
import '../controllers/main_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(MainController.new);

    UsersBinding().dependencies();
    PostsBinding().dependencies();
    TodosBinding().dependencies();
  }
}
