import 'package:getx_clean_arsitektur/core/errors/exceptions.dart';
import 'package:getx_clean_arsitektur/core/utils/app_result.dart';
import 'package:getx_clean_arsitektur/features/posts/data/datasources/posts_remote_data_source.dart';
import 'package:getx_clean_arsitektur/features/posts/domain/entities/post_entity.dart';
import 'package:getx_clean_arsitektur/features/posts/domain/repositories/posts_repository.dart';

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