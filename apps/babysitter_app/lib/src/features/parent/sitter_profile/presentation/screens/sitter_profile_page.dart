import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/sitter_profile_providers.dart';
import 'sitter_profile_view.dart';

/// Wrapper page that loads sitter data via Riverpod and renders the profile view.
class SitterProfilePage extends ConsumerWidget {
  final String sitterId;

  const SitterProfilePage({
    super.key,
    required this.sitterId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sitterAsync = ref.watch(sitterProfileProvider(sitterId));

    return sitterAsync.when(
      loading: () => Scaffold(
        key: const Key('sitterProfilePage'),
        backgroundColor: const Color(0xFFF0F9FF),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF0F9FF),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => context.pop(),
          ),
          title: const Text(
            'Loading...',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) => Scaffold(
        key: const Key('sitterProfilePage'),
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: ${error.toString()}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(sitterProfileProvider(sitterId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      data: (sitter) => SitterProfileView(
        key: const Key('sitterProfilePage'),
        sitter: sitter,
      ),
    );
  }
}
