import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recyminer_app/helper/responsive_helper.dart';
import 'package:recyminer_app/helper/route_helper.dart';
import 'package:recyminer_app/provider/splash_provider.dart';
import 'package:recyminer_app/provider/theme_provider.dart';
import 'package:recyminer_app/utill/color_resources.dart';
import 'package:recyminer_app/utill/dimensions.dart';
import 'package:recyminer_app/utill/styles.dart';
import 'package:recyminer_app/view/screens/menu/widget/custom_drawer.dart';

class MenuButton extends StatelessWidget {
  final CustomDrawerController drawerController;
  final int index;
  final String icon;
  final String title;
  MenuButton(
      {@required this.drawerController,
      @required this.index,
      @required this.icon,
      @required this.title});

  @override
  Widget build(BuildContext context) {
    return Consumer<SplashProvider>(
      builder: (context, splash, child) {
        return ListTile(
          onTap: () {
            ResponsiveHelper.isMobilePhone()
                ? splash.setPageIndex(index)
                : SizedBox();
            if (ResponsiveHelper.isWeb() && index == 0) {
              Navigator.pushNamed(context, RouteHelper.menu);
            } else if (ResponsiveHelper.isWeb() && index == 1) {
              Navigator.pushNamed(context, RouteHelper.categorys);
            } else if (ResponsiveHelper.isWeb() && index == 2) {
              Navigator.pushNamed(context, RouteHelper.myOrder);
            } else if (ResponsiveHelper.isWeb() && index == 3) {
              Navigator.pushNamed(context, RouteHelper.address);
            } else if (ResponsiveHelper.isWeb() && index == 4) {
              Navigator.pushNamed(context, RouteHelper.chat);
            } else if (ResponsiveHelper.isWeb() && index == 5) {
              Navigator.pushNamed(context, RouteHelper.settings);
            } else if (ResponsiveHelper.isWeb() && index == 6) {
              Navigator.pushNamed(context, RouteHelper.getTermsRoute());
            } else if (ResponsiveHelper.isWeb() && index == 7) {
              Navigator.pushNamed(context, RouteHelper.getPolicyRoute());
            } else if (ResponsiveHelper.isWeb() && index == 8) {
              Navigator.pushNamed(context, RouteHelper.getAboutUsRoute());
            }
            drawerController.toggle();
          },
          selected: splash.pageIndex == index,
          selectedTileColor: Colors.black.withAlpha(30),
          leading: Image.asset(
            icon,
            color: Provider.of<ThemeProvider>(context).darkTheme
                ? ColorResources.getTextColor(context)
                : ResponsiveHelper.isDesktop(context)
                    ? ColorResources.getDarkColor(context)
                    : ColorResources.getBackgroundColor(context),
            width: 25,
            height: 25,
          ),
          title: Text(title,
              style: poppinsRegular.copyWith(
                fontSize: Dimensions.FONT_SIZE_LARGE,
                color: Provider.of<ThemeProvider>(context).darkTheme
                    ? ColorResources.getTextColor(context)
                    : ResponsiveHelper.isDesktop(context)
                        ? ColorResources.getDarkColor(context)
                        : ColorResources.getBackgroundColor(context),
              )),
        );
      },
    );
  }
}
