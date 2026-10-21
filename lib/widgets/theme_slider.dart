import 'package:amicons/amicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node/providers/theme_provider.dart';

class ThemeSlider extends ConsumerWidget {
  const ThemeSlider({super.key});

  Alignment _getAlignment(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return const Alignment(-1.0, 0.0); 
      case ThemeMode.light:
        return const Alignment(0.0, 0.0);
      case ThemeMode.dark:
        return const Alignment(1.0, 0.0);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMode = ref.watch(themeModeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 60,
      width: 350,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFE5E5EA),
        borderRadius: BorderRadius.circular(24),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tabWidth = (constraints.maxWidth) / 3;
          // stack for sliding ui
          return Stack(
            children: [
              AnimatedAlign(
                alignment: _getAlignment(currentMode),
                duration: const Duration(milliseconds: 750),
                curve: Curves.easeInOutCubicEmphasized,
                child: Container(
                  width: tabWidth,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
              // layer
              Row(
                children: [
                  _ThemeOption(
                    title: 'System',
                    icon: Amicons.remix_switch_fill,
                    isSelected: currentMode == ThemeMode.system,
                    onTap: () => ref.read(themeModeProvider.notifier).state =
                        ThemeMode.system,
                  ),
                  _ThemeOption(
                    title: 'Light',
                    icon: Icons.light_mode,
                    isSelected: currentMode == ThemeMode.light,
                    onTap: () => ref.read(themeModeProvider.notifier).state =
                        ThemeMode.light,
                  ),
                  _ThemeOption(
                    title: 'Dark',
                    icon: Icons.dark_mode,
                    isSelected: currentMode == ThemeMode.dark,
                    onTap: () => ref.read(themeModeProvider.notifier).state =
                        ThemeMode.dark,
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = Theme.of(context).colorScheme.primary;
    final inactiveColor = Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: 0.6);

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected ? activeColor : inactiveColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: isSelected ? activeColor : inactiveColor,
                ),
                const SizedBox(width: 4),
                Text(title),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
