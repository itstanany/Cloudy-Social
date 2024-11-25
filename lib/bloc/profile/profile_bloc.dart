import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_feed_app/bloc/profile/profile_events.dart';
import 'package:social_feed_app/bloc/profile/profile_state.dart';
import 'package:social_feed_app/data/dao/user_dao.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserDao _userDao;

  ProfileBloc(this._userDao) : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final user = await _userDao.findUserByUsername(event.username);
      if (user != null) {
        emit(ProfileLoaded(user));
      } else {
        emit(ProfileError('User not found'));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      await _userDao.updateUser(event.user);
      emit(ProfileLoaded(event.user));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
