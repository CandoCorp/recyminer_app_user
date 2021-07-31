import 'package:flutter/material.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/settings_provider.dart';
import 'package:flutter_grocery/provider/splash_provider.dart';
import 'package:flutter_grocery/provider/theme_provider.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/app_bar_base.dart';
import 'package:flutter_grocery/view/base/custom_app_bar.dart';
import 'package:flutter_grocery/view/base/custom_button.dart';
import 'package:flutter_grocery/view/base/custom_dialog.dart';
import 'package:flutter_grocery/view/base/main_app_bar.dart';
import 'package:flutter_grocery/view/base/title_widget.dart';
import 'package:flutter_grocery/view/screens/settings/widget/create_trash_detail.dart';
import 'package:flutter_grocery/view/screens/settings/widget/currency_dialog.dart';
import 'package:flutter_grocery/view/screens/settings/widget/frequency_dialog.dart';
import 'package:flutter_grocery/view/screens/settings/widget/time_dialog.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {

  TextEditingController can1 = TextEditingController(text: "0");
  TextEditingController can2 = TextEditingController(text: "0");
  TextEditingController can3 = TextEditingController(text: "0");
  TextEditingController can4 = TextEditingController(text: "0");

  @override
  Widget build(BuildContext context) {
    //Provider.of<SplashProvider>(context, listen: false).setFromSetting(true);

    final can1Field = TextFormField(
      controller: can1,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        labelText: '',
        border: OutlineInputBorder(),
      ),
      enabled: false,
      validator: (value) => value.isEmpty ? 'Campo requerido' : null,
    );

    final can2Field = TextFormField(
      controller: can2,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        labelText: '',
        border: OutlineInputBorder(),
      ),
      enabled: false,
      validator: (value) => value.isEmpty ? 'Campo requerido' : null,
    );

    final can3Field = TextFormField(
      controller: can3,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        labelText: '',
        border: OutlineInputBorder(),
      ),
      enabled: false,
      validator: (value) => value.isEmpty ? 'Campo requerido' : null,
    );

    final can4Field = TextFormField(
      controller: can4,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        labelText: '',
        border: OutlineInputBorder(),
      ),
      enabled: false,
      validator: (value) => value.isEmpty ? 'Campo requerido' : null,
    );

    int indexFrequency = Provider.of<SettingsProvider>(context, listen: true)
        .getFrequency();
    String frequency = (indexFrequency == 0) ? "DAILY" : (indexFrequency == 1)
        ? "WEEKLY"
        : "MONTHLY";

    return Scaffold(
      appBar: null,
      body: Consumer<SettingsProvider>(
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
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Text(
          getTranslated('product_info', context)
          ),
          ),

          // for Address Field
          Text(
          getTranslated('product_name', context),
          style: poppinsRegular.copyWith(color: ColorResources.getHintColor(context)),
          ),
          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

          Text(
          getTranslated('unit', context),
          style: poppinsRegular.copyWith(color: ColorResources.getHintColor(context)),
          ),

          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

          Container(
          height: 50,
          child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          itemCount: 0,
          itemBuilder: (context, index) => InkWell(
          onTap: () {
          //productProvider.updateUnitIndex(index);
          },
          ),
          ),
          ),
          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

          // for Contact Person Name
          Text(
          getTranslated('product_weight', context),
          style: poppinsRegular.copyWith(color: ColorResources.getHintColor(context)),
          ),
          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
          SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

          // for Contact Person Number
          Text(
          getTranslated('product_price', context),
          style: poppinsRegular.copyWith(color: ColorResources.getHintColor(context)),),
          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
          SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

          Text(
          getTranslated('product_description', context),
          style: poppinsRegular.copyWith(color: ColorResources.getHintColor(context)),),
          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),


          SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
          ],
          ),
          ),
          ),
          ),
          ),
          ),
                Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          ],
          ),

          Container(
          height: 50.0,
          width: 1170,
          margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          child: CustomButton(
          buttonText: getTranslated('call_miner', context),
          onPressed: () {
          },
          ),
          )
          ]
          ,
          );
        },
      ),
    );
  }

}

class TitleButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function onTap;

  TitleButton(
      {@required this.icon, @required this.title, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Theme
          .of(context)
          .primaryColor),
      title: Text(title,
          style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
      onTap: onTap,
    );
  }
}

