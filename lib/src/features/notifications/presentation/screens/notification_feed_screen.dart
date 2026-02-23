import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:babysitter_app/src/packages/core/core.dart';

import 'package:babysitter_app/src/features/notifications/models/notification_item.dart';
import 'package:babysitter_app/src/features/notifications/presentation/providers/notification_providers.dart';
import 'package:babysitter_app/src/features/notifications/presentation/widgets/notification_tile.dart';

/// Filter chip options for notification categories.
enum _FilterOption {
  all('All'),
  jobs('Jobs'),
  payments('Payments'),
  rewards('Rewards');

  final String label;
  const _FilterOption(this.label);
}

class NotificationFeedScreen extends ConsumerStatefulWidget {
  const NotificationFeedScreen({super.key});

  @override
  ConsumerState<NotificationFeedScreen> createState() =>
      _NotificationFeedScreenState();
}

class _NotificationFeedScreenState
    extends ConsumerState<NotificationFeedScreen> {
  _FilterOption _selectedFilter = _FilterOption.all;

  @override
  Widget build(BuildContext context) {
    final notificationsAsync = ref.watch(notificationsListProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        title: Text(
          'Notifications',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            fontFamily: 'Inter',
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(notificationsListProvider.notifier).markAllAsRead();
            },
            child: Text(
              'Mark all read',
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Category filter chips
          SizedBox(
            height: 48.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              itemCount: _FilterOption.values.length,
              separatorBuilder: (_, _) => SizedBox(width: 8.w),
              itemBuilder: (context, index) {
                final filter = _FilterOption.values[index];
                final isSelected = _selectedFilter == filter;
                return GestureDetector(
                  onTap: () => setState(() => _selectedFilter = filter),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.neutral10,
                      ),
                    ),
                    child: Text(
                      filter.label,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: isSelected
                            ? Colors.white
                            : AppColors.textSecondary,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Notification list
          Expanded(
            child: RefreshIndicator(
              onRefresh: () =>
                  ref.read(notificationsListProvider.notifier).refresh(),
              child: notificationsAsync.when(
                data: (notifications) {
                  final filtered = _applyFilter(notifications);
                  if (filtered.isEmpty) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(height: 120.h),
                        Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.notifications_none_outlined,
                                size: 48.w,
                                color: AppColors.textSecondary.withAlpha(100),
                              ),
                              SizedBox(height: 12.h),
                              Text(
                                'No notifications yet',
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: AppColors.textSecondary,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }

                  final grouped = _groupByTime(filtered);
                  return ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.only(
                      bottom: 20.h + MediaQuery.of(context).padding.bottom,
                    ),
                    itemCount: grouped.length,
                    itemBuilder: (context, index) {
                      final entry = grouped[index];
                      if (entry is String) {
                        // Section header
                        return Padding(
                          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 4.h),
                          child: Text(
                            entry,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                              fontFamily: 'Inter',
                              letterSpacing: 0.5,
                            ),
                          ),
                        );
                      }
                      final item = entry as NotificationItem;
                      return NotificationTile(
                        notification: item,
                        onTap: () => _onNotificationTap(item),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(height: 120.h),
                    Center(
                      child: Text(
                        'Error loading notifications.\nPull down to retry.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red, fontSize: 13.sp),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<NotificationItem> _applyFilter(List<NotificationItem> notifications) {
    if (_selectedFilter == _FilterOption.all) return notifications;
    final category = switch (_selectedFilter) {
      _FilterOption.jobs => NotificationCategory.jobs,
      _FilterOption.payments => NotificationCategory.payments,
      _FilterOption.rewards => NotificationCategory.rewards,
      _ => null,
    };
    if (category == null) return notifications;
    return notifications.where((n) => n.category == category).toList();
  }

  /// Groups notifications by Today / Yesterday / Earlier,
  /// returning a mixed list of String (headers) and NotificationItem.
  List<Object> _groupByTime(List<NotificationItem> notifications) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final todayItems = <NotificationItem>[];
    final yesterdayItems = <NotificationItem>[];
    final earlierItems = <NotificationItem>[];

    for (final item in notifications) {
      final itemDate = DateTime(
        item.createdAt.year,
        item.createdAt.month,
        item.createdAt.day,
      );
      if (itemDate == today) {
        todayItems.add(item);
      } else if (itemDate == yesterday) {
        yesterdayItems.add(item);
      } else {
        earlierItems.add(item);
      }
    }

    final result = <Object>[];
    if (todayItems.isNotEmpty) {
      result.add('TODAY');
      result.addAll(todayItems);
    }
    if (yesterdayItems.isNotEmpty) {
      result.add('YESTERDAY');
      result.addAll(yesterdayItems);
    }
    if (earlierItems.isNotEmpty) {
      result.add('EARLIER');
      result.addAll(earlierItems);
    }
    return result;
  }

  void _onNotificationTap(NotificationItem item) {
    // Mark as read
    if (item.isUnread) {
      ref.read(notificationsListProvider.notifier).markAsRead(item.id);
    }

    // TODO: Navigate to relevant screen based on item.type / item.data
    // For now, we just mark as read. Deep-linking can be added per type.
  }
}
