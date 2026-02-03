/// Agora configuration from backend
class CallConfig {
  final String appId;

  const CallConfig({required this.appId});

  bool get isValid => appId.isNotEmpty;
}
