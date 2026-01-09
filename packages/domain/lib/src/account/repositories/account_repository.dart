import '../entities/account_overview.dart';

/// Repository interface for account related operations
abstract class AccountRepository {
  /// Fetch the account overview for a user
  Future<AccountOverview> getAccountOverview(String userId);
}
