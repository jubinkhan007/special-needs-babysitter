import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/call_history_item.dart';
import '../../domain/entities/call_enums.dart';
import '../providers/call_history_provider.dart';

/// Screen showing call history with pagination
class CallHistoryScreen extends ConsumerStatefulWidget {
  const CallHistoryScreen({super.key});

  @override
  ConsumerState<CallHistoryScreen> createState() => _CallHistoryScreenState();
}

class _CallHistoryScreenState extends ConsumerState<CallHistoryScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(callHistoryControllerProvider.notifier).loadInitial();
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(callHistoryControllerProvider.notifier).loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final historyState = ref.watch(callHistoryControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Call History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                ref.read(callHistoryControllerProvider.notifier).refresh(),
          ),
        ],
      ),
      body: historyState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (message) => Center(
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48.sp,
                  color: Colors.red[300],
                ),
                SizedBox(height: 16.h),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red[300]),
                ),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: () => ref
                      .read(callHistoryControllerProvider.notifier)
                      .loadInitial(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        loaded: (items, hasMore, isLoadingMore) {
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.call_outlined,
                    size: 64.sp,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'No call history',
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Your calls will appear here',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () =>
                ref.read(callHistoryControllerProvider.notifier).refresh(),
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(vertical: 8.h),
              itemCount: items.length + (hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= items.length) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: const CircularProgressIndicator(),
                    ),
                  );
                }

                return _CallHistoryTile(
                  item: items[index],
                  onTap: () => _onCallTap(items[index]),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _onCallTap(CallHistoryItem item) {
    // Show call details or initiate new call
    showModalBottomSheet(
      context: context,
      builder: (context) => _CallDetailsSheet(item: item),
    );
  }
}

class _CallHistoryTile extends StatelessWidget {
  final CallHistoryItem item;
  final VoidCallback? onTap;

  const _CallHistoryTile({
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isMissed = item.wasMissed;
    final isDeclined = item.status == CallStatus.declined;
    final iconColor = (isMissed || isDeclined) ? Colors.red : Colors.green;
    final isOutgoing = item.isInitiator;

    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        radius: 24.r,
        backgroundImage: item.otherParticipant.avatar != null
            ? NetworkImage(item.otherParticipant.avatar!)
            : null,
        backgroundColor: Colors.grey[300],
        child: item.otherParticipant.avatar == null
            ? Text(
                item.otherParticipant.name.isNotEmpty
                    ? item.otherParticipant.name[0].toUpperCase()
                    : '?',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              )
            : null,
      ),
      title: Text(
        item.otherParticipant.name,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: isMissed ? Colors.red : null,
        ),
      ),
      subtitle: Row(
        children: [
          Icon(
            isOutgoing ? Icons.call_made : Icons.call_received,
            size: 14.sp,
            color: iconColor,
          ),
          SizedBox(width: 4.w),
          Text(
            _formatCallInfo(item),
            style: TextStyle(
              fontSize: 12.sp,
              color: (isMissed || isDeclined) ? Colors.red : null,
            ),
          ),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            _formatDate(item.createdAt),
            style: TextStyle(fontSize: 12.sp, color: Colors.grey),
          ),
          SizedBox(height: 4.h),
          Icon(
            item.callType == CallType.video
                ? Icons.videocam_outlined
                : Icons.call_outlined,
            size: 18.sp,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  String _formatCallInfo(CallHistoryItem item) {
    if (item.wasMissed) {
      return item.isInitiator ? 'No answer' : 'Missed';
    }
    if (item.status == CallStatus.declined) {
      return 'Declined';
    }
    return item.durationFormatted;
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final callDate = DateTime(date.year, date.month, date.day);

    if (callDate == today) {
      return DateFormat.jm().format(date);
    } else if (callDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else if (now.difference(date).inDays < 7) {
      return DateFormat.E().format(date); // Mon, Tue, etc.
    } else {
      return DateFormat.MMMd().format(date);
    }
  }
}

class _CallDetailsSheet extends StatelessWidget {
  final CallHistoryItem item;

  const _CallDetailsSheet({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 24.h),

          // Avatar and name
          CircleAvatar(
            radius: 40.r,
            backgroundImage: item.otherParticipant.avatar != null
                ? NetworkImage(item.otherParticipant.avatar!)
                : null,
            backgroundColor: Colors.grey[300],
            child: item.otherParticipant.avatar == null
                ? Text(
                    item.otherParticipant.name.isNotEmpty
                        ? item.otherParticipant.name[0].toUpperCase()
                        : '?',
                    style: TextStyle(fontSize: 32.sp),
                  )
                : null,
          ),
          SizedBox(height: 16.h),
          Text(
            item.otherParticipant.name,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            _getCallDescription(),
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 24.h),

          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(
                icon: Icons.call,
                label: 'Audio Call',
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to outgoing call screen
                },
              ),
              _buildActionButton(
                icon: Icons.videocam,
                label: 'Video Call',
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to outgoing call screen with video
                },
              ),
              _buildActionButton(
                icon: Icons.message,
                label: 'Message',
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to messages
                },
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 16.h),
        ],
      ),
    );
  }

  String _getCallDescription() {
    final typeStr = item.callType == CallType.video ? 'Video call' : 'Audio call';
    final directionStr = item.isInitiator ? 'Outgoing' : 'Incoming';
    final statusStr = item.wasMissed
        ? '(Missed)'
        : item.status == CallStatus.declined
            ? '(Declined)'
            : item.durationFormatted != '--:--'
                ? '(${item.durationFormatted})'
                : '';

    return '$directionStr $typeStr $statusStr';
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.blue),
            ),
            SizedBox(height: 8.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
