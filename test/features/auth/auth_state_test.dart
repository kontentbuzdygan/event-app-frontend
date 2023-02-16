import "package:event_app/api/exceptions.dart";
import "package:event_app/api/rest_client.dart";
import "package:event_app/features/auth/auth_state.dart";
import "package:event_app/secure_storage.dart";
import "package:flutter_test/flutter_test.dart";
import "../../support/mock_rest_client.dart";
import "../../support/in_memory_storage.dart";

void main() {
  // TODO: Consider using https://docs.flutter.dev/cookbook/testing/unit/mocking instead?
  late MockRestClient restMock;
  late MockRestEndpoint signIn;
  late AuthState authState;
  late InMemoryStorage storage;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();

    overrideRestClient(restMock = MockRestClient());
    overrideSecureStorage(storage = const InMemoryStorage());

    signIn = restMock.mock("POST", ["auth", "sign-in"], (_) => {"token": "DUMMY-TOKEN"});
    authState = AuthState();
  });

  test("signIn", () async {
    await authState.signIn("john.doe@example.com", "password1234");

    expect(signIn, hasBeenCalled());
    expect(signIn.lastRequest?.body, equals({
      "email": "john.doe@example.com",
      "password": "password1234",
    }));
    expect(authState.userToken, equals("DUMMY-TOKEN"));
    expect(authState.loggedIn, isTrue);
    expect(await storage.read(key: userTokenStorageKey), equals("DUMMY-TOKEN"));
  });

  test("signUp", () async {
    final signUp = restMock.mock("POST", ["auth", "sign-up"], (_) => {});
    await authState.signUp("john.doe@example.com", "password1234");

    expect(signUp, hasBeenCalled());
    expect(signUp.lastRequest?.body, equals({
      "email": "john.doe@example.com",
      "password": "password1234",
    }));
  });

  test("signOut", () async {
    final signOut = restMock.mock("DELETE", ["auth", "sign-out"], (_) => {});
    await authState.signIn("john.doe@example.com", "password1234");
    await authState.signOut();

    expect(signOut, hasBeenCalled());
    expect(authState.userToken, isNull);
    expect(authState.loggedIn, isFalse);
    expect(await storage.read(key: userTokenStorageKey), equals(null));
  });

  group("refreshToken", () {
    test("successful response", () async {
      final refresh = restMock.mock("POST", ["auth", "refresh"], (_) => {"token": "FRESH-TOKEN"});
      await authState.signIn("john.doe@example.com", "password1234");
      await authState.refreshToken();

      expect(refresh, hasBeenCalled());
      expect(authState.userToken, equals("FRESH-TOKEN"));
      expect(authState.loggedIn, isTrue);
      expect(await storage.read(key: userTokenStorageKey), equals("FRESH-TOKEN"));
    });

    test("error response", () async {
      final refresh = restMock.mock("POST", ["auth", "refresh"], (_) {
        throw const Unauthorized();
      });
      await authState.signIn("john.doe@example.com", "password1234");

      expect(authState.refreshToken, throwsA(isA<Unauthorized>()));
      expect(refresh, hasBeenCalled());
    });
  });

  test("userExists", () async {
    final userExists = restMock.mock("POST", ["auth", "user-exists"], (request) => {
      "user_exists": request?["email"] == "john.doe@example.com"
    });

    expect(await authState.userExists("john.doe@example.com"), isTrue);
    expect(await authState.userExists("foobar@example.com"), isFalse);
    expect(userExists, hasBeenCalled(times: 2));
  });

  test("restoreAndRefreshToken", () async {
    final refresh = restMock.mock("POST", ["auth", "refresh"], (_) {
      expect(authState.userToken, equals("STORED-TOKEN"));
      throw const Unauthorized();
    });

    await storage.write(key: userTokenStorageKey, value: "STORED-TOKEN");
    await authState.restoreAndRefreshToken();

    expect(refresh, hasBeenCalled());
  });
}
