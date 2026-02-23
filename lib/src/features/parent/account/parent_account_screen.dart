import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'presentation/account_screen.dart';

/// Parent account screen wrapper
/// This file is kept to maintain existing route imports if any,
/// but delegates to the new AccountScreen implementation.
class ParentAccountScreen extends ConsumerWidget {
  const ParentAccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const AccountScreen();
  }
}
