const baseUri = "http://localhost:8001/api/v0";

abstract class HttpResponse {}

abstract class ResponseSuccess implements HttpResponse {}

abstract class ResponseFailure implements HttpResponse {}

class NoInternet implements ResponseFailure {
  const NoInternet();
}

class InvalidCredentials implements ResponseFailure {
  const InvalidCredentials();
}

class UnexpectedException implements ResponseFailure {
  const UnexpectedException();
}
