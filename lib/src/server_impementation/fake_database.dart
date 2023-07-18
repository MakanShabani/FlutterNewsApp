import 'dart:math';

import 'package:faker/faker.dart';
import 'package:responsive_admin_dashboard/src/features/comment/domain/comment.dart';

import 'databse_entities/databse_comment.dart';
import 'databse_entities/databse_entities.dart';
import 'services/signed_in_user_service.dart';

class FakeDatabase {
  static final FakeDatabase _instance = FakeDatabase._privateConstructor();

  factory FakeDatabase() {
    return _instance;
  }

  FakeDatabase._privateConstructor() {
    initializeDatabase();
  }

  SignedInUserService signedInUserService = SignedInUserService();
  final List<DatabaseUser> clients = List.empty(growable: true);
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

//methods

  void initializeDatabase() {
    createDummyCategories(4);
    createDummyClients(20);
    createDummyStaffs(15);
    createDummyPost(30);
    createDummyComments(15);
  }

  void createDummyClients(int count) {
    //Add some users as static memebrs -- for login & test purposes
    clients.add(DatabaseUser(
      id: 'user_static1',
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

  void createDummyCategories(int count) {
    Faker faker = Faker();

    for (int i = 0; i < count; i++) {
      categories.add(DatabasePostCategory(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        createdAt: faker.date.dateTime(minYear: 2018, maxYear: 2022),
        updatedAt: DateTime.now(),
        title: faker.lorem.word(),
        description: faker.lorem.sentence(),
      ));
    }
  }

  void createDummyComments(int maxCommentsForEachPost) {
    Faker faker = Faker();

    for (int j = 0; j < posts.length; j++) {
      int commentsCount =
          faker.randomGenerator.integer(maxCommentsForEachPost, min: 1);
      for (int i = 0; i < commentsCount; i++) {
        comments.add(
          DatabaseComment(
            id: DateTime.now().microsecondsSinceEpoch.toString(),
            createdAt: faker.date.dateTime(minYear: 2018, maxYear: 2022),
            updatedAt: DateTime.now(),
            postId: posts[j].id,
            content: i % 2 == 0
                ? faker.lorem.sentence() +
                    faker.lorem.sentence() +
                    faker.lorem.sentence() +
                    faker.lorem.sentence()
                : faker.lorem.sentence(),
            user: clients[Random().nextInt(clients.length)],
<<<<<<< Updated upstream
=======
            replies: createDummyRepliesForComments(
                posts[j].id, faker.randomGenerator.integer(5)),
>>>>>>> Stashed changes
          ),
        );
      }

      //set post's commentsCount
      posts[j].commentsCount = commentsCount;
    }
  }

  List<DatabaseComment> createDummyRepliesForComments(
      String postId, int howManyReplies) {
    List<DatabaseComment> replies = List.empty(growable: true);

    for (int i = 0; i <= howManyReplies; i++) {
      replies.add(DatabaseComment(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          createdAt: faker.date.dateTime(minYear: 2018, maxYear: 2022),
          updatedAt: DateTime.now(),
          user: clients[Random().nextInt(clients.length)],
          postId: postId,
          content: i % 2 == 0
              ? faker.lorem.sentence() +
                  faker.lorem.sentence() +
                  faker.lorem.sentence()
              : faker.lorem.sentence(),
          replies: List.empty(growable: true)));
    }

    return replies;
  }

  void createDummyPost(int count) {
    Faker faker = Faker();

    for (int i = 0; i < count; i++) {
      posts.add(DatabsePost(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        commentsCount: 0,
        viewsCount: faker.randomGenerator.integer(10000000),
        createdAt: faker.date.dateTime(minYear: 2022, maxYear: 2022),
        updatedAt: DateTime.now(),
        title: '${faker.lorem.word()} ${faker.lorem.sentence()}',
        summary: faker.lorem.sentence() +
            faker.lorem.sentence() +
            faker.lorem.sentence(),
        content: faker.lorem.sentence() +
            faker.lorem.sentence() +
            faker.lorem.sentence() +
            faker.lorem.sentence() +
            faker.lorem.sentence() +
            faker.lorem.sentence() +
            faker.lorem.sentence() +
            faker.lorem.sentence() +
            faker.lorem.sentence() +
            faker.lorem.sentence() +
            faker.lorem.sentence() +
            faker.lorem.sentence() +
            faker.lorem.sentence() +
            faker.lorem.sentence() +
            faker.lorem.sentence() +
            faker.lorem.sentence() +
            faker.lorem.sentence() +
            faker.lorem.sentence() +
            faker.lorem.sentence() +
            faker.lorem.sentence() +
            faker.lorem.sentence() +
            faker.lorem.sentence() +
            faker.lorem.sentence() +
            faker.lorem.sentence() +
            faker.lorem.sentence() +
            faker.lorem.sentence() +
            faker.lorem.sentence(),
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
    if (sigendInUser == null ||
        sigendInUser!.token != token ||
        sigendInUser!.tokenExpiresAt!.isBefore(DateTime.now())) {
      return false;
    }

    return true;
  }
}
