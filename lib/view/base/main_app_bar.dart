import 'package:flutter/material.dart';
import 'package:recyminer_app/helper/route_helper.dart';
import 'package:recyminer_app/utill/app_constants.dart';
import 'package:recyminer_app/utill/dimensions.dart';
import 'package:recyminer_app/utill/images.dart';
import 'package:recyminer_app/utill/styles.dart';
import 'package:recyminer_app/view/base/menu_bar.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          color: Theme.of(context).accentColor,
          width: 1170.0,
          height: 45.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                    onTap: () => Navigator.pushNamed(context, RouteHelper.menu),
                    child: Row(
                      children: [
                        Image.asset(Images.app_logo,
                            color: Theme.of(context).primaryColor),
                        SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                        Text(AppConstants.APP_NAME,
                            style: poppinsMedium.copyWith(
                                color: Theme.of(context).primaryColor)),
                      ],
                    )),
              ),
              MenuBar(),
            ],
          )),
    );
  }

  @override
  Size get preferredSize => Size(double.maxFinite, 50);
}
