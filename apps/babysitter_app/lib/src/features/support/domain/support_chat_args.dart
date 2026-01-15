class SupportChatArgs {
  final String ticketId; // Optional, for context
  final bool isInitialVerification; // To simulate State A vs B

  const SupportChatArgs({
    this.ticketId = '',
    this.isInitialVerification = true,
  });
}
