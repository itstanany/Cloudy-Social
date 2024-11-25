import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:social_feed_app/bloc/post/post_bloc.dart';
import 'package:social_feed_app/bloc/post/post_event.dart';
import 'package:social_feed_app/bloc/post/post_state.dart';
import 'package:social_feed_app/data/entities/post.dart';
import 'package:social_feed_app/models/post_model.dart';
import 'package:social_feed_app/views/feed/feed_screen.dart';
import 'package:social_feed_app/views/feed/widgets/like_button.dart';
import 'package:social_feed_app/views/feed/widgets/post_card.dart';

class MockPostBloc extends Mock implements PostBloc {}

class FakeLikePost extends Fake implements LikePost {}

void main() {
  late MockPostBloc mockPostBloc;

  setUp(() {
    mockPostBloc = MockPostBloc();
  });
  setUpAll(() {
    registerFallbackValue(FakeLikePost());
  });

  group('LikeButton Widget Tests', () {
    testWidgets('renders initial like count correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LikeButton(
              likes: 10,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('10'), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    });

    testWidgets('triggers animation and callback when tapped', (tester) async {
      bool wasPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LikeButton(
              likes: 5,
              onTap: () {
                wasPressed = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.favorite_border));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(wasPressed, true);
    });

    testWidgets('integrates with PostBloc correctly', (tester) async {
      final post = PostModel(Post(
        id: 1,
        body: 'Test post',
        likes: 10,
        authorUsername: 'testUser',
        createdAt: DateTime.now().toIso8601String(),
      ));

      when(() => mockPostBloc.state).thenReturn(PostsLoaded([post.post]));
      whenListen(
        mockPostBloc,
        Stream.fromIterable([
          PostsLoaded([post.post]),
          PostLoading(),
          PostsLoaded([post.post.copyWith(likes: post.post.likes + 1)]),
        ]),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<PostBloc>.value(
            value: mockPostBloc,
            child: PostCardView(
              postModel: post,
              currentUserUsername: 'testUser',
              onDelete: () => {},
              onLike: () => {},
              onEdit: (String newBody) => {},
            ),
          ),
        ),
      );

      await tester.tap(find.byType(LikeButton));
      await tester.pumpAndSettle();

      verify(() => mockPostBloc.add(any<LikePost>())).called(1);
    });
  });
}
