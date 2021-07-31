import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recyminer_app/helper/price_converter.dart';
import 'package:recyminer_app/helper/route_helper.dart';
import 'package:recyminer_app/localization/language_constrants.dart';
import 'package:recyminer_app/provider/product_provider.dart';
import 'package:recyminer_app/provider/splash_provider.dart';
import 'package:recyminer_app/utill/color_resources.dart';
import 'package:recyminer_app/utill/dimensions.dart';
import 'package:recyminer_app/utill/images.dart';
import 'package:recyminer_app/utill/styles.dart';
import 'package:recyminer_app/view/base/title_widget.dart';
import 'package:recyminer_app/view/screens/product/product_details_screen.dart';

class DailyItemView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
      return productProvider.dailyItemList != null
          ? Column(children: [
              Padding(
                padding: EdgeInsets.fromLTRB(10, 20, 15, 10),
                child: TitleWidget(
                    title: getTranslated('daily_needs', context),
                    onTap: () {
                      Navigator.pushNamed(
                          context, RouteHelper.getDailyItemRoute());
                    }),
              ),
              SizedBox(
                height: 180,
                child: ListView.builder(
                  itemCount: productProvider.dailyItemList.length,
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.PADDING_SIZE_SMALL),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding:
                          EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                              RouteHelper.getProductDetailsRoute(
                                  productProvider.dailyItemList[index].id),
                              arguments: ProductDetailsScreen(
                                  product: productProvider.dailyItemList[index],
                                  cart: null));
                        },
                        child: Container(
                          width: 150,
                          padding: EdgeInsets.all(
                              Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).accentColor,
                          ),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 100,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        width: 1,
                                        color: ColorResources.getGreyColor(
                                            context)),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: FadeInImage.assetNetwork(
                                      placeholder: Images.placeholder,
                                      width: 100,
                                      height: 150,
                                      fit: BoxFit.cover,
                                      image:
                                          '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}'
                                          '/${productProvider.dailyItemList[index].image[0]}',
                                      imageErrorBuilder: (c, o, s) =>
                                          Image.asset(Images.placeholder,
                                              width: 80,
                                              height: 50,
                                              fit: BoxFit.cover),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    height:
                                        Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                Text(
                                  productProvider.dailyItemList[index].name,
                                  style: poppinsMedium.copyWith(
                                      fontSize: Dimensions.FONT_SIZE_SMALL),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '${productProvider.dailyItemList[index].capacity} ${productProvider.dailyItemList[index].unit}',
                                  style: poppinsRegular.copyWith(
                                      fontSize:
                                          Dimensions.FONT_SIZE_EXTRA_SMALL),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        PriceConverter.convertPrice(
                                            context,
                                            productProvider
                                                .dailyItemList[index].price),
                                        style: poppinsBold.copyWith(
                                            fontSize:
                                                Dimensions.FONT_SIZE_SMALL),
                                      ),
                                      Container(
                                        margin: EdgeInsets.all(2),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1,
                                              color:
                                                  ColorResources.getHintColor(
                                                          context)
                                                      .withOpacity(0.2)),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Icon(Icons.add,
                                            size: 20,
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                    ]),
                              ]),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ])
          : SizedBox();
    });
  }
}
