import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:khazana_app/core/theme/app_theme.dart';
import 'package:khazana_app/features/widgets/Text/text_widget.dart';

class NoDataFoundWidget extends StatelessWidget {
  final String? message;
  final Function()? btnRetry;
  final String? subDesc;
  final String? imagePath;
  final bool isDarkTheme;

  const NoDataFoundWidget({
    super.key,
    this.message,
    this.subDesc,
    this.btnRetry,
    this.imagePath,
    this.isDarkTheme = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (imagePath != null) ...[SvgPicture.asset(imagePath!)],
          const SizedBox(height: 27),
          Text(
            message ?? 'No Data Found.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
          const SizedBox(height: 5),
          if (subDesc != null) ...[
            TextWidget(
              subDesc,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: AppTheme.darkPrimaryColor),
            ),
          ],
          const SizedBox(height: 10),
          // if (btnRetry != null) ...[
          //   OutlinedButtonWidget(onPressed: btnRetry, text: 'Try Again'),
          // ],
        ],
      ),
    );
  }
}

class LoadingScreenWidget extends StatelessWidget {
  const LoadingScreenWidget({
    super.key,
    this.width,
    this.height,
    this.color,
    this.strokeWidth,
  });

  final double? width;
  final double? height;
  final Color? color;
  final double? strokeWidth;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: width ?? 40,
            height: height ?? 40,
            child: CircularProgressIndicator(
              strokeWidth: strokeWidth ?? 4,
              valueColor: AlwaysStoppedAnimation<Color>(
                color ?? AppTheme.blueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
