import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/sitter_list_data.dart';
import '../theme/app_ui_tokens.dart';
import '../widgets/search_top_bar.dart';
import '../widgets/filter_row.dart';
import '../widgets/sitter_card.dart';
import '../../../../../routing/routes.dart';

class SitterSearchResultsScreen extends StatelessWidget {
  const SitterSearchResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Using standard standard density to avoid spacing shifts
    return Theme(
      data: Theme.of(context).copyWith(visualDensity: VisualDensity.standard),
      child: Scaffold(
        backgroundColor: AppUiTokens.scaffoldBackground,
        body: Column(
          children: [
            // Top Bar (Blue background)
            const SearchTopBar(),

            // Filter Row (White background)
            FilterRow(count: SitterListData.sitters.length),

            // List of Cards
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.only(
                  top: AppUiTokens.itemSpacing,
                  bottom: MediaQuery.of(context).padding.bottom +
                      16, // Safe area + spacing
                ),
                itemCount: SitterListData.sitters.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: AppUiTokens.itemSpacing),
                itemBuilder: (context, index) {
                  final sitter = SitterListData.sitters[index];
                  return SitterCard(
                    sitter: sitter,
                    onTap: () {
                      // Navigate to profile using the ID
                      context.push(Routes.sitterProfilePath(sitter.id));
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
