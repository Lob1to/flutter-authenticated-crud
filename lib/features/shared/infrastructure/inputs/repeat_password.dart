import 'package:formz/formz.dart';
import 'package:teslo_shop/features/shared/infrastructure/inputs/inputs.dart';

// Define input validation errors
enum RepeatPasswordError {
  empty,
  format,
  mismatch,
}

// Extend FormzInput and provide the input type and error type.
class RepeatPassword extends FormzInput<String, RepeatPasswordError> {
  static final RegExp passwordRegExp = RegExp(
    r'(?:(?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$',
  );

  final Password originalPassword;

  // Call super.pure to represent an unmodified form input.
  const RepeatPassword.pure({this.originalPassword = const Password.pure()})
      : super.pure('');

  // Call super.dirty to represent a modified form input.
  const RepeatPassword.dirty(
      {required this.originalPassword, required String value})
      : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == RepeatPasswordError.empty) {
      return 'El campo es requerido';
    }
    if (displayError == RepeatPasswordError.format) {
      return 'Debe de tener Mayúscula, letras y un número';
    }
    if (displayError == RepeatPasswordError.mismatch) {
      return 'Las contraseñas no coinciden';
    }

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  RepeatPasswordError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return RepeatPasswordError.empty;
    if (!passwordRegExp.hasMatch(value)) return RepeatPasswordError.format;
    if (value != originalPassword.value) return RepeatPasswordError.mismatch;

    return null;
  }
}
