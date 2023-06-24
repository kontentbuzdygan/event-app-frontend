import "package:formz/formz.dart";
import "package:string_validator/string_validator.dart";

enum EmailValidationError { empty, invalidEmail }

class Email extends FormzInput<String, EmailValidationError> {
  const Email.pure() : super.pure("");
  const Email.dirty([super.value = ""]) : super.dirty();

  @override
  EmailValidationError? validator(String value) {
    if (value.isEmpty) return EmailValidationError.empty;
    if (!isEmail(value)) return EmailValidationError.invalidEmail;
    return null;
  }
}