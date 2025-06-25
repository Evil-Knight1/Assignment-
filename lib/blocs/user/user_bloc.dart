import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/user.dart';
import '../../repositories/user_repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc({required this.userRepository}) : super(UserInitial()) {
    on<LoadUsers>((event, emit) async {
      emit(UserLoadInProgress());
      try {
        final users = await userRepository.getUsers();
        emit(UserLoadSuccess(users: users));
      } catch (e) {
        emit(UserLoadFailure(error: e.toString()));
      }
    });

    on<AddUser>((event, emit) {
      if (state is UserLoadSuccess) {
        final updatedUsers = List<User>.from((state as UserLoadSuccess).users)
          ..add(event.user);
        emit(UserLoadSuccess(users: updatedUsers));
      }
    });
  }
}

