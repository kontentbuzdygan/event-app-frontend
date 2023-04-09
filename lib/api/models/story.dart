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
    author = await randomProfile(id);
    return this;
  }

  Future<Story> fetchEvent() async {
    event = await Event.find(authorId);
    return this;
  }
}

Future<List<Story>> fetchRandomStoriesByEventId(int eventId) async {
  List<Story> stories = List.empty(growable: true);

  for (int i = 0; i < 7; i++) {
    List<PhotoUrls> medias = List.empty(growable: true);
    for (int j = 0; j < _random.nextInt(2) + 1; j++) {
      var photo = await fetchMockImage("party");
      medias.add(photo);
    }

    stories.add(Story._(
        id: i,
        authorId: _random.nextInt(100),
        eventId: eventId,
        media: medias));
  }

  return stories;
}

Future<List<Story>> fetchRandomStoriesByAuthorId(int authorId) async {
  List<Story> stories = List.empty(growable: true);
  List<PhotoUrls> medias = List.empty();

  for (int i = 0; i < 100; i++) {
    for (int j = 0; j < _random.nextInt(7) + 1; i++) {
      medias.add(await fetchMockImage("party"));
    }
    stories.add(Story._(
      id: i,
      authorId: authorId,
      eventId: _random.nextInt(100),
      media: medias,
    ));
  }

  return stories;
}
