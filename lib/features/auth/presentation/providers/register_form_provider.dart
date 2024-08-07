import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_shop/features/shared/infrastructure/inputs/inputs.dart';

//! 3 - StateNotifierProvider - Consumir desde el exterior

final registerFormProvider =
    StateNotifierProvider<RegisterFormNotifier, RegisterFormState>((ref) {
  final registerCallback = ref.watch(authProvider.notifier).registerUser;

  return RegisterFormNotifier(registerCallback: registerCallback);
});

//! 2 - StateNotifier

class RegisterFormNotifier extends StateNotifier<RegisterFormState> {
  final Function(String, String, String) registerCallback;

  RegisterFormNotifier({required this.registerCallback})
      : super(RegisterFormState());

  onFullNameChanged(String value) {
    final newFullName = FullName.dirty(value);

    state = state.copyWith(
      fullName: newFullName,
      isValid: Formz.validate([newFullName, state.email, state.password]),
    );
  }

  onEmailChanged(String value) {
    final newEmail = Email.dirty(value);

    state = state.copyWith(
      email: newEmail,
      isValid: Formz.validate([state.fullName, newEmail, state.password]),
    );
  }

  onPasswordChanged(String value) {
    final newPassword = Password.dirty(value);

    state = state.copyWith(
      password: Password.dirty(value),
      isValid: Formz.validate([state.fullName, state.email, newPassword]),
    );
  }

  onRepeatPasswordChanged(String value) {
    final newRepeatedPassword =
        RepeatPassword.dirty(originalPassword: state.password, value: value);

    state = state.copyWith(
        repeatPassword: newRepeatedPassword,
        isValid: Formz.validate([state.fullName, state.email, state.password]));
  }

  void onFormSumbit() async {
    _touchEveryField();

    if (!state.isValid) return;

    await registerCallback(
        state.email.value, state.password.value, state.fullName.value);
  }

  _touchEveryField() {
    final fullName = FullName.dirty(state.fullName.value);
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    final repeatedPassword = RepeatPassword.dirty(
        originalPassword: state.password, value: state.repeatPassword.value);

    state = state.copyWith(
      isFormPosted: true,
      fullName: fullName,
      email: email,
      password: password,
      repeatPassword: repeatedPassword,
    );
  }
}

//! 1 - RegisterState

class RegisterFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final FullName fullName;
  final Email email;
  final Password password;
  final RepeatPassword repeatPassword;

  RegisterFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.fullName = const FullName.pure(),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.repeatPassword = const RepeatPassword.pure(),
  });

  RegisterFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    FullName? fullName,
    Email? email,
    Password? password,
    RepeatPassword? repeatPassword,
  }) =>
      RegisterFormState(
        isPosting: isPosting ?? this.isPosting,
        isFormPosted: isFormPosted ?? this.isFormPosted,
        isValid: isValid ?? this.isValid,
        fullName: fullName ?? this.fullName,
        email: email ?? this.email,
        password: password ?? this.password,
        repeatPassword: repeatPassword ?? this.repeatPassword,
      );

  @override
  String toString() {
    return '''
RegisterFormState
  isPosting: $isPosting
  isFormPosted: $isFormPosted
  isValid: $isValid
  fullName: $fullName
  email: $email
  password: $password
  repeatPassword: $repeatPassword
''';
  }
}
