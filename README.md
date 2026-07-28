# GetX Clean Architecture Boilerplate

Boilerplate Flutter untuk struktur clean architecture dengan GetX, memakai endpoint contoh GoREST.

```text
GET https://gorest.co.in/public/v2/users
Accept: application/json
Authorization: Bearer <GOREST_TOKEN>
```

Token tidak disimpan di source code. Untuk request yang butuh auth, jalankan app dengan:

```bash
flutter run --dart-define=GOREST_TOKEN=your_token_here
```

Endpoint list users GoREST tetap bisa dicoba tanpa token.

## Endpoint CRUD Users

```text
GET    /users
GET    /users/{id}
POST   /users
PUT    /users/{id}
DELETE /users/{id}
```

Contoh body create/update:

```json
{
  "name": "Tenali Ramakrishna",
  "email": "tenali@example.com",
  "gender": "male",
  "status": "active"
}
```

## Struktur Folder

```text
lib/
|-- app.dart
|-- initial_binding.dart
|-- main.dart
|-- core/
|   |-- constants/
|   |   `-- api_constants.dart
|   |-- errors/
|   |   |-- exceptions.dart
|   |   `-- failures.dart
|   |-- network/
|   |   |-- api_client.dart
|   |   `-- network_info.dart
|   |-- routes/
|   |   |-- app_pages.dart
|   |   `-- app_routes.dart
|   `-- utils/
|       `-- app_result.dart
`-- features/
    |-- users/
    |   |-- data/
    |   |   |-- datasources/
    |   |   |-- models/
    |   |   `-- repositories/
    |   |-- domain/
    |   |   |-- entities/
    |   |   |-- repositories/
    |   |   `-- usecases/
    |   `-- presentation/
    |       |-- bindings/
    |       |-- controllers/
    |       |-- pages/
    |       `-- widgets/
    |-- posts/
    |   |-- data/
    |   |-- domain/
    |   `-- presentation/
    `-- todos/
        |-- data/
        |-- domain/
        `-- presentation/
```

## Contoh get list

```text
GET https://gorest.co.in/public/v2/posts
[
  {
    "id": 286459,
    "user_id": 8558935,
    "title": "Bos adopto tenetur rerum sit campana mollitia.",
    "body": "Caste ulterius conitor. Adulescens voluptas demens. Temeritas ceno nesciunt. Utroque sufficio timidus. Adipiscor adficio thalassinus. Ciminatio cavus conscendo. Solus quod suscipio. Dignissimos vado argumentum. Absque cognatus explicabo. Audentia barba sophismata. Accommodo sto ultra. Depono abeo caute. Pel sit sufficio. Confero pecto paulatim. Molestiae vulgivagus aureus. Deorsum rerum baiulus. Casus celo victus. Molestias in cernuus. Turbo absorbeo asporto."
  },
]
```
## Bolier plate untuk get 
```text
Karena ApiConstants.posts sudah ada

static const posts = '/posts';

Jadi untuk GET posts, kamu tinggal pakai:
_apiClient.get(ApiConstants.posts);

```
## Step 1: Buat Entity Post

# Step 1: Buat file

```text
lib/features/posts/domain/entities/post_entity.dart
```
# isi

```text
class PostEntity {
  const PostEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  final int id;
  final int userId;
  final String title;
  final String body;
}
```

# Kenapa beda dari user? Karena response posts bentuknya:

```text
{
  "id": 286459,
  "user_id": 8558935,
  "title": "...",
  "body": "..."
}
```

## Step 2: Buat Model Post

# Step 2: Buat file

```text
lib/features/posts/data/models/post_model.dart
```
# isi

```text
import '../../domain/entities/post_entity.dart';

class PostModel extends PostEntity {
  const PostModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.body,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as int? ?? 0,
      userId: json['user_id'] as int? ?? 0,
      title: json['title'] as String? ?? '-',
      body: json['body'] as String? ?? '-',
    );
  }
}
```

## Step 3: Buat Remote Data Source

# Step 3: Buat file

```text
lib/features/posts/data/datasources/posts_remote_data_source.dart
```
# isi

```text
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/post_model.dart';

abstract class PostsRemoteDataSource {
  Future<List<PostModel>> getPosts();
}

class PostsRemoteDataSourceImpl implements PostsRemoteDataSource {
  const PostsRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<List<PostModel>> getPosts() async {
    final response = await _apiClient.get(ApiConstants.posts);

    if (response is! List) {
      return const [];
    }

    return response
        .whereType<Map<String, dynamic>>()
        .map(PostModel.fromJson)
        .toList();
  }
}
```

# Ini mirip banget dengan [users_remote_data_source.dart](C:/logic-flutter/getx_clean_arsitektur/lib/features/users/data/datasources/users_remote_data_source.dart), cuma:

```text
UserModel -> PostModel
ApiConstants.users -> ApiConstants.posts
getUsers -> getPosts
```

## Step 4: Buat Repository Contract

# Step 4: Buat file

```text
lib/features/posts/domain/repositories/posts_repository.dart
```

# isi

```dart
import '../../../../core/utils/app_result.dart';
import '../entities/post_entity.dart';

abstract class PostsRepository {
  Future<AppResult<List<PostEntity>>> getPosts();
}
```

# Penjelasan

Repository contract itu seperti janji di layer domain.

Dia cuma bilang:

```text
Feature posts punya fungsi getPosts()
```

Tapi dia belum peduli data posts datang dari API, database lokal, cache, atau sumber lain.

Kenapa return-nya `PostEntity`, bukan `PostModel`?

```text
Domain layer pakai Entity.
Data layer pakai Model.
```

Jadi domain tetap bersih dan tidak terlalu bergantung ke bentuk JSON/API.

## Step 5: Buat Repository Implementation

# Step 5: Buat file

```text
lib/features/posts/data/repositories/posts_repository_impl.dart
```

# isi

```dart
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/app_result.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/repositories/posts_repository.dart';
import '../datasources/posts_remote_data_source.dart';

class PostsRepositoryImpl implements PostsRepository {
  const PostsRepositoryImpl(this._remoteDataSource);

  final PostsRemoteDataSource _remoteDataSource;

  @override
  Future<AppResult<List<PostEntity>>> getPosts() async {
    try {
      final posts = await _remoteDataSource.getPosts();
      return AppSuccess(posts);
    } on ServerException catch (error) {
      return AppFailure(error.message);
    } catch (error) {
      return AppFailure('Terjadi kesalahan: $error');
    }
  }
}
```

# Penjelasan

File ini adalah penghubung antara:

```text
Domain Repository
-> Data Source
```

Kalau request berhasil:

```dart
return AppSuccess(posts);
```

Kalau request gagal:

```dart
return AppFailure(error.message);
```

Jadi controller nanti tidak perlu pakai `try catch` langsung untuk API.

## Step 6: Buat Use Case

# Step 6: Buat file

```text
lib/features/posts/domain/usecases/get_posts_usecase.dart
```

# isi

```dart
import '../../../../core/utils/app_result.dart';
import '../entities/post_entity.dart';
import '../repositories/posts_repository.dart';

class GetPostsUseCase {
  const GetPostsUseCase(this._repository);

  final PostsRepository _repository;

  Future<AppResult<List<PostEntity>>> call() {
    return _repository.getPosts();
  }
}
```

# Penjelasan

Use case adalah aksi yang dilakukan aplikasi.

Untuk kasus ini aksinya:

```text
Ambil list posts
```

Nanti controller tidak memanggil repository langsung. Controller cukup panggil:

```dart
final result = await _getPostsUseCase();
```

Dengan begini layer presentation tetap rapi.

## Step 7: Buat Controller GetX

# Step 7: Buat file

```text
lib/features/posts/presentation/controllers/posts_controller.dart
```

# isi

```dart
import 'package:get/get.dart';

import '../../domain/entities/post_entity.dart';
import '../../domain/usecases/get_posts_usecase.dart';

class PostsController extends GetxController {
  PostsController(this._getPostsUseCase);

  final GetPostsUseCase _getPostsUseCase;

  final posts = <PostEntity>[].obs;
  final errorMessage = ''.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getPosts();
  }

  Future<void> getPosts() async {
    isLoading.value = true;
    errorMessage.value = '';

    final result = await _getPostsUseCase();

    result.fold(
      onFailure: (message) => errorMessage.value = message,
      onSuccess: (data) => posts.assignAll(data),
    );

    isLoading.value = false;
  }
}
```

# Penjelasan

Controller tugasnya mengatur state untuk UI.

State yang dipakai:

```text
posts        -> data list posts
isLoading    -> kondisi loading
errorMessage -> pesan error
```

Saat halaman dibuka:

```dart
onInit() {
  getPosts();
}
```

Jadi data langsung diambil otomatis.

## Step 8: Buat Binding

# Step 8: Buat file

```text
lib/features/posts/presentation/bindings/posts_binding.dart
```

# isi

```dart
import 'package:get/get.dart';

import '../../../../core/network/api_client.dart';
import '../../data/datasources/posts_remote_data_source.dart';
import '../../data/repositories/posts_repository_impl.dart';
import '../../domain/repositories/posts_repository.dart';
import '../../domain/usecases/get_posts_usecase.dart';
import '../controllers/posts_controller.dart';

class PostsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PostsRemoteDataSource>(
      () => PostsRemoteDataSourceImpl(Get.find<ApiClient>()),
    );

    Get.lazyPut<PostsRepository>(
      () => PostsRepositoryImpl(Get.find<PostsRemoteDataSource>()),
    );

    Get.lazyPut(
      () => GetPostsUseCase(Get.find<PostsRepository>()),
    );

    Get.lazyPut(
      () => PostsController(Get.find<GetPostsUseCase>()),
    );
  }
}
```

# Penjelasan

Binding itu tempat daftar dependency untuk feature posts.

Urutannya:

```text
ApiClient
-> PostsRemoteDataSource
-> PostsRepository
-> GetPostsUseCase
-> PostsController
```

Kenapa `ApiClient` tidak dibuat di sini?

Karena `ApiClient` sudah global di:

```text
lib/initial_binding.dart
```

Jadi di binding posts cukup panggil:

```dart
Get.find<ApiClient>()
```

## Step 9: Buat Page

# Step 9: Buat file

```text
lib/features/posts/presentation/pages/posts_page.dart
```

# isi

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/posts_controller.dart';

class PostsPage extends GetView<PostsController> {
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: controller.getPosts,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value && controller.posts.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage.isNotEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (controller.posts.isEmpty) {
            return const Center(child: Text('Post kosong'));
          }

          return RefreshIndicator(
            onRefresh: controller.getPosts,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: controller.posts.length,
              itemBuilder: (context, index) {
                final post = controller.posts[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(post.title),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(post.body),
                    ),
                    trailing: Text('#${post.id}'),
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }
}
```

# Penjelasan

Page hanya fokus ke tampilan.

Dia membaca state dari controller:

```dart
controller.isLoading
controller.errorMessage
controller.posts
```

Karena pakai `Obx`, UI otomatis rebuild saat data berubah.

## Step 10: Tambahkan Route

# Buka file

```text
lib/core/routes/app_routes.dart
```

Tambahkan:

```dart
static const posts = '/posts';
```

Contoh hasilnya:

```dart
class AppRoutes {
  const AppRoutes._();

  static const users = '/users';
  static const posts = '/posts';
}
```

# Buka file

```text
lib/core/routes/app_pages.dart
```

Tambahkan import:

```dart
import '../../features/posts/presentation/bindings/posts_binding.dart';
import '../../features/posts/presentation/pages/posts_page.dart';
```

Tambahkan `GetPage`:

```dart
GetPage(
  name: AppRoutes.posts,
  page: () => const PostsPage(),
  binding: PostsBinding(),
),
```

Contoh:

```dart
class AppPages {
  const AppPages._();

  static final pages = <GetPage<dynamic>>[
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
```

## Step 11: Cara Buka Halaman Posts

Kalau mau langsung buka posts sebagai halaman pertama, ubah di:

```text
lib/app.dart
```

Dari:

```dart
initialRoute: AppRoutes.users,
```

Menjadi:

```dart
initialRoute: AppRoutes.posts,
```

Kalau mau pindah halaman dari users ke posts, bisa pakai:

```dart
Get.toNamed(AppRoutes.posts);
```

## Step 12: Alur Lengkap GET Posts

```text
PostsPage dibuka
-> PostsBinding membuat dependency
-> PostsController dibuat
-> onInit() jalan
-> controller.getPosts()
-> GetPostsUseCase()
-> PostsRepository.getPosts()
-> PostsRepositoryImpl.getPosts()
-> PostsRemoteDataSource.getPosts()
-> ApiClient.get(ApiConstants.posts)
-> GET https://gorest.co.in/public/v2/posts
-> response JSON List
-> PostModel.fromJson()
-> List<PostEntity>
-> controller.posts.assignAll(data)
-> Obx rebuild UI
-> list posts tampil
```

## Ringkasan Copy Dari Users Ke Posts

Yang boleh dicopy dari `users`:

```text
struktur folder
remote data source
repository
usecase
controller
binding
page
```

Yang wajib diganti:

```text
User -> Post
Users -> Posts
user -> post
users -> posts
UserEntity -> PostEntity
UserModel -> PostModel
ApiConstants.users -> ApiConstants.posts
```

Field yang wajib menyesuaikan response posts:

```text
id
user_id -> userId
title
body
```

Jadi jangan copy field `name`, `email`, `gender`, `status` dari users.



## Command

```bash
flutter pub get
flutter run
flutter test
```
