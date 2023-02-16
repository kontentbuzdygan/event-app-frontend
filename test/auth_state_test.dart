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
    restMock.add(
      RequestMock("POST", ["auth", "sign-in"], (requestBody) {
        expect(requestBody["email"], equals("john.doe@example.com"));
        expect(requestBody["password"], equals("password1234"));
        return {"token": "DUMMY-TOKEN"};
      }),
    );

    final authState = AuthState();
    await authState.signIn("john.doe@example.com", "password1234");
    expect(authState.userToken, equals("DUMMY-TOKEN"));
  });

  // TODO: Add tests for remaining methods
}
