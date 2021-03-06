import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recyminer_app/helper/route_helper.dart';
import 'package:recyminer_app/localization/language_constrants.dart';
import 'package:recyminer_app/provider/category_provider.dart';
import 'package:recyminer_app/provider/reward_provider.dart';
import 'package:recyminer_app/provider/splash_provider.dart';
import 'package:recyminer_app/provider/statistics_provider.dart';
import 'package:recyminer_app/utill/dimensions.dart';
import 'package:recyminer_app/utill/images.dart';
import 'package:recyminer_app/utill/styles.dart';
import 'package:recyminer_app/view/screens/home/widget/pie_chart_info.dart';
import 'package:recyminer_app/view/screens/take_picture/take_picture_screen.dart';

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}

class HomeScreen extends StatelessWidget {
  int points = 0;
  Future<void> _loadData(BuildContext context, bool reload) async {
    await Provider.of<CategoryProvider>(context, listen: false)
        .getCategoryList(context, reload);
    await Provider.of<StatisticsProvider>(context, listen: false)
        .getStatistics();

    points = Provider.of<RewardProvider>(context, listen: false).points;
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();
    _loadData(context, false);

    return RefreshIndicator(
      onRefresh: () async {
        //await _loadData(context, true);
      },
      backgroundColor: Theme.of(context).primaryColor,
      child: Scaffold(
        //appBar: ResponsiveHelper.isDesktop(context) ? MainAppBar() : null,
        appBar:
            null, // ResponsiveHelper.isMobilePhone()? null: ResponsiveHelper.isDesktop(context) ? MainAppBar(): AppBarBase(),
        body: Scrollbar(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Center(
              child: Column(children: [
                Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                  child: Stack(children: [
                    Image.asset(
                      Images.coupon_bg_2,
                      height: 100,
                      width: MediaQuery.of(context).size.width,
                      color: Theme.of(context).primaryColor,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      height: 100,
                      alignment: Alignment.center,
                      child: Row(children: [
                        SizedBox(width: 40),
                        Image.asset(Images.coins, height: 70, width: 70),
                        Padding(
                          padding:
                              EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                          child:
                              Image.asset(Images.line, height: 100, width: 5),
                        ),
                        Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SelectableText(
                                  'Your points',
                                  style: poppinsMedium.copyWith(
                                      color: Colors.white),
                                ),
                                SizedBox(
                                    height:
                                        Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                Text(
                                  points.toString(),
                                  style: poppinsSemiBold.copyWith(
                                      color: Colors.white,
                                      fontSize:
                                          Dimensions.FONT_SIZE_EXTRA_LARGE),
                                ),
                                SizedBox(
                                    height:
                                        Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                Text(
                                  'GET POINTS WITH YOUR INVOICES',
                                  style: poppinsLight.copyWith(
                                      color: Colors.white,
                                      fontSize: Dimensions.FONT_SIZE_SMALL),
                                ),
                              ]),
                        ),
                      ]),
                    ),
                  ]),
                ),
                Container(
                    height: 200,
                    //padding: EdgeInsets.all(10.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                            child: Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 5, 0, 5),
                                              child: Text(
                                                getTranslated(
                                                    'call_miner', context),
                                                style: poppinsRegular.copyWith(
                                                    fontSize: Dimensions
                                                        .FONT_SIZE_EXTRA_LARGE,
                                                    color: Colors.white,
                                                    backgroundColor:
                                                        Colors.green,
                                                    decorationColor:
                                                        Colors.red),
                                              ),
                                            ),
                                          )
                                        ]),
                                  ),
                                  style: ButtonStyle(
                                      elevation: MaterialStateProperty.all(10),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.green),
                                      padding: MaterialStateProperty.all(
                                          EdgeInsets.all(30.0)),
                                      shadowColor: MaterialStateProperty.all(
                                          Colors.green)),
                                  onPressed: () {
                                    Provider.of<SplashProvider>(context,
                                            listen: false)
                                        .setPageIndex(1);
                                  }),
                              ElevatedButton(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
                                    child: Text(
                                      'Add Invoice',
                                      style: poppinsRegular.copyWith(
                                          fontSize:
                                              Dimensions.FONT_SIZE_EXTRA_LARGE,
                                          color: Colors.white,
                                          backgroundColor: Colors.lightBlue,
                                          decorationColor: Colors.lightBlue),
                                    ),
                                  ),
                                  style: ButtonStyle(
                                      elevation: MaterialStateProperty.all(10),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.lightBlue),
                                      padding: MaterialStateProperty.all(
                                          EdgeInsets.all(30.0)),
                                      shadowColor: MaterialStateProperty.all(
                                          Colors.lightBlue)),
                                  onPressed: () async {
                                    print('Received click');
                                    //WidgetsFlutterBinding.ensureInitialized();

                                    final cameras = await availableCameras();

                                    final firstCamera = cameras.first;

                                    Navigator.of(context)
                                        .pushNamed(RouteHelper.takePicture,
                                            arguments: TakePictureScreen(
                                              camera: firstCamera,
                                            ));
                                  }),
                            ],
                          ),
                        ),
                      ],
                    )),
                //Padding(padding: EdgeInsets.all(20.0), child: new BarChartInfo()),
                Padding(
                    padding: EdgeInsets.all(20.0), child: new PieChartInfo()),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
