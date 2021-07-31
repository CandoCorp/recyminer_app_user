import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recyminer_app/data/model/response/cart_model.dart';
import 'package:recyminer_app/data/model/response/product_model.dart';
import 'package:recyminer_app/helper/price_converter.dart';
import 'package:recyminer_app/helper/responsive_helper.dart';
import 'package:recyminer_app/helper/route_helper.dart';
import 'package:recyminer_app/localization/language_constrants.dart';
import 'package:recyminer_app/provider/cart_provider.dart';
import 'package:recyminer_app/provider/product_provider.dart';
import 'package:recyminer_app/utill/color_resources.dart';
import 'package:recyminer_app/utill/dimensions.dart';
import 'package:recyminer_app/utill/styles.dart';
import 'package:recyminer_app/view/base/custom_app_bar.dart';
import 'package:recyminer_app/view/base/custom_button.dart';
import 'package:recyminer_app/view/base/custom_text_field.dart';
import 'package:recyminer_app/view/base/main_app_bar.dart';

class AddNewProductScreen extends StatelessWidget {
  final bool isEnableUpdate;
  final Product product;
  final int idCategory;
  final int idSubCategory;

  AddNewProductScreen({
    this.isEnableUpdate = false,
    this.product,
    this.idCategory,
    this.idSubCategory,
  });

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final FocusNode _name = FocusNode();
  final FocusNode _weight = FocusNode();
  final FocusNode _price = FocusNode();
  final FocusNode _description = FocusNode();

  @override
  Widget build(BuildContext context) {
    //GoogleMapController _controller;

    Provider.of<ProductProvider>(context, listen: false)
        .initializeAllUnitType(context: context);
    Provider.of<ProductProvider>(context, listen: false)
        .updateProductStatusMessae(message: '');
    Provider.of<ProductProvider>(context, listen: false)
        .updateErrorMessage(message: '');

    if (product != null) {
      //Provider.of<LocationProvider>(context, listen: false)
      //    .updatePosition(CameraPosition(target: LatLng(double.parse(address.latitude), double.parse(address.longitude))));
      _nameController.text = '${product.name}';
      _weightController.text = '${product.capacity}';
      _priceController.text = '${product.price}';
      _descriptionController.text = '${product.description}';
      if (product.unit == 'kg') {
        Provider.of<ProductProvider>(context, listen: false).updateUnitIndex(0);
      } else if (product.unit == 'gm') {
        Provider.of<ProductProvider>(context, listen: false).updateUnitIndex(1);
      } else {
        Provider.of<ProductProvider>(context, listen: false).updateUnitIndex(2);
      }
    }

    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)
          ? MainAppBar()
          : CustomAppBar(
              title: isEnableUpdate
                  ? getTranslated('request_miner', context)
                  : getTranslated('request_miner', context)),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          return Column(
            children: [
              Expanded(
                child: Scrollbar(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                    child: Center(
                      child: SizedBox(
                        width: 1170,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // physics: BouncingScrollPhysics(),
                          children: [
                            // for product name

                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 24.0),
                              child: Text(
                                getTranslated('product_info', context),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3
                                    .copyWith(
                                        color: ColorResources.getHintColor(
                                            context),
                                        fontSize: Dimensions.FONT_SIZE_LARGE),
                              ),
                            ),

                            // for Address Field
                            Text(
                              getTranslated('product_name', context),
                              style: poppinsRegular.copyWith(
                                  color: ColorResources.getHintColor(context)),
                            ),
                            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                            CustomTextField(
                              hintText: getTranslated(
                                  'product_name_placeholder', context),
                              isShowBorder: true,
                              inputType: TextInputType.streetAddress,
                              inputAction: TextInputAction.next,
                              focusNode: _name,
                              nextFocus: _weight,
                              controller: _nameController,
                            ),
                            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                            Text(
                              getTranslated('unit', context),
                              style: poppinsRegular.copyWith(
                                  color: ColorResources.getHintColor(context)),
                            ),

                            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                            Container(
                              height: 50,
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                physics: BouncingScrollPhysics(),
                                itemCount:
                                    productProvider.getAllUnitType.length,
                                itemBuilder: (context, index) => InkWell(
                                  onTap: () {
                                    productProvider.updateUnitIndex(index);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical:
                                            Dimensions.PADDING_SIZE_DEFAULT,
                                        horizontal:
                                            Dimensions.PADDING_SIZE_LARGE),
                                    margin: EdgeInsets.only(right: 17),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          Dimensions.PADDING_SIZE_SMALL,
                                        ),
                                        border: Border.all(
                                            color: productProvider
                                                        .selectUnitIndex ==
                                                    index
                                                ? Theme.of(context).primaryColor
                                                : ColorResources.getDarkColor(
                                                    context)),
                                        color:
                                            productProvider.selectUnitIndex ==
                                                    index
                                                ? Theme.of(context).primaryColor
                                                : ColorResources.getCardBgColor(
                                                    context)),
                                    child: Text(
                                      productProvider.getAllUnitType[index],
                                      style: poppinsRegular.copyWith(
                                          color: productProvider
                                                      .selectUnitIndex ==
                                                  index
                                              ? Theme.of(context).accentColor
                                              : ColorResources.getHintColor(
                                                  context)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                            // for Contact Person Name
                            Text(
                              getTranslated('product_weight', context),
                              style: poppinsRegular.copyWith(
                                  color: ColorResources.getHintColor(context)),
                            ),
                            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                            CustomTextField(
                              hintText: getTranslated(
                                  'product_weight_placeholder', context),
                              isShowBorder: true,
                              inputType: TextInputType.name,
                              controller: _weightController,
                              focusNode: _weight,
                              nextFocus: _price,
                              keyboardType: TextInputType.number,
                              inputAction: TextInputAction.next,
                              capitalization: TextCapitalization.words,
                            ),
                            SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                            // for Contact Person Number
                            Text(
                              'You pay',
                              style: poppinsRegular.copyWith(
                                  color: ColorResources.getHintColor(context)),
                            ),
                            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                            CustomTextField(
                              hintText: 'How much you want to pay',
                              isShowBorder: true,
                              inputType: TextInputType.phone,
                              inputAction: TextInputAction.done,
                              focusNode: _price,
                              nextFocus: _description,
                              controller: _priceController,
                              keyboardType: TextInputType.number,
                            ),
                            SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                            Text(
                              getTranslated('product_description', context),
                              style: poppinsRegular.copyWith(
                                  color: ColorResources.getHintColor(context)),
                            ),
                            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                            CustomTextField(
                              //hintText: getTranslated('product_price_placeholder', context),
                              isShowBorder: true,
                              inputType: TextInputType.text,
                              inputAction: TextInputAction.done,
                              focusNode: _description,
                              controller: _descriptionController,
                              keyboardType: TextInputType.multiline,
                              maxLines: 3,
                              hintText: 'Describe the status of the item',
                            ),

                            SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              productProvider.productStatusMessage != null
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        productProvider.productStatusMessage.length > 0
                            ? CircleAvatar(
                                backgroundColor: Colors.green, radius: 5)
                            : SizedBox.shrink(),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            productProvider.productStatusMessage ?? "",
                            style: Theme.of(context)
                                .textTheme
                                .headline2
                                .copyWith(
                                    fontSize: Dimensions.FONT_SIZE_SMALL,
                                    color: Colors.green,
                                    height: 1),
                          ),
                        )
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        productProvider.errorMessage.length > 0
                            ? CircleAvatar(
                                backgroundColor: Theme.of(context).primaryColor,
                                radius: 5)
                            : SizedBox.shrink(),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            productProvider.errorMessage ?? "",
                            style: Theme.of(context)
                                .textTheme
                                .headline2
                                .copyWith(
                                    fontSize: Dimensions.FONT_SIZE_SMALL,
                                    color: Theme.of(context).primaryColor,
                                    height: 1),
                          ),
                        )
                      ],
                    ),
              Container(
                height: 50.0,
                width: 1170,
                margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                child: !productProvider.isLoading
                    ? CustomButton(
                        buttonText: isEnableUpdate
                            ? getTranslated('call_miner', context)
                            : getTranslated('call_miner', context),
                        onPressed: productProvider.loading
                            ? null
                            : () {
                                Product productModel = Product(
                                  name: _nameController.text ?? '',
                                  capacity:
                                      double.parse(_weightController.text),
                                  description:
                                      _descriptionController.text ?? '',
                                  price: double.parse(_priceController.text),
                                  unit: productProvider.getAllUnitType[
                                      productProvider.selectUnitIndex],
                                  categoryIds: [],
                                  image: [],
                                  variations: [],
                                  discount: 0,
                                  discountType: "percent",
                                  totalStock: 1,
                                  taxType: "percent",
                                  tax: 0,
                                );
                                productModel.categoryIds.add(new CategoryIds(
                                    id: this.idCategory.toString(),
                                    position: 1));
                                productModel.categoryIds.add(new CategoryIds(
                                    id: this.idSubCategory.toString(),
                                    position: 2));

                                if (isEnableUpdate) {
                                  log("$isEnableUpdate");
                                } else {
                                  productProvider
                                      .addProduct(productModel)
                                      .then((value) {
                                    if (value.isSuccess) {
                                      // productProvider.product.image[0]
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(value.message),
                                              duration:
                                                  Duration(milliseconds: 1200),
                                              backgroundColor: Colors.green));

                                      CartModel _cartModel = CartModel(
                                        productProvider.product.id,
                                        "placeholder.png",
                                        productModel.name,
                                        productModel.price,
                                        PriceConverter.convertWithDiscount(
                                            context,
                                            productModel.price,
                                            productModel.discount,
                                            productModel.discountType),
                                        productModel.totalStock,
                                        new Variations(),
                                        (productModel.price -
                                            PriceConverter.convertWithDiscount(
                                                context,
                                                productModel.price,
                                                productModel.discount,
                                                productModel.discountType)),
                                        (productModel.price -
                                            PriceConverter.convertWithDiscount(
                                                context,
                                                productModel.price,
                                                productModel.tax,
                                                productModel.taxType)),
                                        productModel.capacity,
                                        productModel.unit,
                                        productModel.totalStock,
                                      );

                                      Provider.of<CartProvider>(context,
                                              listen: false)
                                          .addToCart(_cartModel);
                                      Navigator.pushNamed(
                                          context, RouteHelper.cart);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(value.message),
                                              duration:
                                                  Duration(milliseconds: 1200),
                                              backgroundColor: Colors.red));
                                    }
                                  });
                                }
                              },
                      )
                    : Center(
                        child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor),
                      )),
              )
            ],
          );
        },
      ),
    );
  }
}
