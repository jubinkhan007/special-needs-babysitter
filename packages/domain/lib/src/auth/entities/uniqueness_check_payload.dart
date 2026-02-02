/// Payload for checking email/phone uniqueness during sign-up
class UniquenessCheckPayload {
  final String email;
  final String phone;

  const UniquenessCheckPayload({
    required this.email,
    required this.phone,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'phone': phone,
      };
}
