import 'package:flutter_test/flutter_test.dart';
import 'package:pharmacy_management_system/modules/entry_screens/login_screen/login_screen.dart';

void main () {

  group('Login testing', ()
  {
    group('Email tests', () {
      test('Correct email should give no error', () {
        var correctEmail = EmailFieldValidator.validateEmail(
            'example@gmail.com');

        expect(correctEmail, null);
      });

      test('Empty email should return error', () {
        var emptyEmail = EmailFieldValidator.validateEmail('');

        expect(emptyEmail, 'Email field is required !');
      });

      test('Invalid email should return error', () {
        var incorrectEmailTest1 = EmailFieldValidator.validateEmail(
            'examplegmail.com');
        var incorrectEmailTest2 = EmailFieldValidator.validateEmail(
            'example@gmail');

        expect(incorrectEmailTest1, 'Email is incorrect !');
        expect(incorrectEmailTest2, 'Email is incorrect !');
      });
    });

    test('Empty password should return error', () {
      var emptyPassword = PasswordFieldValidator.validatePassword('');

      expect(emptyPassword, 'Password field is required !');
    });
  });

}