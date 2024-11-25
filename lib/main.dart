import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_feed_app/bloc/auth/auth_bloc.dart';
import 'package:social_feed_app/bloc/signup/signup_bloc.dart';
import 'package:social_feed_app/bloc/post/post_bloc.dart';
import 'package:social_feed_app/bloc/profile/profile_bloc.dart';
import 'package:social_feed_app/config/router.dart';
import 'package:social_feed_app/data/database/database_singleton.dart';
import 'package:social_feed_app/services/auth_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // todo initialize on app startup is ok or better on first access
  // Initialize Hive
  await AuthStorageService().initialize();

  final db = await DatabaseSingleton().database;

  final authBloc = AuthBloc();
  final signupBlock = SignupBloc();
  final postBloc = PostBloc(db.postDao);
  final profileBloc = ProfileBloc(db.userDao);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => authBloc,
        ),
        BlocProvider<SignupBloc>(
          create: (context) => signupBlock,
        ),
        BlocProvider<PostBloc>(
          create: (context) => postBloc,
        ),
        BlocProvider(
          create: (context) => profileBloc,
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Social Feed App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
      ),
      routerConfig: AppRouter.getRouter(context),
    );
  }
}
