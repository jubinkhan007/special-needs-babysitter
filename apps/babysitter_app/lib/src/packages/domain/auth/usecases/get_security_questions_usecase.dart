import '../repositories/registration_repository.dart';
import '../../usecases/usecase.dart';

/// Use case for fetching security questions
class GetSecurityQuestionsUseCase implements UseCase<List<String>, NoParams> {
  final RegistrationRepository _repository;

  GetSecurityQuestionsUseCase(this._repository);

  @override
  Future<List<String>> call(NoParams params) {
    return _repository.getSecurityQuestions();
  }
}
