import 'package:flutter_riverpod/legacy.dart';
import 'package:domain/domain.dart';

final rtmAuthStateProvider = StateProvider<ChatInitResult?>((ref) => null);
final rtmLoginUserIdProvider = StateProvider<String?>((ref) => null);
