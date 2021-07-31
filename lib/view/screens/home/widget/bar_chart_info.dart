/// Bar chart example
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recyminer_app/helper/responsive_helper.dart';
import 'package:recyminer_app/localization/language_constrants.dart';
import 'package:recyminer_app/provider/banner_provider.dart';
import 'package:recyminer_app/utill/dimensions.dart';
import 'package:recyminer_app/view/base/title_widget.dart';

class BarChartInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<BannerProvider>(
      builder: (context, banner, child) {
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TitleWidget(title: getTranslated('call_miner', context)),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              height: ResponsiveHelper.isDesktop(context)
                  ? 500
                  : MediaQuery.of(context).size.width * 0.5,
              // height: MediaQuery.of(context).size.width * 0.4,
              padding: EdgeInsets.only(
                  top: Dimensions.PADDING_SIZE_LARGE,
                  bottom: Dimensions.PADDING_SIZE_SMALL),
              child: new charts.BarChart(
                _createSampleData(),
                animate: true,
              ),
            )
          ],
        );
      },
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<OrdinalSales, String>> _createSampleData() {
    final data = [
      new OrdinalSales('2014', 5),
      new OrdinalSales('2015', 25),
      new OrdinalSales('2016', 100),
      new OrdinalSales('2017', 75),
    ];

    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}
