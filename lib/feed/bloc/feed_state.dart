part of "feed_bloc.dart";

sealed class FeedStatus {}
final class FeedInitial extends FeedStatus {}
final class FeedLoading extends FeedStatus {}
final class FeedSuccess extends FeedStatus {}
final class FeedFailure extends FeedStatus {
  final String cause;
  FeedFailure({required this.cause});
}

class FeedState {
  final List<Event>? events;
  final FeedStatus status;
  final int page;

  FeedState({this.events, FeedStatus? status, this.page = 1}) 
    : status = status ?? FeedInitial();

  FeedState copyWith({ 
    List<Event>? events,
    FeedStatus? status,
    int? page,
  }) => FeedState(
    events: events ?? this.events,
    status: status ?? this.status,
    page: page ?? this.page,
  );
}
