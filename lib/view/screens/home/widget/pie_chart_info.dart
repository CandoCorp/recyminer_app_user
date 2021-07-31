/// Bar chart with example of a legend with customized position, justification,
/// desired max rows, and padding. These options are shown as an example of how
/// to use the customizations, they do not necessary have to be used together in
/// this way. Choosing [end] as the position does not require the justification
/// to also be [endDrawArea].
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recyminer_app/helper/responsive_helper.dart';
import 'package:recyminer_app/provider/banner_provider.dart';
import 'package:recyminer_app/utill/dimensions.dart';
import 'package:recyminer_app/view/base/title_widget.dart';

/// Example that shows how to build a datum legend that shows measure values.
///
/// Also shows the option to provide a custom measure formatter.
class PieChartInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<BannerProvider>(
      builder: (context, banner, child) {
        return Column(
          children: [
            Divider(color: Colors.grey),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TitleWidget(title: 'Average recycling in your area'),
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
              child: new charts.PieChart(
                _createSampleData(),
                animate: true,
                // Add the legend behavior to the chart to turn on legends.
                // This example shows how to optionally show measure and provide a custom
                // formatter.
                behaviors: [
                  new charts.DatumLegend(
                    // Positions for "start" and "end" will be left and right respectively
                    // for widgets with a build context that has directionality ltr.
                    // For rtl, "start" and "end" will be right and left respectively.
                    // Since this example has directionality of ltr, the legend is
                    // positioned on the right side of the chart.
                    position: charts.BehaviorPosition.end,
                    // By default, if the position of the chart is on the left or right of
                    // the chart, [horizontalFirst] is set to false. This means that the
                    // legend entries will grow as new rows first instead of a new column.
                    horizontalFirst: false,
                    // This defines the padding around each legend entry.
                    cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
                    // Set [showMeasures] to true to display measures in series legend.
                    showMeasures: true,
                    // Configure the measure value to be shown by default in the legend.
                    legendDefaultMeasure:
                        charts.LegendDefaultMeasure.firstValue,
                    // Optionally provide a measure formatter to format the measure value.
                    // If none is specified the value is formatted as a decimal.
                    measureFormatter: (var value) {
                      return value == null ? '-' : '${value}%';
                    },
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  /// Create series list with one series
  static List<charts.Series<CategoryArea, String>> _createSampleData() {
    final data = [
      new CategoryArea(10, "Plastic"),
      new CategoryArea(10, "Paperboard"),
      new CategoryArea(10, "Glass"),
      new CategoryArea(70, "Organic"),
    ];

    return [
      new charts.Series<CategoryArea, String>(
        id: 'Categories',
        domainFn: (CategoryArea sales, _) => sales.category,
        measureFn: (CategoryArea sales, _) => sales.percent,
        data: data,
      )
    ];
  }
}

class CategoryArea {
  final int percent;
  final String category;
  CategoryArea(this.percent, this.category);
}
