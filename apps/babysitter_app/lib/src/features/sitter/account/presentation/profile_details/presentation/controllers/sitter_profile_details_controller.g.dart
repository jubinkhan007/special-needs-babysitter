// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sitter_profile_details_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SitterProfileDetailsController)
final sitterProfileDetailsControllerProvider =
    SitterProfileDetailsControllerProvider._();

final class SitterProfileDetailsControllerProvider
    extends
        $AsyncNotifierProvider<
          SitterProfileDetailsController,
          SitterMeProfileDto
        > {
  SitterProfileDetailsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sitterProfileDetailsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sitterProfileDetailsControllerHash();

  @$internal
  @override
  SitterProfileDetailsController create() => SitterProfileDetailsController();
}

String _$sitterProfileDetailsControllerHash() =>
    r'868a492fccf0dae6d247c982394c4751762b658f';

abstract class _$SitterProfileDetailsController
    extends $AsyncNotifier<SitterMeProfileDto> {
  FutureOr<SitterMeProfileDto> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<SitterMeProfileDto>, SitterMeProfileDto>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SitterMeProfileDto>, SitterMeProfileDto>,
              AsyncValue<SitterMeProfileDto>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
