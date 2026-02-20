// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sitter_account_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SitterAccountController)
final sitterAccountControllerProvider = SitterAccountControllerProvider._();

final class SitterAccountControllerProvider
    extends
        $AsyncNotifierProvider<SitterAccountController, SitterAccountState> {
  SitterAccountControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sitterAccountControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sitterAccountControllerHash();

  @$internal
  @override
  SitterAccountController create() => SitterAccountController();
}

String _$sitterAccountControllerHash() =>
    r'454365b69ff4604381c0faf1efbdd81580cce0a5';

abstract class _$SitterAccountController
    extends $AsyncNotifier<SitterAccountState> {
  FutureOr<SitterAccountState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<SitterAccountState>, SitterAccountState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SitterAccountState>, SitterAccountState>,
              AsyncValue<SitterAccountState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
