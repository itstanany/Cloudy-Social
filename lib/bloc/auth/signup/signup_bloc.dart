import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_feed_app/bloc/auth/signup/signup_events.dart';
import 'package:social_feed_app/bloc/auth/signup/signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc() : super(SignupInitial()) {
    on<SignupSubmitted>((event, emit) async {
      emit(SignupLoading());
      try {
        // Here you would typically make an API call to register the user
        await Future.delayed(Duration(seconds: 2)); // Simulated API call
        emit(SignupSuccess());
      } catch (error) {
        emit(SignupFailure(error.toString()));
      }
    });
  }
}
