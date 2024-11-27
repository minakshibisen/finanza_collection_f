import 'package:finanza_collection_f/utils/colors.dart';
import 'package:flutter/cupertino.dart';

class UserBanner extends StatelessWidget {
  final String name;
  final String lan;

  const UserBanner({
    super.key, required this.name, required this.lan,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Name: ',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.titleColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              name,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.titleColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'LAN: ',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.titleColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              lan,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}