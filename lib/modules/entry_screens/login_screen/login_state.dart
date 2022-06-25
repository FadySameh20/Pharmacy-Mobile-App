abstract class LoginState{}

class InitialLoginState extends LoginState{}

class ToggleVisibilityLoginState extends LoginState{}

class SuccessLoginState extends LoginState{
  String? uId;
  SuccessLoginState(this.uId);
}

class ErrorLoginState extends LoginState{
  String? error;
  ErrorLoginState(this.error);
}