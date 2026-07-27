sealed class AppResult<T> {
  const AppResult();

  R fold<R>({
    required R Function(String message) onFailure,
    required R Function(T data) onSuccess,
  }) {
    return switch (this) {
      AppSuccess<T>(:final data) => onSuccess(data),
      AppFailure<T>(:final message) => onFailure(message),
    };
  }
}

class AppSuccess<T> extends AppResult<T> {
  const AppSuccess(this.data);

  final T data;
}

class AppFailure<T> extends AppResult<T> {
  const AppFailure(this.message);

  final String message;
}
