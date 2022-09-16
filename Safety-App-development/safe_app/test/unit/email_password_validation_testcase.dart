import 'package:flutter_test/flutter_test.dart';
import 'package:safe_app/services/validators/validator.dart';


void main() {

  //For email
  test('Empty Email Test', () {
    var result = FieldValidator.validateEmail('');
    expect(result, 'Email can\'t be empty');
  });

  test('Non-empty email return null', ()
  {
    var result = FieldValidator.validateEmail('email');
    expect(result, null);
  });

  //For the password...
  test('Empty Password Test', () {
    var result = FieldValidator.validatePassword('');
    expect(result, 'Enter Password');
  });

  test('Non-empty password return null', ()
  {
    var result = FieldValidator.validatePassword('password');
    expect(result, null);
  });

  test('password less than 6 Character', ()
  {
    var result = FieldValidator.validatePassword('passw');
    expect(result, "Password must be more than 16 character");
  });


}
