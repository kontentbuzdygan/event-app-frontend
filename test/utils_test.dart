import "package:flutter_test/flutter_test.dart";
import "package:event_app/utils.dart";

void main() {
  group("joinUrl", () {
    test("returns empty string for empty array", () {
      expect(joinUrl([]), equals(""));
    });

    test("given one element returns it with sanitized slashes", () {
      expect(joinUrl(["/"]), equals(""));
      expect(joinUrl(["foo"]), equals("foo"));
      expect(joinUrl(["foo/"]), equals("foo"));
      expect(joinUrl(["foo//"]), equals("foo"));
      expect(joinUrl(["/foo"]), equals("foo"));
      expect(joinUrl(["/foo/"]), equals("foo"));
      expect(joinUrl(["foo/bar"]), equals("foo/bar"));
      expect(joinUrl(["foo/bar/"]), equals("foo/bar"));
      expect(joinUrl(["foo//bar"]), equals("foo/bar"));
      expect(joinUrl(["/foo/bar"]), equals("foo/bar"));
      expect(joinUrl(["/foo/bar/"]), equals("foo/bar"));
    });

    test("given multiple elements joins them with sanitized slashes", () {
      expect(joinUrl(["foo", "bar"]), equals("foo/bar"));
      expect(joinUrl(["foo/", "bar/"]), equals("foo/bar"));
      expect(joinUrl(["/foo/", "/bar/"]), equals("foo/bar"));
      expect(joinUrl(["foo", "/", "bar"]), equals("foo/bar"));
    });
  });
}
