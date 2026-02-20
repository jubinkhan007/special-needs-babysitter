import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:auth/auth.dart';

import '../../models/referral_generate_response.dart';
import '../../models/referral_stats.dart';
import '../../models/referrals_list_response.dart';
import '../../services/referrals_api_service.dart';

final referralsApiServiceProvider = Provider<ReferralsApiService>((ref) {
  final dio = ref.watch(authDioProvider);
  return ReferralsApiService(dio);
});

final referralGenerateProvider =
    FutureProvider.autoDispose<ReferralGenerateResponse>((ref) async {
  final service = ref.watch(referralsApiServiceProvider);
  return service.generateReferralCode();
});

final rewardedReferralsProvider =
    FutureProvider.autoDispose<ReferralsListResponse>((ref) async {
  final service = ref.watch(referralsApiServiceProvider);
  return service.getReferrals(status: 'rewarded', limit: 20, offset: 0);
});

final referralStatsProvider =
    FutureProvider.autoDispose<ReferralStats>((ref) async {
  final service = ref.watch(referralsApiServiceProvider);
  return service.getStats();
});
