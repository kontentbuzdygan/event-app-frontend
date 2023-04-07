import "dart:math";

import "package:event_app/api/json.dart";
import "package:event_app/api/models/event.dart";
import "package:event_app/api/models/profile.dart";

final _random = Random();
class Story {
  final int id, authorId, eventId;
  List<String> media;

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

Future<List<Story>> fetchRandomStoriesByEventId(int eventId) {
  List<Story> stories = List.empty(growable: true);

  for (int i = 0; i < 100; i++) {
    stories.add(Story._(
      id: i, 
      authorId: _random.nextInt(100), 
      eventId: eventId, 
      media: List.empty()
    ));
  }

  return Future.value(stories);
}

List<Story> fetchRandomStoriesByAuthorId(int authorId) {
  List<Story> stories = List.empty(growable: true);

  for (int i = 0; i < 100; i++) {
    stories.add(Story._(
      id: i, 
      authorId: authorId,
      eventId: _random.nextInt(100), 
      media: List.empty()
    ));
  }

  return stories;
}