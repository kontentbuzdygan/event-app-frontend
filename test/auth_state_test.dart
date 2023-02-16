import "package:event_app/api/rest_client.dart";
import "package:event_app/features/auth/auth_state.dart";
import "package:event_app/secure_storage.dart";
import "package:flutter_test/flutter_test.dart";
import "utils/mock_rest_client.dart";
import "utils/mock_secure_storage.dart";

late MockRestClient restMock;

void main() {
  setUp(() {
    overrideRestClient(restMock = MockRestClient());
    overrideSecureStorage(const MockSecureStorage());
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  test("signIn", () async {
    final signIn = restMock.mock(
        "POST", ["auth", "sign-in"], (_) => {"token": "DUMMY-TOKEN"});

    final authState = AuthState();
    await authState.signIn("john.doe@example.com", "password1234");

    expect(authState.userToken, equals("DUMMY-TOKEN"));
    expect(signIn, hasBeenCalled);
    expect(
      signIn.lastRequest?.body,
      equals({
        "email": "john.doe@example.com",
        "password": "password1234",
      }),
    );
  });

  // TODO: Add tests for remaining methods
}
