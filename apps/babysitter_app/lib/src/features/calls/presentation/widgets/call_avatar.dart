import 'package:flutter/material.dart';
import '../../../../theme/app_tokens.dart';

class CallAvatar extends StatelessWidget {
  final String? avatarUrl;
  final double size;

  const CallAvatar({
    super.key,
    required this.avatarUrl,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[200], // Placeholder bg
        image: avatarUrl != null
            ? DecorationImage(
                image: NetworkImage(avatarUrl!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      alignment: Alignment.center,
      child: avatarUrl == null
          ? Icon(
              Icons.person,
              size: size * 0.5,
              color: AppTokens.iconGrey,
            )
          : null,
    );
  }
}
