part of "feed_bloc.dart";

sealed class FeedEvent {}
final class FeedRefreshRequested extends FeedEvent {}
final class FeedNextPageRequested extends FeedEvent {}
