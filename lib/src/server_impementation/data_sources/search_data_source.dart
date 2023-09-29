import '../../features/posts/domain/post.dart';

import '../../infrastructure/shared_dtos/shared_dtos.dart';

import '../fake_database.dart';

class SearchDataSource {
  FakeDatabase fakeDatabase = FakeDatabase();

  ResponseDTO<List<Post>> searchViaTextInTitle({required text}) {
    List<Post>? foundPosts = List.empty(growable: true);

    //Search in posts
    //If a post's title contains the provided text, we add the post to the founded posts list
    for (var post in fakeDatabase.posts) {
      if (post.title.contains(text)) {
        foundPosts.add(Post.fromFakeDatabsePost(post));
      }
    }

    return ResponseDTO(statusCode: 200, data: foundPosts);
  }
}
