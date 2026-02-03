import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/call_history_item.dart';
import '../../domain/usecases/get_call_history_usecase.dart';
import 'calls_providers.dart';

// ==================== State (FIX #1 - Corrected sealed class) ====================

/// Call history state - NO factory constructors (those require Freezed)
sealed class CallHistoryState {
  const CallHistoryState();
}

/// Loading state
class CallHistoryLoading extends CallHistoryState {
  const CallHistoryLoading();
}

/// Error state
class CallHistoryError extends CallHistoryState {
  final String message;
  const CallHistoryError(this.message);
}

/// Loaded state with items
class CallHistoryLoaded extends CallHistoryState {
  final List<CallHistoryItem> items;
  final bool hasMore;
  final bool isLoadingMore;

  const CallHistoryLoaded(this.items, this.hasMore, this.isLoadingMore);
}

// Extension for pattern matching
extension CallHistoryStateX on CallHistoryState {
  R when<R>({
    required R Function() loading,
    required R Function(String message) error,
    required R Function(
      List<CallHistoryItem> items,
      bool hasMore,
      bool isLoadingMore,
    ) loaded,
  }) {
    final self = this;
    if (self is CallHistoryLoading) return loading();
    if (self is CallHistoryError) return error(self.message);
    if (self is CallHistoryLoaded) {
      return loaded(self.items, self.hasMore, self.isLoadingMore);
    }
    throw StateError('Unknown state: $self');
  }

  R maybeWhen<R>({
    R Function()? loading,
    R Function(String message)? error,
    R Function(
      List<CallHistoryItem> items,
      bool hasMore,
      bool isLoadingMore,
    )? loaded,
    required R Function() orElse,
  }) {
    final self = this;
    if (self is CallHistoryLoading && loading != null) return loading();
    if (self is CallHistoryError && error != null) return error(self.message);
    if (self is CallHistoryLoaded && loaded != null) {
      return loaded(self.items, self.hasMore, self.isLoadingMore);
    }
    return orElse();
  }
}

// ==================== Controller ====================

/// Controller for call history with pagination
class CallHistoryController extends Notifier<CallHistoryState> {
  static const _pageSize = 20;

  @override
  CallHistoryState build() => const CallHistoryLoading();

  GetCallHistoryUseCase get _useCase => ref.read(getCallHistoryUseCaseProvider);

  /// Load initial page of call history
  Future<void> loadInitial() async {
    state = const CallHistoryLoading();

    try {
      final page = await _useCase.call(
        const GetCallHistoryParams(limit: _pageSize, offset: 0),
      );
      state = CallHistoryLoaded(page.items, page.hasMore, false);
    } catch (e) {
      state = CallHistoryError(e.toString());
    }
  }

  /// Load next page of call history
  Future<void> loadMore() async {
    final currentState = state;
    if (currentState is! CallHistoryLoaded) return;
    if (currentState.isLoadingMore || !currentState.hasMore) return;

    // Set loading more state
    state = CallHistoryLoaded(
      currentState.items,
      currentState.hasMore,
      true,
    );

    try {
      final page = await _useCase.call(
        GetCallHistoryParams(
          limit: _pageSize,
          offset: currentState.items.length,
        ),
      );

      state = CallHistoryLoaded(
        [...currentState.items, ...page.items],
        page.hasMore,
        false,
      );
    } catch (e) {
      // Revert to previous state on error
      state = CallHistoryLoaded(
        currentState.items,
        currentState.hasMore,
        false,
      );
    }
  }

  /// Refresh call history
  Future<void> refresh() => loadInitial();
}

/// Provider for call history controller
final callHistoryControllerProvider =
    NotifierProvider<CallHistoryController, CallHistoryState>(() {
  return CallHistoryController();
});
