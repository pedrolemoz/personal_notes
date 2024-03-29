import '../../../../../core/presentation/controllers/base/base_states.dart';

class AuthenticatingUserState implements ProcessingState {}

class SuccessfullyAuthenticatedUserState implements SuccessState {
  final String userName;

  SuccessfullyAuthenticatedUserState({required this.userName});
}

class UnableToAuthenticateUserState implements ErrorState {}

class UserNotFoundState implements ErrorState {}
