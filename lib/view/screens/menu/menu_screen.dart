import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recyminer_app/helper/responsive_helper.dart';
import 'package:recyminer_app/helper/route_helper.dart';
import 'package:recyminer_app/localization/language_constrants.dart';
import 'package:recyminer_app/provider/auth_provider.dart';
import 'package:recyminer_app/provider/profile_provider.dart';
import 'package:recyminer_app/provider/splash_provider.dart';
import 'package:recyminer_app/provider/theme_provider.dart';
import 'package:recyminer_app/utill/color_resources.dart';
import 'package:recyminer_app/utill/dimensions.dart';
import 'package:recyminer_app/utill/images.dart';
import 'package:recyminer_app/utill/styles.dart';
import 'package:recyminer_app/view/base/main_app_bar.dart';
import 'package:recyminer_app/view/screens/menu/main_screen.dart';
import 'package:recyminer_app/view/screens/menu/widget/custom_drawer.dart';
import 'package:recyminer_app/view/screens/menu/widget/menu_button.dart';
import 'package:recyminer_app/view/screens/menu/widget/sign_out_confirmation_dialog.dart';
import 'package:recyminer_app/view/screens/profile/profile_screen.dart';

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final CustomDrawerController _drawerController = CustomDrawerController();

  @override
  Widget build(BuildContext context) {
    return CustomDrawer(
      controller: _drawerController,
      menuScreen: MenuWidget(drawerController: _drawerController),
      mainScreen: MainScreen(drawerController: _drawerController),
      showShadow: false,
      angle: 0.0,
      borderRadius: 30,
      slideWidth: MediaQuery.of(context).size.width *
          (CustomDrawer.isRTL(context) ? 0.45 : 0.70),
    );
  }
}

class MenuWidget extends StatelessWidget {
  final CustomDrawerController drawerController;

  MenuWidget({this.drawerController});

  @override
  Widget build(BuildContext context) {
    final bool _isLoggedIn =
        Provider.of<AuthProvider>(context, listen: false).isLoggedIn();

    return WillPopScope(
      onWillPop: () async {
        if (drawerController.isOpen()) {
          drawerController.toggle();
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: Provider.of<ThemeProvider>(context).darkTheme
            ? ColorResources.getBackgroundColor(context)
            : ResponsiveHelper.isDesktop(context)
                ? ColorResources.getBackgroundColor(context)
                : Theme.of(context).primaryColor,
        appBar: ResponsiveHelper.isDesktop(context) ? MainAppBar() : null,
        body: SafeArea(
          child: Scrollbar(
            child: SingleChildScrollView(
              child: Center(
                child: Container(
                  width: 1170,
                  child: Consumer<SplashProvider>(
                    builder: (context, splash, child) {
                      return Column(children: [
                        !ResponsiveHelper.isDesktop(context)
                            ? Align(
                                alignment: Alignment.centerLeft,
                                child: IconButton(
                                  icon: Icon(Icons.close,
                                      color: Provider.of<ThemeProvider>(context)
                                              .darkTheme
                                          ? ColorResources.getTextColor(context)
                                          : ResponsiveHelper.isDesktop(context)
                                              ? ColorResources
                                                  .getBackgroundColor(context)
                                              : ColorResources
                                                  .getBackgroundColor(context)),
                                  onPressed: () => drawerController.toggle(),
                                ),
                              )
                            : SizedBox(),
                        Consumer<ProfileProvider>(
                          builder: (context, profileProvider, child) => Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        RouteHelper.profile,
                                        arguments: ProfileScreen());
                                  },
                                  leading: ClipOval(
                                    child: _isLoggedIn
                                        ? FadeInImage.assetNetwork(
                                            placeholder: Images.placeholder,
                                            image:
                                                '${Provider.of<SplashProvider>(context, listen: false).baseUrls.customerImageUrl}/'
                                                '${profileProvider.userInfoModel != null ? profileProvider.userInfoModel.image : ''}',
                                            height: 50,
                                            width: 50,
                                            fit: BoxFit.cover,
                                            imageErrorBuilder: (c, o, s) =>
                                                Image.asset(Images.placeholder,
                                                    height: 50,
                                                    width: 50,
                                                    fit: BoxFit.cover),
                                          )
                                        : Image.asset(Images.placeholder,
                                            height: 50,
                                            width: 50,
                                            fit: BoxFit.cover),
                                  ),
                                  title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _isLoggedIn
                                            ? profileProvider.userInfoModel !=
                                                    null
                                                ? Text(
                                                    '${profileProvider.userInfoModel.fName ?? ''} ${profileProvider.userInfoModel.lName ?? ''}',
                                                    style:
                                                        poppinsRegular.copyWith(
                                                      color: Provider.of<
                                                                      ThemeProvider>(
                                                                  context)
                                                              .darkTheme
                                                          ? ColorResources.getTextColor(
                                                              context)
                                                          : ResponsiveHelper
                                                                  .isDesktop(
                                                                      context)
                                                              ? ColorResources
                                                                  .getDarkColor(
                                                                      context)
                                                              : ColorResources
                                                                  .getBackgroundColor(
                                                                      context),
                                                    ),
                                                  )
                                                : Container(
                                                    height: 10,
                                                    width: 150,
                                                    color: ResponsiveHelper
                                                            .isDesktop(context)
                                                        ? ColorResources
                                                            .getDarkColor(
                                                                context)
                                                        : ColorResources
                                                            .getBackgroundColor(
                                                                context))
                                            : Text(
                                                getTranslated('guest', context),
                                                style: poppinsRegular.copyWith(
                                                  color: Provider.of<
                                                                  ThemeProvider>(
                                                              context)
                                                          .darkTheme
                                                      ? ColorResources
                                                          .getTextColor(context)
                                                      : ResponsiveHelper
                                                              .isDesktop(
                                                                  context)
                                                          ? ColorResources
                                                              .getDarkColor(
                                                                  context)
                                                          : ColorResources
                                                              .getBackgroundColor(
                                                                  context),
                                                ),
                                              ),
                                        _isLoggedIn
                                            ? profileProvider.userInfoModel !=
                                                    null
                                                ? Text(
                                                    '${profileProvider.userInfoModel.phone ?? ''}',
                                                    style:
                                                        poppinsRegular.copyWith(
                                                      color: Provider.of<
                                                                      ThemeProvider>(
                                                                  context)
                                                              .darkTheme
                                                          ? ColorResources.getTextColor(
                                                              context)
                                                          : ResponsiveHelper
                                                                  .isDesktop(
                                                                      context)
                                                              ? ColorResources
                                                                  .getDarkColor(
                                                                      context)
                                                              : ColorResources
                                                                  .getBackgroundColor(
                                                                      context),
                                                    ))
                                                : Container(
                                                    height: 10,
                                                    width: 100,
                                                    color: ResponsiveHelper
                                                            .isDesktop(context)
                                                        ? ColorResources
                                                            .getDarkColor(
                                                                context)
                                                        : ColorResources
                                                            .getBackgroundColor(
                                                                context))
                                            : Text(
                                                '0123456789',
                                                style: poppinsRegular.copyWith(
                                                  color: Provider.of<
                                                                  ThemeProvider>(
                                                              context)
                                                          .darkTheme
                                                      ? ColorResources
                                                          .getTextColor(context)
                                                      : ResponsiveHelper
                                                              .isDesktop(
                                                                  context)
                                                          ? ColorResources
                                                              .getDarkColor(
                                                                  context)
                                                          : ColorResources
                                                              .getBackgroundColor(
                                                                  context),
                                                ),
                                              ),
                                      ]),
                                ),
                              ),
//                              IconButton(
//                                icon: Icon(Icons.notifications,
//                                    color: Provider.of<ThemeProvider>(context).darkTheme
//                                        ? ColorResources.getTextColor(context)
//                                        : ResponsiveHelper.isDesktop(context)? ColorResources.getDarkColor(context):  ColorResources.getBackgroundColor(context)),
//                                onPressed: () {
//                                  Navigator.pushNamed(context, RouteHelper.notification, arguments: NotificationScreen());
//                                },
//                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 50),
                        ResponsiveHelper.isDesktop(context)
                            ? SizedBox()
                            : MenuButton(
                                drawerController: drawerController,
                                index: 0,
                                icon: Images.home,
                                title: getTranslated('home', context)),
                        ResponsiveHelper.isDesktop(context)
                            ? SizedBox()
                            : MenuButton(
                                drawerController: drawerController,
                                index: 1,
                                icon: Images.list,
                                title: getTranslated('call_miner', context)),
                        //MenuButton(drawerController: drawerController, index: 1, icon: Images.list, title: getTranslated('all_categories', context)),
                        //MenuButton(drawerController: drawerController, index: 2, icon: Images.order_bag, title: getTranslated('shopping_bag', context)),
                        MenuButton(
                            drawerController: drawerController,
                            index: 2,
                            icon: Images.order_list,
                            title: getTranslated('my_order', context)),
                        MenuButton(
                            drawerController: drawerController,
                            index: 3,
                            icon: Images.location,
                            title: getTranslated('address', context)),
                        //MenuButton(drawerController: drawerController, index: 5, icon: Images.coupon, title: getTranslated('coupon', context)),
                        MenuButton(
                            drawerController: drawerController,
                            index: 4,
                            icon: Images.chat,
                            title: getTranslated('live_chat', context)),
                        MenuButton(
                            drawerController: drawerController,
                            index: 5,
                            icon: Images.settings,
                            title: getTranslated('settings', context)),
                        MenuButton(
                          drawerController: drawerController,
                          index: 6,
                          icon: Images.terms_and_conditions,
                          title: getTranslated('terms_and_condition', context),
                        ),
                        MenuButton(
                            drawerController: drawerController,
                            index: 7,
                            icon: Images.privacy,
                            title: getTranslated('privacy_policy', context)),
                        MenuButton(
                            drawerController: drawerController,
                            index: 8,
                            icon: Images.about_us,
                            title: getTranslated('about_us', context)),
                        ListTile(
                          onTap: () {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) =>
                                    SignOutConfirmationDialog());
                          },
                          leading: Image.asset(
                            Images.log_out,
                            color: Provider.of<ThemeProvider>(context).darkTheme
                                ? ColorResources.getTextColor(context)
                                : ResponsiveHelper.isDesktop(context)
                                    ? ColorResources.getDarkColor(context)
                                    : ColorResources.getBackgroundColor(
                                        context),
                            width: 25,
                            height: 25,
                          ),
                          title: Text(
                            getTranslated('log_out', context),
                            style: poppinsRegular.copyWith(
                                fontSize: Dimensions.FONT_SIZE_LARGE,
                                color: Provider.of<ThemeProvider>(context)
                                        .darkTheme
                                    ? ColorResources.getTextColor(context)
                                    : ResponsiveHelper.isDesktop(context)
                                        ? ColorResources.getDarkColor(context)
                                        : ColorResources.getBackgroundColor(
                                            context)),
                          ),
                        ),
                      ]);
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
