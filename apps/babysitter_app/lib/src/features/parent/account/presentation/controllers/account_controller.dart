import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core/core.dart';

import 'package:auth/auth.dart'; // For currentUserProvider if needed, or AuthSession
import '../providers/account_providers.dart';
import '../state/account_state.dart';

part 'account_controller.g.dart';

@riverpod
class AccountController extends _$AccountController {
  @override
  Future<AccountState> build() async {
    return _loadAccount();
  }

  Future<AccountState> _loadAccount() async {
    final getAccountOverview = ref.read(getAccountOverviewUseCaseProvider);
    final authState = ref.watch(authNotifierProvider);
    final user = authState.value?.user;

    if (user == null) {
      if (authState.isLoading) {
        return const AccountState(isLoading: true);
      }
      return const AccountState(errorMessage: 'User not authenticated');
    }

    try {
      final overview = await getAccountOverview(user.id);
      return AccountState(overview: overview, isLoading: false);
    } catch (e) {
      throw AppErrorHandler.parse(e);
    }
  }

  Future<void> reload() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _loadAccount());
  }

  // Sign out is handled by AuthNotifier, but we can expose a wrapper if needed
  // or just call AuthNotifier directly from UI as currently done.
  // The requirements said "signOut()" in controller.
  Future<void> signOut() async {
    await ref.read(authNotifierProvider.notifier).signOut();
  }
}
