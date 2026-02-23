import 'package:babysitter_app/src/features/calls/domain/entities/call_history_item.dart';
import 'package:babysitter_app/src/features/calls/domain/repositories/calls_repository.dart';

class GetCallHistoryParams {
  final int limit;
  final int offset;

  const GetCallHistoryParams({
    this.limit = 20,
    this.offset = 0,
  });
}

class GetCallHistoryUseCase {
  final CallsRepository _repository;

  GetCallHistoryUseCase(this._repository);

  Future<CallHistoryPage> call(GetCallHistoryParams params) {
    return _repository.getCallHistory(
      limit: params.limit,
      offset: params.offset,
    );
  }
}
