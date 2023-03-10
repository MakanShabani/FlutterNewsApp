import 'dart:math';

import 'package:faker/faker.dart';
import 'package:responsive_admin_dashboard/src/server_impementation/databse_entities/databse_comment.dart';

import 'databse_entities/databse_entities.dart';

class FakeDatabase {
  static final FakeDatabase _instance = FakeDatabase._privateConstructor();

  factory FakeDatabase() {
    return _instance;
  }

  FakeDatabase._privateConstructor() {
    initializeDatabase();
  }

  List<DatabaseUser> clients = List.empty(growable: true);
  List<DatabaseUser> staffs = List.empty(growable: true);
  List<DatabasePostCategory> categories = List.empty(growable: true);
  List<DatabsePost> posts = List.empty(growable: true);
  List<DatabaseComment> comments = List.empty(growable: true);
  DatabaseUser? sigendInUser;
  Map<String, List<String>> bookmarkedPostsTable = {};
  final DatabseErrorModel unAuthorizedError = DatabseErrorModel(
    message: 'Unauthorized',
    detail: 'You have not permission to do this action.\nPlease login first.',
    statusCode: 401,
  );

  final DatabseErrorModel categoryNotExist = DatabseErrorModel(
    message: 'Category Not Exist',
    detail: 'Category not found with this id.',
    statusCode: 404,
  );

  void createDummyClients(int count) {
    //Add myself -- for login & test purposes
    clients.add(DatabaseUser(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      firstName: 'Makan',
      lastName: 'Shabani',
      age: 30,
      email: 'makan@gmail.com',
      password: 'mk',
      role: DatabseUserRole.client,
      status: DatabseUserStatus.active,
    ));
    //Create Dummy Clients
    Faker faker = Faker();
    for (int i = 0; i <= count; i++) {
      clients.add(DatabaseUser(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        firstName: faker.person.name(),
        lastName: faker.person.lastName(),
        age: faker.randomGenerator.integer(80, min: 18),
        email: faker.internet.email(),
        role: DatabseUserRole.client,
        status: DatabseUserStatus.active,
      ));
    }
  }

  void createDummyStaffs(int count) {
    Faker faker = Faker();
    for (int i = 0; i <= count; i++) {
      clients.add(DatabaseUser(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        firstName: faker.person.name(),
        lastName: faker.person.lastName(),
        age: faker.randomGenerator.integer(80, min: 18),
        email: faker.internet.email(),
        role: DatabseUserRole.writer,
        status: DatabseUserStatus.active,
      ));
    }
  }

  void initializeDatabase() async {
    //create admin
    staffs.add(DatabaseUser(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        firstName: 'admin',
        lastName: 'admin',
        age: 20,
        email: 'admin@gmail.com',
        password: 'a',
        imageUrl:
            'https://resize-elle.ladmedia.fr/rcrop/1024,1024/img/var/plain_site/storage/images/people/la-vie-des-people/news/brad-pitt-en-fauteuil-roulant-une-photo-inquiete-ses-fans-3924809/94792543-1-fre-FR/Brad-Pitt-en-fauteuil-roulant-une-photo-inquiete-ses-fans.jpg',
        role: DatabseUserRole.chiefEditor,
        status: DatabseUserStatus.active));

    createDummyCategories(4);
    createDummyClients(20);
    createDummyStaffs(15);
    createDummyPost(100);
    createDummyComments(15);
  }

  void createDummyCategories(int count) {
    Faker faker = Faker();

    for (int i = 0; i < count; i++) {
      categories.add(DatabasePostCategory(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        title: faker.lorem.word(),
        description: faker.lorem.sentence(),
      ));
    }
  }

  void createDummyComments(int maxCommentsForEachPost) {
    Faker faker = Faker();

    for (var post in posts) {
      for (int i = 0;
          i < faker.randomGenerator.integer(maxCommentsForEachPost);
          i++) {
        comments.add(
          DatabaseComment(
            id: DateTime.now().microsecondsSinceEpoch.toString(),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            postId: post.id,
            content: i % 2 == 0
                ? faker.lorem.sentence() +
                    faker.lorem.sentence() +
                    faker.lorem.sentence() +
                    faker.lorem.sentence()
                : faker.lorem.sentence(),
            user: clients[Random().nextInt(clients.length)],
          ),
        );
      }
    }
  }

  void createDummyPost(int count) {
    Faker faker = Faker();

    for (int i = 0; i < count; i++) {
      posts.add(DatabsePost(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        commentsCount: 0,
        viewsCount: faker.randomGenerator.integer(10000000),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        title: '${faker.lorem.word()} ${faker.lorem.sentence()}',
        summary: faker.lorem.sentence() +
            faker.lorem.sentence() +
            faker.lorem.sentence(),
        content: faker.randomGenerator.string(400, min: 200),
        status: DatabsePostStatus.published,
        category: (categories..shuffle()).first,
        isBookmarked: false,
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
        author: (staffs..shuffle()).first,
      ));
    }
  }

  bool isUserTokenValid({required String token}) {
    FakeDatabase fakeDatabase = FakeDatabase();
    if (fakeDatabase.sigendInUser == null ||
        fakeDatabase.sigendInUser!.token != token ||
        fakeDatabase.sigendInUser!.tokenExpiresAt!.isBefore(DateTime.now())) {
      return false;
    }

    return true;
  }
}
