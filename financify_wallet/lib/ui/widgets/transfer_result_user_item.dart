import 'package:financify_wallet/models/user_model.dart';
import 'package:financify_wallet/shared/theme.dart';
import 'package:flutter/material.dart';

class TransferResultUserItem extends StatelessWidget {
  final UserModel user;
  final bool isSelected;

  const TransferResultUserItem({
    super.key,
    required this.user,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 155,
      height: 175,
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 22,
      ),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? blueColor : whiteColor,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: (user.profilePicture != null &&
                        user.profilePicture!.isNotEmpty)
                    ? NetworkImage(user.profilePicture!)
                    : const AssetImage('assets/img_profile.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: user.verified == 1
                ? Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: whiteColor,
                      ),
                      child: Icon(
                        Icons.check_circle,
                        color: greenColor,
                        size: 14,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(
            height: 13,
          ),
          Flexible(
            child: Text(
              user.name.toString(),
              style: blackTextStyle.copyWith(
                fontSize: 16,
                fontWeight: medium,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 2,
          ),
          Flexible(
            child: Text(
              '@${user.username}',
              style: greyTextStyle.copyWith(
                fontSize: 12,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
