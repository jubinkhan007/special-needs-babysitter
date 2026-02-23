import '../../usecases/usecase.dart';
import '../entities/user_profile_details.dart';
import '../repositories/profile_details_repository.dart';

class GetProfileDetailsUseCase implements UseCase<UserProfileDetails, String> {
  final ProfileDetailsRepository _repository;

  GetProfileDetailsUseCase(this._repository);

  @override
  Future<UserProfileDetails> call(String userId) {
    return _repository.getProfileDetails(userId);
  }
}
