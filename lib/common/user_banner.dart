import 'package:finanza_collection_f/utils/colors.dart';
import 'package:flutter/cupertino.dart';

class UserBanner extends StatelessWidget {
  final String name;
  final String lan;

  const UserBanner({
    super.key,
    required this.name,
    required this.lan,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 25),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // const Text(
              //   'Name: ',
              //   style: TextStyle(
              //     fontSize: 15,
              //     color: AppColors.titleColor,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.titleColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'LAN: ',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.titleColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                lan,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
