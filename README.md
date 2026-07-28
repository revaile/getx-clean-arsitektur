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


## Contoh get list id

```text
GET https://gorest.co.in/public/v2/todos/107349
{
  "id": 107349,
  "user_id": 8558937,
  "title": "Cubo alter considero esse neque aegrotatio vel auditor.",
  "due_on": "2026-08-15T00:00:00.000+05:30",
  "status": "pending"
}
```

## Boilerplate GET Todo Detail

Endpoint detail todos:

```text
GET https://gorest.co.in/public/v2/todos/{id}
```

Contoh:

```text
GET https://gorest.co.in/public/v2/todos/107349
```

Alur clean architecture-nya:

```text
TodosPage
-> klik salah satu todo
-> TodosDetailPage(todoId)
-> TodosController.getTodo(id)
-> GetTodoUseCase(id)
-> TodosRepository.getTodo(id)
-> TodosRepositoryImpl.getTodo(id)
-> TodosRemoteDataSource.getTodo(id)
-> ApiClient.get('/todos/{id}')
-> GoREST API
-> TodoModel.fromJson()
-> selectedTodo
-> UI detail tampil
```

## Step 1: Tambahkan Method di Remote Data Source

Buka file:

```text
lib/features/todos/data/datasources/todos_remote_data_source.dart
```

Tambahkan method di abstract class:

```dart
abstract class TodosRemoteDataSource {
  Future<List<TodoModel>> getTodos();
  Future<TodoModel> getTodo(int id);
}
```

Tambahkan implementasinya:

```dart
class TodosRemoteDataSourceImpl implements TodosRemoteDataSource {
  const TodosRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<List<TodoModel>> getTodos() async {
    final response = await _apiClient.get(ApiConstants.todos);

    if (response is! List) {
      return const [];
    }

    return response
        .whereType<Map<String, dynamic>>()
        .map(TodoModel.fromJson)
        .toList();
  }

  @override
  Future<TodoModel> getTodo(int id) async {
    final response = await _apiClient.get('${ApiConstants.todos}/$id');
    return TodoModel.fromJson(response as Map<String, dynamic>);
  }
}
```

Penjelasan:

```text
ApiConstants.todos = /todos
id = id todo yang diklik
```

Jadi request finalnya:

```text
GET https://gorest.co.in/public/v2/todos/107349
```

## Step 2: Tambahkan Method di Repository Contract

Buka file:

```text
lib/features/todos/domain/repositories/todos_repository.dart
```

Isi:

```dart
import '../../../../core/utils/app_result.dart';
import '../entities/todo_entity.dart';

abstract class TodosRepository {
  Future<AppResult<List<TodoEntity>>> getTodos();
  Future<AppResult<TodoEntity>> getTodo(int id);
}
```

Penjelasan:

```text
getTodos() = ambil list todos
getTodo(id) = ambil detail todo berdasarkan id
```

## Step 3: Tambahkan Implementasi Repository

Buka file:

```text
lib/features/todos/data/repositories/todos_repository_impl.dart
```

Isi lengkap:

```dart
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/app_result.dart';
import '../../domain/entities/todo_entity.dart';
import '../../domain/repositories/todos_repository.dart';
import '../datasources/todos_remote_data_source.dart';

class TodosRepositoryImpl implements TodosRepository {
  const TodosRepositoryImpl(this._remoteDataSource);

  final TodosRemoteDataSource _remoteDataSource;

  @override
  Future<AppResult<List<TodoEntity>>> getTodos() async {
    try {
      final todos = await _remoteDataSource.getTodos();
      return AppSuccess(todos);
    } on ServerException catch (error) {
      return AppFailure(error.message);
    } catch (error) {
      return AppFailure('Terjadi kesalahan: $error');
    }
  }

  @override
  Future<AppResult<TodoEntity>> getTodo(int id) async {
    try {
      final todo = await _remoteDataSource.getTodo(id);
      return AppSuccess(todo);
    } on ServerException catch (error) {
      return AppFailure(error.message);
    } catch (error) {
      return AppFailure('Terjadi kesalahan: $error');
    }
  }
}
```

Penjelasan:

```text
RepositoryImpl memanggil remote data source.
Kalau berhasil -> AppSuccess(todo)
Kalau gagal -> AppFailure(message)
```

## Step 4: Buat Use Case Detail

Buat file:

```text
lib/features/todos/domain/usecases/get_todo_usecase.dart
```

Isi:

```dart
import '../../../../core/utils/app_result.dart';
import '../entities/todo_entity.dart';
import '../repositories/todos_repository.dart';

class GetTodoUseCase {
  const GetTodoUseCase(this._repository);

  final TodosRepository _repository;

  Future<AppResult<TodoEntity>> call(int id) {
    return _repository.getTodo(id);
  }
}
```

Penjelasan:

```text
Controller tidak langsung panggil repository.
Controller cukup panggil GetTodoUseCase.
```

## Step 5: Update Controller

Buka file:

```text
lib/features/todos/presentation/controllers/todos_controller.dart
```

Isi lengkap:

```dart
import 'package:get/get.dart';

import '../../domain/entities/todo_entity.dart';
import '../../domain/usecases/get_todo_usecase.dart';
import '../../domain/usecases/get_todos_usecase.dart';

class TodosController extends GetxController {
  TodosController(
    this._getTodosUseCase,
    this._getTodoUseCase,
  );

  final GetTodosUseCase _getTodosUseCase;
  final GetTodoUseCase _getTodoUseCase;

  final todos = <TodoEntity>[].obs;
  final selectedTodo = Rxn<TodoEntity>();

  final errorMessage = ''.obs;
  final detailErrorMessage = ''.obs;

  final isLoading = false.obs;
  final isDetailLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getTodos();
  }

  Future<void> getTodos() async {
    isLoading.value = true;
    errorMessage.value = '';

    final result = await _getTodosUseCase();

    result.fold(
      onFailure: (message) => errorMessage.value = message,
      onSuccess: (data) => todos.assignAll(data),
    );

    isLoading.value = false;
  }

  Future<void> getTodo(int id) async {
    isDetailLoading.value = true;
    detailErrorMessage.value = '';
    selectedTodo.value = null;

    final result = await _getTodoUseCase(id);

    result.fold(
      onFailure: (message) => detailErrorMessage.value = message,
      onSuccess: (data) => selectedTodo.value = data,
    );

    isDetailLoading.value = false;
  }
}
```

State detail:

```text
selectedTodo       = data detail todo
isDetailLoading    = loading khusus detail
detailErrorMessage = error khusus detail
```

## Step 6: Update Binding

Buka file:

```text
lib/features/todos/presentation/bindings/todos_bindings.dart
```

Isi lengkap:

```dart
import 'package:get/get.dart';

import '../../../../core/network/api_client.dart';
import '../../data/datasources/todos_remote_data_source.dart';
import '../../data/repositories/todos_repository_impl.dart';
import '../../domain/repositories/todos_repository.dart';
import '../../domain/usecases/get_todo_usecase.dart';
import '../../domain/usecases/get_todos_usecase.dart';
import '../controllers/todos_controller.dart';

class TodosBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TodosRemoteDataSource>(
      () => TodosRemoteDataSourceImpl(Get.find<ApiClient>()),
    );

    Get.lazyPut<TodosRepository>(
      () => TodosRepositoryImpl(Get.find<TodosRemoteDataSource>()),
    );

    Get.lazyPut(() => GetTodoUseCase(Get.find<TodosRepository>()));
    Get.lazyPut(() => GetTodosUseCase(Get.find<TodosRepository>()));

    Get.lazyPut(
      () => TodosController(
        Get.find<GetTodosUseCase>(),
        Get.find<GetTodoUseCase>(),
      ),
    );
  }
}
```

Penjelasan:

```text
Binding harus daftar GetTodoUseCase.
Kalau tidak, Get.find<GetTodoUseCase>() akan error.
```

## Step 7: Buat Todos Detail Page

Buat file:

```text
lib/features/todos/presentation/pages/todos_detail_page.dart
```

Isi:

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/todos_controller.dart';

class TodosDetailPage extends StatefulWidget {
  const TodosDetailPage({super.key, required this.todoId});

  final int todoId;

  @override
  State<TodosDetailPage> createState() => _TodosDetailPageState();
}

class _TodosDetailPageState extends State<TodosDetailPage> {
  final TodosController controller = Get.find<TodosController>();

  @override
  void initState() {
    super.initState();
    controller.getTodo(widget.todoId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo #${widget.todoId}'),
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isDetailLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.detailErrorMessage.isNotEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      controller.detailErrorMessage.value,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () => controller.getTodo(widget.todoId),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          final todo = controller.selectedTodo.value;

          if (todo == null) {
            return const Center(child: Text('Todo tidak ditemukan'));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        todo.title,
                        style: Theme.of(context).textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 16),
                      _DetailRow(label: 'ID', value: todo.id.toString()),
                      _DetailRow(
                        label: 'User ID',
                        value: todo.userId.toString(),
                      ),
                      _DetailRow(label: 'Due On', value: todo.dueOn),
                      _DetailRow(label: 'Status', value: todo.status),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: const Color(0xFF64748B),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}
```

Kenapa pakai `StatefulWidget`?

```text
Request detail dipanggil sekali di initState().
Jangan panggil API di build(), karena build bisa jalan berkali-kali.
```

## Step 8: Update TodosPage Supaya Card Bisa Diklik

Buka file:

```text
lib/features/todos/presentation/pages/todos_page.dart
```

Tambahkan import:

```dart
import 'todos_detail_page.dart';
```

Ubah card list menjadi clickable:

```dart
return InkWell(
  onTap: () => Get.to(
    () => TodosDetailPage(todoId: todo.id),
  ),
  borderRadius: BorderRadius.circular(8),
  child: Card(
    margin: const EdgeInsets.only(bottom: 12),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            todo.title,
            style: Theme.of(context).textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          _TodoRow(label: 'ID', value: todo.id.toString()),
          _TodoRow(
            label: 'User ID',
            value: todo.userId.toString(),
          ),
          _TodoRow(label: 'Due On', value: todo.dueOn),
          _TodoRow(label: 'Status', value: todo.status),
        ],
      ),
    ),
  ),
);
```

Penjelasan:

```dart
TodosDetailPage(todoId: todo.id)
```

Artinya id dari todo yang diklik dikirim ke halaman detail.

## Alur Lengkap GET Todo Detail

```text
User klik salah satu Todo
-> Get.to(TodosDetailPage(todoId: todo.id))
-> TodosDetailPage.initState()
-> controller.getTodo(id)
-> GetTodoUseCase(id)
-> TodosRepository.getTodo(id)
-> TodosRepositoryImpl.getTodo(id)
-> TodosRemoteDataSource.getTodo(id)
-> ApiClient.get('/todos/{id}')
-> GET https://gorest.co.in/public/v2/todos/{id}
-> TodoModel.fromJson()
-> selectedTodo.value = data
-> Obx rebuild UI
-> detail todo tampil
```

## Urutan File GET Todo Detail

```text
1. todos_remote_data_source.dart
2. todos_repository.dart
3. todos_repository_impl.dart
4. get_todo_usecase.dart
5. todos_controller.dart
6. todos_bindings.dart
7. todos_detail_page.dart
8. todos_page.dart
```


## Command

```bash
flutter pub get
flutter run
flutter test
```
