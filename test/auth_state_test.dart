import "package:event_app/api/rest_client.dart";
import "package:event_app/features/auth/auth_state.dart";
import "package:event_app/secure_storage.dart";
import "package:flutter_test/flutter_test.dart";
import "utils/mock_rest_client.dart";
import "utils/mock_secure_storage.dart";

late MockRestClient restMock;

void main() {
  late RestMock signIn, signUp, signOut, refresh, userExists;
  late AuthState authState;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();

    overrideRestClient(restMock = MockRestClient());
    overrideSecureStorage(const MockSecureStorage());

    signIn = restMock.mock("POST", ["auth", "sign-in"], (_) => {"token": "DUMMY-TOKEN"});
    signUp = restMock.mock("POST", ["auth", "sign-up"], (_) => {});
    signOut = restMock.mock("DELETE", ["auth", "sign-out"], (_) => {});
    refresh = restMock.mock("POST", ["auth", "refresh"], (_) => {"token": "FRESH-TOKEN"});
    userExists = restMock.mock(
      "POST",
      ["auth", "user-exists"],
      (request) => {"user_exists": request?["email"] == "john.doe@example.com"},
    );

    authState = AuthState();
  });

  test("signIn", () async {
    await authState.signIn("john.doe@example.com", "password1234");

    expect(authState.userToken, equals("DUMMY-TOKEN"));
    expect(signIn, hasBeenCalled());
    expect(signIn.lastRequest?.body, equals({
      "email": "john.doe@example.com",
      "password": "password1234",
    }));
  });

  test("signUp", () async {
    await authState.signUp("john.doe@example.com", "password1234");

    expect(signUp, hasBeenCalled());
    expect(signUp.lastRequest?.body, equals({
      "email": "john.doe@example.com",
      "password": "password1234",
    }));
  });

  test("signOut", () async {
    await authState.signIn("john.doe@example.com", "password1234");
    await authState.signOut();

    expect(authState.userToken, isNull);
    expect(signOut, hasBeenCalled());
  });

  test("refreshToken", () async {
    await authState.signIn("john.doe@example.com", "password1234");
    await authState.refreshToken();

    expect(authState.userToken, equals("FRESH-TOKEN"));
    expect(refresh, hasBeenCalled());
  });

  test("userExists", () async {
    expect(await authState.userExists("john.doe@example.com"), isTrue);
    expect(await authState.userExists("foobar@example.com"), isFalse);
    expect(userExists, hasBeenCalled(times: 2));
  });
}
