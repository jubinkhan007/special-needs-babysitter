import 'package:babysitter_app/src/packages/domain/usecases/usecase.dart';
import 'package:babysitter_app/src/packages/domain/account/entities/account_overview.dart';
import 'package:babysitter_app/src/packages/domain/account/repositories/account_repository.dart';

/// Use case to get account overview
class GetAccountOverviewUseCase implements UseCase<AccountOverview, String> {
  final AccountRepository _repository;

  GetAccountOverviewUseCase(this._repository);

  @override
  Future<AccountOverview> call(String userId) {
    return _repository.getAccountOverview(userId);
  }
}
