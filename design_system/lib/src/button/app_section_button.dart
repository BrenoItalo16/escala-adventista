import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:uicons/uicons.dart';

class AppSectionButton extends StatelessWidget {
  final VoidCallback onTap;

  const AppSectionButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: AppColors.inputBg,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Crie uma igreja',
              style: AppFont.titleM24BoldBalow,
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  UIcons.regularRounded.info,
                  size: 12,
                  color: TxtColors.support,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Antes de criar uma igreja no ',
                          style: AppFont.bodyS12XLight,
                        ),
                        TextSpan(
                          text: 'Escala Adventista',
                          style: AppFont.bodyS12Bold,
                        ),
                        TextSpan(
                          text:
                              ', consulte a diretoria da sua congregação para confirmar se já existe uma igreja criada em nosso app.',
                          style: AppFont.bodyS12XLight,
                        ),
                      ],
                    ),
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: AppIconButton(
                  width: 72,
                  height: 72,
                  radious: 16,
                  icon: UIcons.regularRounded.plus,
                  onTap: onTap,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
