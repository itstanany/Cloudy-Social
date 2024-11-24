import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:social_feed_app/bloc/post/post_bloc.dart';
import 'package:social_feed_app/bloc/post/post_event.dart';
import 'package:social_feed_app/bloc/post/post_state.dart';
import 'package:social_feed_app/data/entity/post_entity.dart';
import 'package:social_feed_app/screens/feed_screen.dart';

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
      final post = Post(
        id: 1,
        body: 'Test post',
        likes: 10,
        authorUsername: 'testUser',
        createdAt: DateTime.now().toIso8601String(),
      );

      when(() => mockPostBloc.state).thenReturn(PostsLoaded([post]));
      whenListen(
        mockPostBloc,
        Stream.fromIterable([
          PostsLoaded([post]),
          PostLoading(),
          PostsLoaded([post.copyWith(likes: post.likes + 1)]),
        ]),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<PostBloc>.value(
            value: mockPostBloc,
            child: PostCard(
              post: post,
              currentUserUsername: 'testUser',
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
