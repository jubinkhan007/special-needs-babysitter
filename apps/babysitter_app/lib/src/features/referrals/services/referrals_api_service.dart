import 'package:dio/dio.dart';

import '../models/referral_generate_response.dart';
import '../models/referral_invite_response.dart';
import '../models/referral_item.dart';
import '../models/referral_stats.dart';
import '../models/referral_validate_response.dart';
import '../models/referrals_list_response.dart';

class ReferralsApiService {
  final Dio _dio;

  ReferralsApiService(this._dio);

  Future<ReferralGenerateResponse> generateReferralCode() async {
    final response = await _dio.post('/referrals/generate');
    final data = _unwrapMap(response.data);
    return ReferralGenerateResponse.fromJson(data);
  }

  Future<ReferralInviteResponse> inviteByEmail(String email) async {
    final response = await _dio.post(
      '/referrals/invite',
      data: {
        'email': email,
      },
    );
    final data = _unwrapMap(response.data);
    return ReferralInviteResponse.fromJson(data);
  }

  Future<ReferralsListResponse> getReferrals({
    String? status,
    int limit = 20,
    int offset = 0,
  }) async {
    final queryParameters = <String, dynamic>{
      'limit': limit,
      'offset': offset,
    };
    if (status != null && status.isNotEmpty) {
      queryParameters['status'] = status;
    }

    final response = await _dio.get(
      '/referrals',
      queryParameters: queryParameters,
    );
    final data = _unwrapMap(response.data);
    if (data.isEmpty) {
      return const ReferralsListResponse.empty();
    }
    return ReferralsListResponse.fromJson(data);
  }

  Future<ReferralStats> getStats() async {
    final response = await _dio.get('/referrals/stats');
    final data = _unwrapMap(response.data);
    return ReferralStats.fromJson(data);
  }

  Future<ReferralValidateResponse> validateReferralCode(String code) async {
    final response = await _dio.post(
      '/referrals/validate',
      data: {
        'code': code,
      },
    );
    final data = _unwrapMap(response.data);
    return ReferralValidateResponse.fromJson(data);
  }

  Future<ReferralItem> getReferralById(String referralId) async {
    final response = await _dio.get('/referrals/$referralId');
    final data = _unwrapReferral(response.data);
    return ReferralItem.fromJson(data);
  }

  Map<String, dynamic> _unwrapMap(dynamic data) {
    if (data is Map<String, dynamic>) {
      final nested = data['data'];
      if (nested is Map<String, dynamic>) {
        return nested;
      }
      return data;
    }
    return {};
  }

  Map<String, dynamic> _unwrapReferral(dynamic data) {
    if (data is Map<String, dynamic>) {
      final referral = data['referral'];
      if (referral is Map<String, dynamic>) {
        return referral;
      }
      final nested = data['data'];
      if (nested is Map<String, dynamic>) {
        return nested;
      }
      return data;
    }
    return {};
  }
}
