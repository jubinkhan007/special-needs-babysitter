import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core/core.dart';
import 'package:auth/auth.dart';
import '../state/sitter_account_state.dart';

part 'sitter_account_controller.g.dart';

@riverpod
class SitterAccountController extends _$SitterAccountController {
  @override
  Future<SitterAccountState> build() async {
    return _loadAccount();
  }

  Future<SitterAccountState> _loadAccount() async {
    final authState = ref.watch(authNotifierProvider);
    final user = authState.value?.user;

    if (user == null) {
      if (authState.isLoading) {
        return const SitterAccountState(isLoading: true);
      }
      return const SitterAccountState(errorMessage: 'User not authenticated');
    }

    try {
      // TODO: Replace with actual API call when backend supports sitter account overview
      // For now, create overview from user data with placeholder stats
      final overview = SitterAccountOverview(
        user: user,
        completedJobsCount: 4, // Placeholder - fetch from API
        savedJobsCount: 4, // Placeholder - fetch from API
        profileCompletionPercent: user.isProfileComplete ? 1.0 : 0.6,
      );
      return SitterAccountState(overview: overview, isLoading: false);
    } catch (e) {
      throw AppErrorHandler.parse(e);
    }
  }

  Future<void> reload() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _loadAccount());
  }

  Future<void> signOut() async {
    await ref.read(authNotifierProvider.notifier).signOut();
  }
}
