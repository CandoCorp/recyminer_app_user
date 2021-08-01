import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recyminer_app/data/model/response/category_model.dart';
import 'package:recyminer_app/helper/responsive_helper.dart';
import 'package:recyminer_app/helper/route_helper.dart';
import 'package:recyminer_app/provider/category_provider.dart';
import 'package:recyminer_app/provider/splash_provider.dart';
import 'package:recyminer_app/provider/theme_provider.dart';
import 'package:recyminer_app/utill/color_resources.dart';
import 'package:recyminer_app/utill/dimensions.dart';
import 'package:recyminer_app/utill/images.dart';
import 'package:recyminer_app/utill/styles.dart';
import 'package:recyminer_app/view/base/app_bar_base.dart';
import 'package:recyminer_app/view/base/main_app_bar.dart';
import 'package:recyminer_app/view/screens/product/new_product_screen.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

// ignore: must_be_immutable

class AllCategoryScreen extends StatefulWidget {
  @override
  _AllCategoryScreen createState() => new _AllCategoryScreen();
}

class _AllCategoryScreen extends State<AllCategoryScreen> {
  int flag = 0;
  @override
  Widget build(BuildContext context) {
    if (flag == 0) {
      Provider.of<CategoryProvider>(context)
          .changeSelectedIndex(0, notify: false);
      Provider.of<CategoryProvider>(context, listen: false).getSubCategoryList(
          context,
          Provider.of<CategoryProvider>(context, listen: false)
              .categoryList[0]
              .id
              .toString());
      flag++;
    }
    return Scaffold(
      appBar: ResponsiveHelper.isMobilePhone()
          ? null
          : ResponsiveHelper.isDesktop(context)
              ? MainAppBar()
              : AppBarBase(),
      body: Center(
        child: Container(
          width: 1170,
          child: Consumer<CategoryProvider>(
            builder: (context, categoryProvider, child) {
              return categoryProvider.categoryList.length != 0
                  ? Row(children: [
                      Container(
                        width: 100,
                        margin: EdgeInsets.only(top: 3),
                        height: double.infinity,
                        decoration: BoxDecoration(
                          //color: ColorResources.WHITE,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey[
                                    Provider.of<ThemeProvider>(context)
                                            .darkTheme
                                        ? 600
                                        : 200],
                                spreadRadius: 3,
                                blurRadius: 10)
                          ],
                        ),
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: categoryProvider.categoryList.length,
                          padding: EdgeInsets.all(0),
                          itemBuilder: (context, index) {
                            CategoryModel _category =
                                categoryProvider.categoryList[index];
                            return InkWell(
                              onTap: () {
                                categoryProvider.changeSelectedIndex(index);
                                categoryProvider.getSubCategoryList(
                                    context, _category.id.toString());
                              },
                              child: CategoryItem(
                                title: _category.name,
                                icon: _category.image,
                                isSelected:
                                    categoryProvider.categorySelectedIndex ==
                                        index,
                              ),
                            );
                          },
                        ),
                      ),
                      categoryProvider.subCategoryList != null
                          ? Expanded(
                              child: ListView.builder(
                                padding: EdgeInsets.all(
                                    Dimensions.PADDING_SIZE_SMALL),
                                itemCount:
                                    categoryProvider.subCategoryList.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    onTap: () {
                                      var category =
                                          categoryProvider.categoryList[
                                              categoryProvider
                                                  .categorySelectedIndex];
                                      var subcategory = categoryProvider
                                          .subCategoryList[index];
                                      Navigator.of(context).pushNamed(
                                          RouteHelper.createProduct(
                                              category.id.toString(),
                                              subcategory.id.toString()),
                                          arguments: AddNewProductScreen(
                                            idCategory: category.id,
                                            idSubCategory: subcategory.id,
                                          ));
                                    },
                                    title: Text(
                                      categoryProvider
                                          .subCategoryList[index].name,
                                      style: poppinsMedium.copyWith(
                                          fontSize: 13,
                                          color: ColorResources.getTextColor(
                                              context)),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    trailing: Icon(Icons.keyboard_arrow_right),
                                  );
                                },
                              ),
                            )
                          : Expanded(child: SubCategoryShimmer()),
                    ])
                  : Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String title;
  final String icon;
  final bool isSelected;

  CategoryItem(
      {@required this.title, @required this.icon, @required this.isSelected});

  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 110,
      margin: EdgeInsets.symmetric(
          vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL, horizontal: 2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: isSelected
              ? Theme.of(context).primaryColor
              : ColorResources.getBackgroundColor(context)),
      child: Center(
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Container(
            height: 60,
            width: 60,
            alignment: Alignment.center,
            //padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? ColorResources.getCategoryBgColor(context)
                    : ColorResources.getGreyLightColor(context)
                        .withOpacity(0.05)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: FadeInImage.assetNetwork(
                placeholder: Images.placeholder,
                image:
                    '${Provider.of<SplashProvider>(context, listen: false).baseUrls.categoryImageUrl}/$icon',
                fit: BoxFit.cover,
                width: 100,
                height: 100,
                imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder,
                    height: 100, width: 100, fit: BoxFit.cover),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            child: Text(title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: poppinsSemiBold.copyWith(
                    fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                    color: isSelected
                        ? ColorResources.getBackgroundColor(context)
                        : ColorResources.getTextColor(context))),
          ),
        ]),
      ),
    );
  }
}

class SubCategoryShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) {
        return Shimmer(
          duration: Duration(seconds: 2),
          enabled:
              Provider.of<CategoryProvider>(context).subCategoryList == null,
          child: Container(
            height: 40,
            margin: EdgeInsets.only(left: 15, right: 15, top: 15),
            alignment: Alignment.center,
            decoration: BoxDecoration(color: Colors.white),
          ),
        );
      },
    );
  }
}
