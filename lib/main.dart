import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:social_feed_app/bloc/auth/auth_bloc.dart';
import 'package:social_feed_app/bloc/auth/signup/signup_bloc.dart';
import 'package:social_feed_app/config/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  await Hive.openBox('auth');

  final authBloc = AuthBloc();
  final signupBlock = SignupBloc();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => authBloc,
        ),
        BlocProvider<SignupBloc>(
          create: (context) => signupBlock,
        )
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
