import "package:bloc/bloc.dart";
import "package:event_app/api/exceptions.dart";
import "package:event_app/authentication/bloc/authentication_bloc.dart";

class AppBlocObserver extends BlocObserver {
  final AuthenticationBloc authenticationBloc;

  AppBlocObserver({required this.authenticationBloc});

  @override
  void onError(bloc, error, stackTrace) {
    super.onError(bloc, error, stackTrace);

    if (error is Unauthorized) {
      authenticationBloc.add(AuthenticationLogoutForced());
    }
  }
}
