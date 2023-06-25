import "package:event_repository/event_repository.dart";
import "package:flutter_bloc/flutter_bloc.dart";

part "feed_state.dart";
part "feed_event.dart";


class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final EventRepository _eventRepository;

  FeedBloc({ required EventRepository eventRepository }) 
    : _eventRepository = eventRepository,
    super(FeedState())
  {
    on<FeedRefreshRequested>(_onRefresh);
    on<FeedNextPageRequested>(_onNextPage);
  }

  Future<void> _onRefresh(event, emit) async {
    if (state.status is! FeedLoading) {
      emit(state.copyWith(status: FeedLoading()));

      try {
        final events = await _eventRepository.findAll();
        emit(state.copyWith(
          events: events,
          status: FeedSuccess(),
          page: state.page+1,
        ));
      } on Exception catch (e) {
        addError(e);
        emit(state.copyWith(
          status: FeedFailure(cause: e.toString()),
        ));
      }
    }
  }

  Future<void> _onNextPage(event, emit) async {
    if (state.status is FeedSuccess) {
      emit(state.copyWith(status: FeedLoading()));

      try {
        final events = await _eventRepository.findAll();

        emit(state.copyWith(
          events: events,
          status: FeedSuccess(),
          page: state.page+1,
        ));
      } on Exception catch (e) {
        addError(e);
        emit(state.copyWith(
          status: FeedFailure(cause: e.toString()),
        ));
      }
    }
  }
}