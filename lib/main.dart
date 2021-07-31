import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:recyminer_app/helper/responsive_helper.dart';
import 'package:recyminer_app/helper/route_helper.dart';
import 'package:recyminer_app/provider/auth_provider.dart';
import 'package:recyminer_app/provider/banner_provider.dart';
import 'package:recyminer_app/provider/cart_provider.dart';
import 'package:recyminer_app/provider/category_provider.dart';
import 'package:recyminer_app/provider/chat_provider.dart';
import 'package:recyminer_app/provider/coupon_provider.dart';
import 'package:recyminer_app/provider/ibm_cloud_provider.dart';
import 'package:recyminer_app/provider/localization_provider.dart';
import 'package:recyminer_app/provider/location_provider.dart';
import 'package:recyminer_app/provider/notification_provider.dart';
import 'package:recyminer_app/provider/onboarding_provider.dart';
import 'package:recyminer_app/provider/order_provider.dart';
import 'package:recyminer_app/provider/product_provider.dart';
import 'package:recyminer_app/provider/profile_provider.dart';
import 'package:recyminer_app/provider/search_provider.dart';
import 'package:recyminer_app/provider/settings_provider.dart';
import 'package:recyminer_app/provider/splash_provider.dart';
import 'package:recyminer_app/provider/statistics_provider.dart';
import 'package:recyminer_app/provider/theme_provider.dart';
import 'package:recyminer_app/theme/dark_theme.dart';
import 'package:recyminer_app/theme/light_theme.dart';
import 'package:recyminer_app/utill/app_constants.dart';
import 'package:url_strategy/url_strategy.dart';

import 'di_container.dart' as di;
import 'helper/notification_helper.dart';
import 'localization/app_localization.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    (Platform.isAndroid || Platform.isIOS)
        ? FlutterLocalNotificationsPlugin()
        : null;

Future<void> main() async {
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await di.init();
  int _orderID;
  try {
    if (!kIsWeb) {
      final NotificationAppLaunchDetails notificationAppLaunchDetails =
          await flutterLocalNotificationsPlugin
              .getNotificationAppLaunchDetails();
      if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
        _orderID = notificationAppLaunchDetails.payload != null
            ? int.parse(notificationAppLaunchDetails.payload)
            : null;
      }
      await NotificationHelper.initialize(flutterLocalNotificationsPlugin);
      FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
    }
  } catch (e) {}

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => di.sl<ThemeProvider>()),
      ChangeNotifierProvider(
          create: (context) => di.sl<LocalizationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<SplashProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<OnBoardingProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<CategoryProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ProductProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<SearchProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ChatProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<AuthProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<CartProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<CouponProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<LocationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ProfileProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<OrderProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<BannerProvider>()),
      ChangeNotifierProvider(
          create: (context) => di.sl<NotificationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<SettingsProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<IbmCloudProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<StatisticsProvider>()),
    ],
    child: MyApp(orderID: _orderID, isWeb: !kIsWeb),
  ));
}

class MyApp extends StatefulWidget {
  final int orderID;
  final bool isWeb;
  MyApp({@required this.orderID, @required this.isWeb});

  static final navigatorKey = new GlobalKey<NavigatorState>();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    RouteHelper.setupRouter();

    if (kIsWeb) {
      Provider.of<SplashProvider>(context, listen: false).initSharedData();
      Provider.of<CartProvider>(context, listen: false).getCartData();
      _route();
    }
  }

  void _route() {
    Provider.of<SplashProvider>(context, listen: false)
        .initConfig(context)
        .then((bool isSuccess) {
      if (isSuccess) {
        Timer(Duration(seconds: 1), () async {
          if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
            Provider.of<AuthProvider>(context, listen: false).updateToken();
            // Navigator.of(context).pushReplacementNamed(RouteHelper.menu, arguments: MenuScreen());
            //Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DashboardScreen()));
          } else {
            // Navigator.of(context).pushReplacementNamed(RouteHelper.onBoarding, arguments: OnBoardingScreen());
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Locale> _locals = [];
    AppConstants.languages.forEach((language) {
      _locals.add(Locale(language.languageCode, language.countryCode));
    });
    return Consumer<SplashProvider>(
      builder: (context, splashProvider, child) {
        return (kIsWeb && splashProvider.configModel == null)
            ? SizedBox()
            : MaterialApp(
                title: splashProvider.configModel != null
                    ? splashProvider.configModel.ecommerceName ?? ''
                    : AppConstants.APP_NAME,
                initialRoute: ResponsiveHelper.isMobilePhone()
                    ? widget.orderID == null
                        ? RouteHelper.splash
                        : RouteHelper.getOrderDetailsRoute(widget.orderID)
                    : RouteHelper.menu,
                onGenerateRoute: RouteHelper.router.generator,
                debugShowCheckedModeBanner: false,
                navigatorKey: MyApp.navigatorKey,
                theme: Provider.of<ThemeProvider>(context).darkTheme
                    ? dark
                    : light,
                locale: Provider.of<LocalizationProvider>(context).locale,
                localizationsDelegates: [
                  AppLocalization.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: _locals,
                //home: orderID == null ? SplashScreen() : OrderDetailsScreen(orderModel: null, orderId: orderID),
              );
      },
    );
  }
}
