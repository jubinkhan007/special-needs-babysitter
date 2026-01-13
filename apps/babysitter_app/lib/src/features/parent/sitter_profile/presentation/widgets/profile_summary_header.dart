// import 'package:flutter/material.dart';
// import "package:babysitter_app/src/features/parent/search/presentation/theme/app_ui_tokens.dart";
// import 'package:babysitter_app/src/features/parent/home/presentation/models/home_mock_models.dart';

// class ProfileSummaryHeader extends StatelessWidget {
//   final SitterModel sitter;

//   const ProfileSummaryHeader({super.key, required this.sitter});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: AppUiTokens.topBarBackground,
//       padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Avatar + Verified Badge
//           Stack(
//             clipBehavior: Clip.none, // Allow badge to overflow
//             children: [
//               Container(
//                 width: 84, // Slightly larger
//                 height: 84,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   border: Border.all(color: Colors.white, width: 2.5),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.05),
//                       blurRadius: 10,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: ClipOval(
//                   child: Image.asset(
//                     sitter.avatarUrl,
//                     fit: BoxFit.cover,
//                     errorBuilder: (_, __, ___) =>
//                         Container(color: Colors.grey[200]),
//                   ),
//                 ),
//               ),
//               if (sitter.isVerified)
//                 Positioned(
//                   bottom: 0,
//                   right: 0,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       shape: BoxShape.circle,
//                       border: Border.all(color: Colors.white, width: 2),
//                     ),
//                     child: const Icon(
//                       Icons.verified,
//                       color: AppUiTokens.verifiedBlue,
//                       size: 24,
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//           const SizedBox(height: 16),

//           // Name Row + Right Button
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               // Left: Name & Location
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       sitter.name,
//                       style: const TextStyle(
//                         fontSize: 26,
//                         fontWeight: FontWeight.w700,
//                         color: AppUiTokens.textPrimary,
//                         letterSpacing: -0.5,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Row(
//                       children: [
//                         const Icon(Icons.location_on,
//                             color: AppUiTokens.verifiedBlue, size: 16),
//                         const SizedBox(width: 4),
//                         Text(
//                           "2 Miles Away",
//                           style: const TextStyle(
//                             fontSize: 14,
//                             color: AppUiTokens.textSecondary,
//                             fontWeight: FontWeight.w400,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),

//               // Right: Rating Row -> Button
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   // Rating Row
//                   Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const Icon(Icons.star_rounded,
//                           color: AppUiTokens.starYellow, size: 20),
//                       const SizedBox(width: 4),
//                       Text(
//                         sitter.rating.toString(),
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w700,
//                           color: AppUiTokens.textPrimary,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 12),
//                   // Message Button
//                   ElevatedButton(
//                     onPressed: () {},
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(
//                           0xFF1D2939), // Dark Grey/Black matches Figma
//                       foregroundColor: Colors.white,
//                       elevation: 0,
//                       padding: const EdgeInsets.symmetric(horizontal: 20),
//                       fixedSize: const Size.fromHeight(40),
//                       shape: const StadiumBorder(),
//                       textStyle: const TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     child: const Text("Message"),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
