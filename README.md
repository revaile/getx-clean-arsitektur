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

## Alur Feature Users

```text
UsersPage
  -> UsersController
  -> GetUsersUseCase / GetUserUseCase / CreateUserUseCase
  -> UpdateUserUseCase / DeleteUserUseCase
  -> UsersRepository
  -> UsersRemoteDataSource
  -> ApiClient
  -> GoREST API
```

## Command

```bash
flutter pub get
flutter run
flutter test
```
