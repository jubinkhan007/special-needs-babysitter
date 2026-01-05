/// Base class for usecases
abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}

/// For usecases that don't require parameters
class NoParams {
  const NoParams();
}
