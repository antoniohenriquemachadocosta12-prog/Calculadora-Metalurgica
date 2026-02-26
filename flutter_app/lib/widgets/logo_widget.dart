import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum LogoSize { sm, md, lg, xl }

class LogoWidget extends StatelessWidget {
  final LogoSize size;

  const LogoWidget({super.key, this.size = LogoSize.md});

  double get _size => switch (size) {
        LogoSize.sm => 28,
        LogoSize.md => 38,
        LogoSize.lg => 54,
        LogoSize.xl => 86,
      };

  double get _fontSize => switch (size) {
        LogoSize.sm => 16,
        LogoSize.md => 22,
        LogoSize.lg => 32,
        LogoSize.xl => 50,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _size,
      height: _size,
      decoration: const BoxDecoration(
        color: AppColors.navy,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          'M',
          style: TextStyle(
            color: AppColors.primary,
            fontSize: _fontSize,
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }
}
