/// Base class for usecases
abstract class UseCase<T, Params> {
  Future<T> call(Params params);
}

/// For usecases that don't require parameters
class NoParams {
  const NoParams();
}
