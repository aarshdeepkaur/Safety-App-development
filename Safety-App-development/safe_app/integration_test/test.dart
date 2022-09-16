import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:safe_app/main.dart';

Future<void> addDelay(int ms) async {
await Future<void>.delayed(Duration(milliseconds: ms));
}

Future<void> logout(WidgetTester tester) async {
await addDelay(8000);
// await tester.tap(find.byKey(const ValueKey('LogoutKey')));
await tester.tap(find.byKey(const ValueKey('LogoutKey')));
await addDelay(8000);
tester.printToConsole('Login screen opens');
await tester.pumpAndSettle();
}

Future<void> setupLogin(WidgetTester tester) async {
//1 open login screen
tester.printToConsole('login screen opens');
//2 Waits for all animations to settle down.
await tester.pumpAndSettle();
}

Future<void> validLogin(WidgetTester tester, String email) async {
await setupLogin(tester);

//3 find the valueKey and fill in
await tester.enterText(find.byKey(const ValueKey('emailLoginField')), email);
//4 fill in the password field
await tester.enterText(
find.byKey(const ValueKey('passLoginField')), 'Welcome123@');

//5 tap the login button
await tester.tap(find.bySemanticsLabel('LOGIN'));
//6  As a result, API results fetch late, and the test framework should wait for them.
await addDelay(8000); //delays for 24s

await tester.pumpAndSettle();
expect(find.text('GO'), findsOneWidget);
expect(find.text('Logout'), findsOneWidget);
}

Future<void> invalidLoginWithEmptyFill(WidgetTester tester) async {
await setupLogin(tester);

//5 tap the login button
await tester.tap(find.bySemanticsLabel('LOGIN'));
//6  As a result, API results fetch late, and the test framework should wait for them.
await addDelay(8000); //delays for 24s

await tester.pumpAndSettle();
expect(find.text('Enter an email'), findsOneWidget);
expect(find.text('Enter an password 6+ chars long'), findsOneWidget);
}

Future<void> invalidLoginWithNotExistedUser(WidgetTester tester) async {
await setupLogin(tester);

await tester.enterText(find.byKey(const ValueKey('emailLoginField')), '1@gmail.com');
await tester.enterText(
find.byKey(const ValueKey('passLoginField')), '1234567');

//5 tap the login button
await tester.tap(find.bySemanticsLabel('LOGIN'));
//6  As a result, API results fetch late, and the test framework should wait for them.
await addDelay(8000); //delays for 24s

await tester.pumpAndSettle();
expect(find.text('There is no user record corresponding to this identifier.'
'The user may have bean deleted.'), findsOneWidget);
}

Future<void> fillInSignUpName(WidgetTester tester) async {
await tester.enterText(
find.byKey(const ValueKey('firstNameSignupField')), "First name test");
await tester.enterText(
find.byKey(const ValueKey('lastNameSignupField')), "Last name test");
}

Future<void> setupSignUp(WidgetTester tester) async {
//1 open signup screen
await tester.tap(find.byKey(const ValueKey('SignupLabel')));
await addDelay(1000);
await tester.pumpAndSettle();
tester.printToConsole('signup screen opens');
//2 Waits for all animations to settle down.
await tester.pumpAndSettle();
}

Future<void> validSignup(WidgetTester tester, String email, String timeNow) async {
await setupSignUp(tester);

await fillInSignUpName(tester);
await tester.enterText(
find.byKey(const ValueKey('emailSignupField')), email);
await tester.enterText(
find.byKey(const ValueKey('phoneSignupField')), timeNow);
await tester.enterText(
find.byKey(const ValueKey('passSignupField')), 'Welcome123@');

//5 tap the signup button
await tester.tap(find.bySemanticsLabel('SIGN UP'),
warnIfMissed: false);
await addDelay(24000);

await tester.pumpAndSettle();
expect(find.text('GO'), findsOneWidget);
expect(find.text('Logout'), findsOneWidget);
}

Future<void> invalidSignupWithEmptyFill(WidgetTester tester) async {
await setupSignUp(tester);

//5 tap the signup button
await tester.tap(find.bySemanticsLabel('SIGN UP'),
warnIfMissed: false);
await addDelay(24000);

await tester.pumpAndSettle();
expect(find.text('Enter your first name'), findsOneWidget);
expect(find.text('Enter your last name'), findsOneWidget);
expect(find.text('Enter your email address'), findsOneWidget);
expect(find.text('Enter your phone number'), findsOneWidget);
expect(find.text('Enter an password 6+ chars long'), findsOneWidget);
}

Future<void> invalidSignupWithWrongPassFormat(WidgetTester tester, String email, String timeNow) async {
await setupSignUp(tester);

await fillInSignUpName(tester);
await tester.enterText(
find.byKey(const ValueKey('emailSignupField')), email);
await tester.enterText(
find.byKey(const ValueKey('phoneSignupField')), timeNow);
await tester.enterText(
find.byKey(const ValueKey('passSignupField')), 'test');

//5 tap the signup button
await tester.tap(find.bySemanticsLabel('SIGN UP'),
warnIfMissed: false);
await addDelay(24000);

await tester.pumpAndSettle();
expect(find.text('Enter an password 6+ chars long'), findsOneWidget);
}

void main() {
final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
as IntegrationTestWidgetsFlutterBinding;

if (binding is LiveTestWidgetsFlutterBinding) {
binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;
}

group('end-to-end test', () {
// final email = "tester@test.com";
final timeNow = DateTime.now().microsecondsSinceEpoch.toString();
final email = timeNow + '@test.com';

testWidgets('authentication login', (WidgetTester tester) async {
//add firebase init -> ensure we can use firebase service
await Firebase.initializeApp();
await tester.pumpWidget(const MyApp());
await tester.pumpAndSettle();

// todo invalid signup ( wrong email format | wrong phone number format)
await invalidSignupWithEmptyFill(tester);
await invalidSignupWithWrongPassFormat(tester, email, timeNow);
await validSignup(tester, email, timeNow); //valid signup

await logout(tester); //logout

//todo invalid login (empty everything | wrong email format | wrong password format | user not existed)
await invalidLoginWithEmptyFill(tester);
await invalidLoginWithNotExistedUser(tester);
await validLogin(tester, email); //valid login

//todo: test main screen with location tracked working
});
});
}