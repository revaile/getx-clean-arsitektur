import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'core/network/api_client.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<http.Client>(() => http.Client(), fenix: true);
    Get.lazyPut<ApiClient>(
      () => ApiClient(client: Get.find<http.Client>()),
      fenix: true,
    );
  }
}
