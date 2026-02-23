import 'package:babysitter_app/src/packages/domain/usecases/usecase.dart';
import 'package:babysitter_app/src/packages/domain/profile_details/entities/user_profile_details.dart';
import 'package:babysitter_app/src/packages/domain/profile_details/repositories/profile_details_repository.dart';

class GetProfileDetailsUseCase implements UseCase<UserProfileDetails, String> {
  final ProfileDetailsRepository _repository;

  GetProfileDetailsUseCase(this._repository);

  @override
  Future<UserProfileDetails> call(String userId) {
    return _repository.getProfileDetails(userId);
  }
}
