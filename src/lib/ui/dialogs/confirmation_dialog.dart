import 'package:flutter/material.dart';
import 'package:my_app/core/constants/app_colors.dart';
import 'package:my_app/core/constants/app_text_styles.dart';
import 'package:my_app/widgets/custom_button.dart';
import 'package:stacked_services/stacked_services.dart';

class ConfirmationDialog extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const ConfirmationDialog({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (request.title != null) ...[
              Text(
                request.title!,
                style: AppTextStyles.h5,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
            ],
            if (request.description != null) ...[
              Text(
                request.description!,
                style: AppTextStyles.body1.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
            ],
            Row(
              children: [
                if (request.cancelTitle != null) ...[
                  Expanded(
                    child: CustomButton(
                      text: request.cancelTitle!,
                      onPressed: () =>
                          completer(DialogResponse(confirmed: false)),
                      type: ButtonType.outline,
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
                Expanded(
                  child: CustomButton(
                    text: request.mainButtonTitle ?? 'OK',
                    onPressed: () => completer(DialogResponse(confirmed: true)),
                    type: request.cancelTitle != null
                        ? ButtonType.primary
                        : ButtonType.secondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
