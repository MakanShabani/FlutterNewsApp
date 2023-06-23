import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:responsive_admin_dashboard/src/features/comment/application/comment_application.dart';
import 'package:responsive_admin_dashboard/src/features/comment/domain/comment.dart';
import 'package:responsive_admin_dashboard/src/features/comment/presentation/blocs/fetch_comments/comments_fetching_cubit.dart';
import 'package:responsive_admin_dashboard/src/infrastructure/shared_dtos/shared_dtos.dart';
import 'package:responsive_admin_dashboard/src/infrastructure/shared_models/error_model.dart';

class MockCommentFethcingService extends Mock
    implements CommentsFetchingService {}

List<Comment> generateComments(String postId) {
  return [
    Comment(
        id: '0',
        postId: postId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        userId: '0',
        userName: 'Makan',
        userLastName: 'Shabani',
        content: 'This is a test message from user 0'),
    Comment(
        id: '1',
        postId: postId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        userId: '1',
        userName: 'Masoud',
        userLastName: 'Shabani',
        content: 'This is a test message from user 1'),
    Comment(
        id: '2',
        postId: postId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        userId: '2',
        userName: 'Mehran',
        userLastName: 'Shabani',
        content: 'This is a test message from user 2'),
  ];
}

ErrorModel generateFakeErrorModel(int errorCode) =>
    ErrorModel(message: 'err', detail: 'err', statusCode: errorCode);

void main() {
  String tPostId = '0';
  int tHowManyShouldFetch = 5;
  PagingOptionsDTO tPagingOptionsDTO =
      PagingOptionsDTO(offset: 0, limit: tHowManyShouldFetch);

  late CommentsFetchingCubit commentsCubit;
  late MockCommentFethcingService mockCommentsFetchingService;
  late List<Comment> tComments;
  setUp(() {
    tComments = generateComments(tPostId);
    mockCommentsFetchingService = MockCommentFethcingService();
    commentsCubit = CommentsFetchingCubit(
        postId: tPostId, fetchCommentsService: mockCommentsFetchingService);

    //register fallbacks for mocktail
    registerFallbackValue(
        PagingOptionsDTO(offset: tComments.length, limit: tHowManyShouldFetch));
  });

  group('fetchComments()', () {
    blocTest<CommentsFetchingCubit, CommentsFetchingState>(
        'emits CommentsFetchingFetchingState, CommentsFetchingFetchedState] when'
        '\nfetchComments is called successfully and the final list of comments length > 0.'
        '\n#note that the comments list before fethcing is empty',
        setUp: () => when(() => mockCommentsFetchingService.getComments(
                pagingOptionsDTO: tPagingOptionsDTO, postId: tPostId))
            .thenAnswer((_) async =>
                ResponseDTO<List<Comment>>(statusCode: 200, data: tComments)),
        build: () => commentsCubit,
        act: (cubit) =>
            cubit.fetchComments(howManyShouldFetch: tHowManyShouldFetch),
        wait: const Duration(seconds: 5),
        expect: () => <CommentsFetchingState>[
              CommentsFetchingFetchingState(
                  postId: tPostId, comments: List.empty()),
              CommentsFetchingFetchedState(
                  postId: tPostId,
                  comments: tComments,
                  fetchedComments: tComments)
            ],
        verify: (_) async {
          verify(() => mockCommentsFetchingService.getComments(
              postId: tPostId, pagingOptionsDTO: tPagingOptionsDTO)).called(1);
        });

    blocTest<CommentsFetchingCubit, CommentsFetchingState>(
      'emits [CommentsFetchingFetchingState, CommentsFetchingListIsEmpty] when fetchComments is called sucessfully\n'
      'and the final number of comments is 0',
      setUp: () => when(() => mockCommentsFetchingService.getComments(
              postId: tPostId, pagingOptionsDTO: tPagingOptionsDTO))
          .thenAnswer((_) async =>
              ResponseDTO<List<Comment>>(statusCode: 200, data: List.empty())),
      build: () => commentsCubit,
      act: (cubit) =>
          cubit.fetchComments(howManyShouldFetch: tHowManyShouldFetch),
      expect: () => <CommentsFetchingState>[
        CommentsFetchingFetchingState(postId: tPostId, comments: List.empty()),
        CommentsFetchingListIsEmpty(postId: tPostId, comments: List.empty())
      ],
      verify: (_) async {
        verify(() => mockCommentsFetchingService.getComments(
            postId: tPostId, pagingOptionsDTO: tPagingOptionsDTO)).called(1);
      },
    );

    blocTest<CommentsFetchingCubit, CommentsFetchingState>(
      'emits [CommentsFetchingFetchingState, CommentsFetchingNoMoreToFetch] when fetchComments is called sucessfully\n'
      'and the final number of comments is > 0 but we did not fetch any new post(there was nothing new in our databse!)',
      setUp: () => when(() => mockCommentsFetchingService.getComments(
              postId: tPostId,
              pagingOptionsDTO: any(named: 'pagingOptionsDTO')))
          .thenAnswer((_) async =>
              ResponseDTO<List<Comment>>(statusCode: 200, data: List.empty())),
      build: () => commentsCubit,
      seed: () =>
          CommentsFetchingInitialState(postId: tPostId, comments: tComments),
      act: (cubit) =>
          cubit.fetchComments(howManyShouldFetch: tHowManyShouldFetch),
      expect: () => <CommentsFetchingState>[
        CommentsFetchingFetchingState(postId: tPostId, comments: tComments),
        CommentsFetchingNoMoreToFetch(postId: tPostId, comments: tComments)
      ],
      verify: (_) async {
        verify(() => mockCommentsFetchingService.getComments(
            postId: tPostId,
            pagingOptionsDTO: any(named: 'pagingOptionsDTO'))).called(1);
      },
    );

    blocTest<CommentsFetchingCubit, CommentsFetchingState>(
      'emits [CommentsFetchingFetchingState, CommentsFetchingFailedState] when fetchComments is not called sucessfully\n',
      setUp: () => when(() => mockCommentsFetchingService.getComments(
              postId: tPostId, pagingOptionsDTO: tPagingOptionsDTO))
          .thenAnswer((_) async => ResponseDTO<List<Comment>>(
              statusCode: 300, error: generateFakeErrorModel(300))),
      build: () => commentsCubit,
      act: (cubit) =>
          cubit.fetchComments(howManyShouldFetch: tHowManyShouldFetch),
      expect: () => <CommentsFetchingState>[
        CommentsFetchingFetchingState(postId: tPostId, comments: List.empty()),
        CommentsFetchingFailedState(
            postId: tPostId,
            comments: List.empty(),
            error: generateFakeErrorModel(300)),
      ],
      verify: (_) async {
        verify(() => mockCommentsFetchingService.getComments(
            postId: tPostId, pagingOptionsDTO: tPagingOptionsDTO)).called(1);
      },
    );
  });
}
