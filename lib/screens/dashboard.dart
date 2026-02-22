import 'package:flutter/material.dart';

import '../widgets/build_placeholder_card.dart';
import '../widgets/guided_configurator_card.dart';
import '../widgets/start_new_build_tile.dart';
import '../widgets/section_header.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(child: SizedBox(height: 16)),

        /// My Builds Header
        const SliverToBoxAdapter(
          child: SectionHeader(
            title: "My Builds",
            trailingText: "View All",
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 12)),

        /// Horizontal Builds
        SliverToBoxAdapter(
          child: SizedBox(
            height: 220,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: 2,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                return BuildPlaceholderCard(
                  title: index == 0 ? "Gaming Beast" : "Work Rig",
                  subtitle: index == 0
                      ? "RTX 4090 • i9-14900K"
                      : "RTX 4070 • R9 7900X",
                  price: index == 0 ? 3420 : 1850,
                  progress: index == 0 ? 1.0 : 0.85,
                  compatible: index == 0,
                );
              },
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 24)),

        /// Guided Configurator
        const SliverToBoxAdapter(
          child: GuidedConfiguratorCard(),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 16)),

        /// Start New Build
        const SliverToBoxAdapter(
          child: StartNewBuildTile(),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}