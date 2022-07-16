import 'package:faker/faker.dart';
import '../entities/entities.dart';

class FakeDatabase {
  static final FakeDatabase _instance = FakeDatabase._privateConstructor();

  factory FakeDatabase() {
    return _instance;
  }

  FakeDatabase._privateConstructor() {
    initializeDatabase();
  }

  List<User> users = List.empty(growable: true);
  List<PostCategory> categories = List.empty(growable: true);
  List<Post> posts = List.empty(growable: true);
  AuthenticatedUserModel? authenticatedUser;

  final ErrorModel unAuthorizedError = ErrorModel(
    message: 'Unauthorized',
    detail: 'You have not permission to do this action.\nPlease login first.',
    statusCode: 401,
  );

  void createDummyUser(int count) {
    Faker faker = Faker();
    for (int i = 0; i <= count; i++) {
      users.add(User(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        firstName: faker.person.name(),
        lastName: faker.person.lastName(),
        age: faker.randomGenerator.integer(80, min: 18),
        email: faker.internet.email(),
        role: UserRole.writer,
        status: UserStatus.active,
      ));
    }
  }

  void initializeDatabase() {
    //create admin
    users.add(User(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        firstName: 'admin',
        lastName: 'admin',
        age: 20,
        email: 'admin@gmail.com',
        password: 'Admin12!@',
        role: UserRole.chiefEditor,
        status: UserStatus.active));

    createDummyCategories(14);
    createDummyUser(14);
    createDummyPost(14);
  }

  void createDummyCategories(int count) {
    Faker faker = Faker();

    for (int i = 0; i < count; i++) {
      categories.add(PostCategory(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        title: faker.lorem.word(),
        description: faker.lorem.sentence(),
      ));
    }
  }

  void createDummyPost(int count) {
    Faker faker = Faker();

    for (int i = 0; i < count; i++) {
      posts.add(Post(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        title: '${faker.lorem.word()} ${faker.lorem.word()}',
        summary: faker.lorem.sentence(),
        content: faker.lorem.sentence() +
            faker.lorem.sentence() +
            faker.lorem.sentence(),
        status: PostStatus.published,
        category: (categories..shuffle()).first,
        imagesUrls: [
          faker.image.image(
              width: 1280,
              height: 720,
              keywords: ['spring', 'winter', 'nature'],
              random: true),
          faker.image.image(
              width: 1280,
              height: 720,
              keywords: ['spring', 'winter', 'nature'],
              random: true),
          faker.image.image(
              width: 1280,
              height: 720,
              keywords: ['spring', 'winter', 'nature'],
              random: true)
        ],
        author: (users..shuffle()).first,
      ));
    }
  }

  bool isUserTokenValid({required String token}) {
    if (authenticatedUser == null ||
        authenticatedUser!.token != token ||
        authenticatedUser!.expirationDate.isBefore(DateTime.now())) {
      return false;
    }

    return true;
  }
}
