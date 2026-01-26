import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:core/core.dart';

import 'src/routing/app_router.dart';
import 'src/features/sitter/bookings/presentation/providers/session_tracking_providers.dart';

/// Main application widget
class BabysitterApp extends ConsumerStatefulWidget {
  const BabysitterApp({super.key});

  @override
  ConsumerState<BabysitterApp> createState() => _BabysitterAppState();
}

class _BabysitterAppState extends ConsumerState<BabysitterApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(sessionTrackingControllerProvider.notifier).restoreSession();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    Future.microtask(() {
      ref
          .read(sessionTrackingControllerProvider.notifier)
          .handleAppLifecycle(state);
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);

    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: Constants.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          routerConfig: router,
        );
      },
    );
  }
}
