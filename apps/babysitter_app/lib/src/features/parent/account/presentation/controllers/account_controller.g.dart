// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AccountController)
final accountControllerProvider = AccountControllerProvider._();

final class AccountControllerProvider
    extends $AsyncNotifierProvider<AccountController, AccountState> {
  AccountControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accountControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accountControllerHash();

  @$internal
  @override
  AccountController create() => AccountController();
}

String _$accountControllerHash() => r'78c260fc577a5bf2a6d716a2d1dfe54b439f6386';

abstract class _$AccountController extends $AsyncNotifier<AccountState> {
  FutureOr<AccountState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AccountState>, AccountState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AccountState>, AccountState>,
              AsyncValue<AccountState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
