import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_ui_tokens.dart';
import '../widgets/search_top_bar.dart';
import '../widgets/filter_row.dart';
import '../widgets/sitter_card.dart';
import '../../../../../routing/routes.dart';

import '../filter/filter_bottom_sheet.dart';
import '../providers/sitters_list_provider.dart';
import '../providers/search_filter_provider.dart';
import '../../../shared/providers/location_access_provider.dart';
import '../../../shared/widgets/location_access_banner.dart';
import '../../utils/location_helper.dart';

import 'package:babysitter_app/src/features/jobs/data/jobs_data_di.dart';
import 'package:babysitter_app/src/common_widgets/app_toast.dart';
import '../../../../sitters/presentation/saved/saved_sitters_controller.dart';

class SitterSearchResultsScreen extends ConsumerStatefulWidget {
  const SitterSearchResultsScreen({super.key});

  @override
  ConsumerState<SitterSearchResultsScreen> createState() =>
      _SitterSearchResultsScreenState();
}

class _SitterSearchResultsScreenState
    extends ConsumerState<SitterSearchResultsScreen> {
  // Track invited sitters to update UI state locally if needed
  final Set<String> _invitedSitterIds = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncLocationIfAllowed();
    });
  }

  Future<void> _inviteSitter(
      String jobId, String sitterId, String userId) async {
    try {
      // API expects userId
      await ref.read(jobsRepositoryProvider).inviteSitter(jobId, userId);
      if (mounted) {
        setState(() {
          // UI tracking uses sitterId
          _invitedSitterIds.add(sitterId);
        });
        AppToast.show(context,
          const SnackBar(content: Text('Sitter invited successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        String message = 'Failed to invite sitter.';
        if (e.toString().contains('posted jobs')) {
          message =
              'Job is still processing. Please wait a moment and try again.';
        } else {
          message = e.toString().replaceAll('Exception: ', '');
        }

        AppToast.show(context,
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  Future<void> _syncLocationIfAllowed() async {
    final status = await LocationHelper.getStatus();
    if (!mounted || status != LocationAccessStatus.available) {
      return;
    }
    final (latitude, longitude) =
        await LocationHelper.getLocation(requestPermission: false);
    if (!mounted) return;
    ref.read(searchFilterProvider).setLocation(latitude, longitude);
  }

  @override
  Widget build(BuildContext context) {
    // Check for jobId in extra or query params
    final Map<String, dynamic>? extra =
        GoRouterState.of(context).extra as Map<String, dynamic>?;
    final String? jobId = extra?['jobId'] ??
        GoRouterState.of(context).uri.queryParameters['jobId'];

    // Watch the filter state
    final filterController = ref.watch(searchFilterProvider);
    final filterState = filterController.value;

    // Watch saved sitters to update UI state
    final savedSittersAsync = ref.watch(savedSittersControllerProvider);
    final savedSitters = savedSittersAsync.value ?? [];

    // Watch the sitters list provider with current filters
    final asyncSitters = ref.watch(sittersListProvider(filterState));
    final locationStatusAsync = ref.watch(locationAccessStatusProvider);
    final locationStatus = locationStatusAsync.maybeWhen(
      data: (status) => status,
      orElse: () => null,
    );

    // Using standard standard density to avoid spacing shifts
    return Theme(
      data: Theme.of(context).copyWith(visualDensity: VisualDensity.standard),
      child: Scaffold(
        backgroundColor: AppUiTokens.scaffoldBackground,
        body: Column(
          children: [
            // Top Bar (Blue background)
            const SearchTopBar(),

            // Content
            Expanded(
              child: asyncSitters.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, stack) => Center(
                  child: Text('Error loading sitters: $error'),
                ),
                data: (sitters) => Column(
                  children: [
                    if (locationStatus != null &&
                        locationStatus != LocationAccessStatus.available)
                      Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 4),
                        child: LocationAccessBanner(
                          title: _locationTitle(locationStatus),
                          message: _locationMessage(locationStatus),
                          actionLabel: _locationActionLabel(locationStatus),
                          onAction: () {
                            _handleLocationAction(locationStatus);
                          },
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                    // Filter Row (White background)
                    FilterRow(
                      count: sitters.length,
                      onFilterTap: () {
                        FilterBottomSheet.show(context);
                      },
                    ),

                    // List of Cards
                    Expanded(
                      child: sitters.isEmpty
                          ? const Center(child: Text("No sitters found."))
                          : ListView.separated(
                              padding: EdgeInsets.only(
                                top: AppUiTokens.itemSpacing,
                                bottom: MediaQuery.of(context).padding.bottom +
                                    16, // Safe area + spacing
                              ),
                              itemCount: sitters.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                      height: AppUiTokens.itemSpacing),
                              itemBuilder: (context, index) {
                                final sitter = sitters[index];
                                final bool isInvited =
                                    _invitedSitterIds.contains(sitter.id);
                                final isBookmarked = savedSitters
                                    .any((s) => s.userId == sitter.userId);

                                return SitterCard(
                                  sitter: sitter,
                                  isBookmarked: isBookmarked,
                                  onBookmarkTap: () async {
                                    try {
                                      final isCurrentlyBookmarked = isBookmarked;
                                      await ref
                                          .read(
                                              savedSittersControllerProvider.notifier)
                                          .toggleBookmark(sitter.userId,
                                              isCurrentlySaved: isCurrentlyBookmarked,
                                              sitterItem: sitter);
                                      
                                      if (context.mounted) {
                                        AppToast.show(context,
                                          SnackBar(
                                            content: Text(isCurrentlyBookmarked
                                                ? 'Sitter removed from bookmarks'
                                                : 'Sitter bookmarked'),
                                            duration: const Duration(seconds: 2),
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      if (context.mounted) {
                                        AppToast.show(context,
                                          SnackBar(
                                            content: Text('Failed to update bookmark: $e'),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  onTap: () {
                                    // Navigate to profile using the ID
                                    context.push(
                                        Routes.sitterProfilePath(sitter.id));
                                  },
                                  onInvite: jobId != null
                                      ? () {
                                          if (!isInvited) {
                                            _inviteSitter(jobId, sitter.id,
                                                sitter.userId);
                                          }
                                        }
                                      : null,
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLocationAction(
    LocationAccessStatus status,
  ) async {
    switch (status) {
      case LocationAccessStatus.permissionDenied:
        await LocationHelper.requestPermission();
        break;
      case LocationAccessStatus.permissionDeniedForever:
        await LocationHelper.openAppSettings();
        break;
      case LocationAccessStatus.serviceDisabled:
        await LocationHelper.openLocationSettings();
        break;
      case LocationAccessStatus.available:
        return;
    }

    if (!mounted) return;
    ref.invalidate(locationAccessStatusProvider);

    final (latitude, longitude) =
        await LocationHelper.getLocation(requestPermission: false);
    if (!mounted) return;
    ref.read(searchFilterProvider).setLocation(latitude, longitude);
  }

  String _locationTitle(LocationAccessStatus status) {
    switch (status) {
      case LocationAccessStatus.serviceDisabled:
        return 'Turn on location services';
      case LocationAccessStatus.permissionDenied:
        return 'Enable location access';
      case LocationAccessStatus.permissionDeniedForever:
        return 'Location access blocked';
      case LocationAccessStatus.available:
        return '';
    }
  }

  String _locationMessage(LocationAccessStatus status) {
    switch (status) {
      case LocationAccessStatus.serviceDisabled:
        return 'Enable location services to see nearby sitters.';
      case LocationAccessStatus.permissionDenied:
        return 'Allow location access to show nearby sitters.';
      case LocationAccessStatus.permissionDeniedForever:
        return 'Open settings to allow location access.';
      case LocationAccessStatus.available:
        return '';
    }
  }

  String _locationActionLabel(LocationAccessStatus status) {
    switch (status) {
      case LocationAccessStatus.serviceDisabled:
        return 'Turn On';
      case LocationAccessStatus.permissionDenied:
        return 'Allow';
      case LocationAccessStatus.permissionDeniedForever:
        return 'Open Settings';
      case LocationAccessStatus.available:
        return '';
    }
  }
}
