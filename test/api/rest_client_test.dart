import "package:event_app/api/rest_client.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:flutter_test/flutter_test.dart";
import "package:http/http.dart" as http;
import "../support/mock_http.dart";

void main() {
  setUp(() {
    dotenv.testLoad(mergeWith: {
      "API_URL": "https://example.com",
    });
  });

  group("runCached", () {
    test("uses cached values for synchronous requests", () async {
      int httpCalls = 0;

      final responses = await http.runWithClient(() {
        return RestClient.runCached(() async {
          return [
            await rest.get("foo"),
            await rest.get("foo"),
            await rest.get("foo"),
          ];
        });
      }, () => MockHttp((_) async => '{"value": ${httpCalls++}}'));

      for (final response in responses) {
        expect(response["value"], 0);
      }
      expect(httpCalls, equals(1));
    });

    test("only spawns a single task for parallel requests to the same endpoint",
        () async {
      int httpCalls = 0;

      final responses = await http.runWithClient(() {
        return RestClient.runCached(() {
          return Future.wait([
            rest.get("foo"),
            rest.get("foo"),
            rest.get("foo"),
          ]);
        });
      }, () => MockHttp((_) async => '{"value": ${httpCalls++}}'));

      for (final response in responses) {
        expect(response["value"], 0);
      }
      expect(httpCalls, equals(1));
    });
  });
}
