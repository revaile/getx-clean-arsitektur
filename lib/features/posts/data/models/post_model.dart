
import 'package:getx_clean_arsitektur/features/posts/domain/entities/post_entity.dart';

class PostModel extends PostEntity {
  const PostModel({
    required super.userId,
    required super.id,
    required super.title,
    required super.body,

  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      userId: json['userId'] as int? ?? 0,
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '-',
      body: json['body'] as String? ?? '-'

    );
  }

  // Map<String, dynamic> toJson() {
  //   return {

  //   };
  // }
}
