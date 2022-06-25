abstract class RegisterState{}

class InitialRegisterState extends RegisterState{}

class ToggleVisibilityRegisterState extends RegisterState{}

class SuccessRegisterState extends RegisterState{
  String? uId;
  SuccessRegisterState(this.uId);
}


class ErrorRegisterState extends RegisterState{
  String? error;
  ErrorRegisterState(this.error);
}