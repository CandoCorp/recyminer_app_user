import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:recyminer_app/helper/responsive_helper.dart';
import 'package:recyminer_app/helper/route_helper.dart';
import 'package:recyminer_app/localization/language_constrants.dart';
import 'package:recyminer_app/utill/dimensions.dart';
import 'package:recyminer_app/utill/styles.dart';
import 'package:recyminer_app/view/base/title_row.dart';
import 'package:universal_html/html.dart' as html;
import 'package:universal_ui/universal_ui.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDescription extends StatelessWidget {
  final String productDescription;
  final String id;
  ProductDescription({@required this.productDescription, @required this.id});

  @override
  Widget build(BuildContext context) {
    final String _viewID = id;

    if (ResponsiveHelper.isWeb()) {
      try {
        ui.platformViewRegistry.registerViewFactory(_viewID, (int viewId) {
          html.IFrameElement _ife = html.IFrameElement();
          _ife.width = '1170';
          _ife.height = MediaQuery.of(context).size.height.toString();
          _ife.srcdoc = productDescription;
          _ife.contentEditable = 'false';
          _ife.style.border = 'none';
          _ife.allowFullscreen = true;
          return _ife;
        });
      } catch (e) {}
    }

    return Column(
      children: [
        TitleRow(
            title: getTranslated('description', context),
            isDetailsPage: true,
            onTap: () {
              Navigator.pushNamed(
                context,
                RouteHelper.getProductDescriptionRoute(productDescription, id),
                arguments: ProductDescription(
                    productDescription: productDescription, id: id),
              );
            }),
        SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
        productDescription.isNotEmpty
            ? Center(
                child: Container(
                  width: 1170,
                  height: 100,
                  color: Colors.white,
                  child: ResponsiveHelper.isWeb()
                      ? Column(
                          children: [
                            Expanded(
                                child: IgnorePointer(
                                    child: HtmlElementView(
                                        viewType: _viewID, key: Key(id)))),
                          ],
                        )
                      : SingleChildScrollView(
                          child: Center(
                            child: SizedBox(
                              width: 1170,
                              child: HtmlWidget(
                                productDescription,
                                textStyle: poppinsRegular.copyWith(
                                    color: Colors.black),
                                onTapUrl: (String url) {
                                  launch(url);
                                },
                                hyperlinkColor: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                ),
              )
            : Center(child: Text(getTranslated('no_description', context))),
      ],
    );
  }
}
