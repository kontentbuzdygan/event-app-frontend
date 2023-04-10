import "dart:math";

import "package:event_app/api/json.dart";
import "package:event_app/api/models/event.dart";
import "package:event_app/api/models/profile.dart";
import "package:event_app/utils.dart";
import "package:unsplash_client/unsplash_client.dart";

final _random = Random();

class Story {
  final int id, authorId, eventId;
  List<PhotoUrls> media;

  Profile? author;
  Event? event;

  Story._({
    required this.id,
    required this.authorId,
    required this.eventId,
    required this.media,
  });

  factory Story.fromJson(JsonObject json) => Story._(
        id: json["id"],
        authorId: json["authoId"],
        eventId: json["eventId"],
        media: json["media"],
      );

  Future<Story> fetchAuthor() async {
    author = await randomProfile(authorId);
    return this;
  }

  Future<Story> fetchEvent() async {
    event = await randomEvent(eventId);
    return this;
  }
}

Future<List<Story>> fetchRandomStoriesByEventId(int eventId) async {
  List<Story> stories = List.generate(
      7,
      (index) => Story._(
          id: index,
          authorId: _random.nextInt(100),
          eventId: eventId,
          media: List.empty()));

  await Future.wait(stories.map((story) async {
    story.media = [for (var i = 0; i < 2; i++) await fetchMockImage("party")];
  }));

  return stories;
}

Future<List<Story>> fetchRandomStoriesByAuthorId(int authorId) async {
  List<Story> stories = List.generate(
      7,
      (index) => Story._(
            id: index,
            authorId: authorId,
            eventId: _random.nextInt(100),
            media: List.empty(growable: true),
          ));

  await Future.wait(stories.map((story) async {
    story.media = [for (var i = 0; i < 2; i++) await fetchMockImage("party")];
  }));

  return stories;
}
