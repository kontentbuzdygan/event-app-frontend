import "package:flutter_test/flutter_test.dart";
import "package:event_app/utils.dart";

void main() {
  group("joinPath", () {
    test("returns empty string for empty array", () {
      expect(joinPath([]), equals(""));
    });

    test("given one element returns it with sanitized slashes", () {
      expect(joinPath(["/"]), equals(""));
      expect(joinPath(["foo"]), equals("foo"));
      expect(joinPath(["foo/"]), equals("foo"));
      expect(joinPath(["foo//"]), equals("foo"));
      expect(joinPath(["/foo"]), equals("foo"));
      expect(joinPath(["/foo/"]), equals("foo"));
      expect(joinPath(["foo/bar"]), equals("foo/bar"));
      expect(joinPath(["foo/bar/"]), equals("foo/bar"));
      expect(joinPath(["foo//bar"]), equals("foo/bar"));
      expect(joinPath(["/foo/bar"]), equals("foo/bar"));
      expect(joinPath(["/foo/bar/"]), equals("foo/bar"));
    });

    test("given multiple elements joins them with sanitized slashes", () {
      expect(joinPath(["foo", "bar"]), equals("foo/bar"));
      expect(joinPath(["foo/", "bar/"]), equals("foo/bar"));
      expect(joinPath(["/foo/", "/bar/"]), equals("foo/bar"));
      expect(joinPath(["foo", "/", "bar"]), equals("foo/bar"));
    });
  });
}
