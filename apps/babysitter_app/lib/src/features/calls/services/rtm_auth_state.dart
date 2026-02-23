import 'package:flutter_riverpod/legacy.dart';
import 'package:babysitter_app/src/packages/domain/domain.dart';

final rtmAuthStateProvider = StateProvider<ChatInitResult?>((ref) => null);
final rtmLoginUserIdProvider = StateProvider<String?>((ref) => null);
