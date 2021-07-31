import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:json_object_lite/json_object_lite.dart' as jsonobject;
import 'package:provider/provider.dart';
import 'package:recyminer_app/data/model/response/config_model.dart';
import 'package:recyminer_app/localization/language_constrants.dart';
import 'package:recyminer_app/provider/auth_provider.dart';
import 'package:recyminer_app/provider/location_provider.dart';
import 'package:recyminer_app/provider/order_provider.dart';
import 'package:recyminer_app/provider/profile_provider.dart';
import 'package:recyminer_app/provider/settings_provider.dart';
import 'package:recyminer_app/provider/splash_provider.dart';
import 'package:recyminer_app/provider/theme_provider.dart';
import 'package:recyminer_app/utill/color_resources.dart';
import 'package:recyminer_app/utill/dimensions.dart';
import 'package:recyminer_app/utill/styles.dart';
import 'package:recyminer_app/view/base/custom_button.dart';
import 'package:recyminer_app/view/base/custom_dialog.dart';
import 'package:recyminer_app/view/base/title_widget.dart';
import 'package:recyminer_app/view/screens/settings/widget/create_trash_detail.dart';
import 'package:recyminer_app/view/screens/settings/widget/frequency_dialog.dart';
import 'package:recyminer_app/view/screens/settings/widget/time_dialog.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreen createState() => _SettingsScreen();
}

class _SettingsScreen extends State<SettingsScreen> {
  TextEditingController can1 = TextEditingController(text: "0");
  TextEditingController can2 = TextEditingController(text: "0");
  TextEditingController can3 = TextEditingController(text: "0");
  TextEditingController can4 = TextEditingController(text: "0");

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
  GoogleMapController _mapController;
  List<Branches> _branches = [];
  bool _loading = false;
  Set<Marker> _markers = HashSet<Marker>();
  bool _isCashOnDeliveryActive;
  bool _isDigitalPaymentActive;
  bool _isLoggedIn;

  @override
  void initState() {
    super.initState();

    _isLoggedIn =
        Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if (_isLoggedIn) {
      Provider.of<OrderProvider>(context, listen: false)
          .setAddressIndex(-1, notify: false);
      Provider.of<OrderProvider>(context, listen: false)
          .initializeTimeSlot(context);
      Provider.of<LocationProvider>(context, listen: false)
          .initAddressList(context);
      _branches = Provider.of<SplashProvider>(context, listen: false)
          .configModel
          .branches;
    }
    _isCashOnDeliveryActive =
        Provider.of<SplashProvider>(context, listen: false)
                .configModel
                .cashOnDelivery ==
            'true';
    _isDigitalPaymentActive =
        Provider.of<SplashProvider>(context, listen: false)
                .configModel
                .digitalPayment ==
            'true';
  }

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

    int indexFrequency =
        Provider.of<SettingsProvider>(context, listen: true).getFrequency();
    String frequency = (indexFrequency == 0)
        ? "DAILY"
        : (indexFrequency == 1)
            ? "WEEKLY"
            : "MONTHLY";

    return Scaffold(
      appBar: null,
      body: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
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
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                              child: TitleWidget(
                                  title: getTranslated('call_miner', context)),
                            ),
                            TitleButton(
                              icon: Icons.delete_outline,
                              title:
                                  "In which frequency do you take out the trash?",
                              onTap: () => showAnimatedDialog(
                                  context, FrequencyDialog()),
                            ),
                            TitleButton(
                              icon: Icons.timer,
                              title: "In which time do you take out the trash?",
                              onTap: () =>
                                  showAnimatedDialog(context, TimeDialog()),
                            ),
                            Divider(color: Colors.grey),
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                              child: TitleWidget(
                                  title: getTranslated('call_miner', context)),
                            ),
                            SizedBox(height: 10),
                            SwitchListTile(
                              value: Provider.of<ThemeProvider>(context)
                                  .moreThanOnce,
                              onChanged: (bool isActive) =>
                                  Provider.of<ThemeProvider>(context,
                                          listen: false)
                                      .toogleMoreThanOnce(),
                              title: Text(
                                  "Do you throw your trash more than once $frequency?",
                                  style: poppinsRegular.copyWith(
                                      fontSize: Dimensions.FONT_SIZE_LARGE)),
                              activeColor: Colors.green,
                            ),
                            SwitchListTile(
                              value: Provider.of<ThemeProvider>(context)
                                  .fullCapacity,
                              onChanged: (bool isActive) =>
                                  Provider.of<ThemeProvider>(context,
                                          listen: false)
                                      .tooglefullCapacity(),
                              title: Text(
                                  "When do you throw the tank, It is full capacity?",
                                  style: poppinsRegular.copyWith(
                                      fontSize: Dimensions.FONT_SIZE_LARGE)),
                              activeColor: Colors.green,
                            ),
                            Divider(color: Colors.grey),
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                              child: TitleWidget(
                                  title: getTranslated('call_miner', context)),
                            ),
                            SizedBox(height: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                createTrashRowDetail(
                                    can1Field, "normal1.png", 5),
                                createTrashRowDetail(
                                    can2Field, "normal2.png", 10),
                                createTrashRowDetail(
                                    can3Field, "normal3.png", 20),
                                createTrashRowDetail(
                                    can4Field, "normal4.png", 50),
                              ],
                            ),
                            Column(children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                child: TitleWidget(title: "Address"),
                              ),
                              SizedBox(height: 10),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.symmetric(
                                    horizontal: Dimensions.PADDING_SIZE_SMALL),
                                itemCount: Provider.of<LocationProvider>(
                                        context,
                                        listen: true)
                                    .addressList
                                    .length,
                                itemBuilder: (context, index) {
                                  bool _isAvailable = _branches.length == 1 &&
                                      (_branches[0].latitude == null ||
                                          _branches[0].latitude.isEmpty);
                                  if (!_isAvailable) {
                                    double _distance = Geolocator
                                            .distanceBetween(
                                          double.parse(_branches[
                                                  Provider.of<OrderProvider>(
                                                          context,
                                                          listen: false)
                                                      .branchIndex]
                                              .latitude),
                                          double.parse(_branches[
                                                  Provider.of<OrderProvider>(
                                                          context,
                                                          listen: false)
                                                      .branchIndex]
                                              .longitude),
                                          double.parse(
                                              Provider.of<LocationProvider>(
                                                      context,
                                                      listen: false)
                                                  .addressList[index]
                                                  .latitude),
                                          double.parse(
                                              Provider.of<LocationProvider>(
                                                      context,
                                                      listen: false)
                                                  .addressList[index]
                                                  .longitude),
                                        ) /
                                        1000;
                                    _isAvailable = _distance <
                                        _branches[Provider.of<OrderProvider>(
                                                    context,
                                                    listen: false)
                                                .branchIndex]
                                            .coverage;
                                  }

                                  return Padding(
                                    padding: EdgeInsets.only(
                                        bottom: Dimensions.PADDING_SIZE_SMALL),
                                    child: InkWell(
                                      onTap: () async {
                                        if (_isAvailable) {
                                          Provider.of<OrderProvider>(context,
                                                  listen: false)
                                              .setAddressIndex(index);
                                          //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(getTranslated('updated_successfully', context)), duration: Duration(milliseconds: 1500), backgroundColor: Colors.green));
                                        }
                                      },
                                      child: Stack(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(
                                                Dimensions.PADDING_SIZE_SMALL),
                                            decoration: BoxDecoration(
                                              color:
                                                  ColorResources.getCardBgColor(
                                                      context),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.2),
                                                    spreadRadius: .5,
                                                    blurRadius: .5)
                                              ],
                                            ),
                                            child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: Dimensions
                                                            .PADDING_SIZE_EXTRA_SMALL),
                                                    child: Container(
                                                      width: 20,
                                                      height: 20,
                                                      decoration: BoxDecoration(
                                                        color: Theme.of(context)
                                                            .accentColor,
                                                        border: Border.all(
                                                          color: index ==
                                                                  Provider.of<OrderProvider>(
                                                                          context,
                                                                          listen:
                                                                              true)
                                                                      .addressIndex
                                                              ? Theme.of(
                                                                      context)
                                                                  .primaryColor
                                                              : ColorResources
                                                                      .getHintColor(
                                                                          context)
                                                                  .withOpacity(
                                                                      0.6),
                                                          width: index ==
                                                                  Provider.of<OrderProvider>(
                                                                          context,
                                                                          listen:
                                                                              true)
                                                                      .addressIndex
                                                              ? 7
                                                              : 5,
                                                        ),
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Expanded(
                                                      child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                        Text(
                                                            Provider.of<LocationProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .addressList[
                                                                    index]
                                                                .addressType,
                                                            style: poppinsBold
                                                                .copyWith(
                                                              fontSize: Dimensions
                                                                  .FONT_SIZE_SMALL,
                                                              color: index ==
                                                                      Provider.of<OrderProvider>(
                                                                              context,
                                                                              listen:
                                                                                  false)
                                                                          .addressIndex
                                                                  ? ColorResources
                                                                      .getTextColor(
                                                                          context)
                                                                  : ColorResources
                                                                          .getHintColor(
                                                                              context)
                                                                      .withOpacity(
                                                                          .8),
                                                            )),
                                                        Text(
                                                            Provider.of<LocationProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .addressList[
                                                                    index]
                                                                .address,
                                                            style:
                                                                poppinsRegular
                                                                    .copyWith(
                                                              color: index ==
                                                                      Provider.of<OrderProvider>(
                                                                              context,
                                                                              listen:
                                                                                  false)
                                                                          .addressIndex
                                                                  ? ColorResources
                                                                      .getTextColor(
                                                                          context)
                                                                  : ColorResources
                                                                          .getHintColor(
                                                                              context)
                                                                      .withOpacity(
                                                                          .8),
                                                            ),
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis),
                                                      ])),
                                                ]),
                                          ),
                                          !_isAvailable
                                              ? Positioned(
                                                  top: 0,
                                                  left: 0,
                                                  bottom: 10,
                                                  right: 0,
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Colors.black
                                                            .withOpacity(0.6)),
                                                    child: Text(
                                                      getTranslated(
                                                          'out_of_coverage_for_this_branch',
                                                          context),
                                                      textAlign:
                                                          TextAlign.center,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: poppinsRegular
                                                          .copyWith(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 10),
                                                    ),
                                                  ),
                                                )
                                              : SizedBox(),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 20),
                            ])
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 50.0,
                width: 1170,
                margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                child: _loading
                    ? Center(
                        child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor),
                      ))
                    : CustomButton(
                        buttonText: getTranslated('save', context),
                        onPressed: () async {
                          setState(() {
                            _loading = true;
                          });

                          final dynamic document =
                              jsonobject.JsonObjectLite<dynamic>();
                          document.schedule = settingsProvider.timeTrashOut;
                          document.frequencyIndex = indexFrequency;
                          document.frequency = frequency;
                          document.moreThanOnce =
                              Provider.of<ThemeProvider>(context, listen: false)
                                  .moreThanOnce;
                          document.throwTankFull =
                              Provider.of<ThemeProvider>(context, listen: false)
                                  .fullCapacity;
                          document.userId = Provider.of<ProfileProvider>(
                                  context,
                                  listen: false)
                              .userId;
                          document.email =
                              Provider.of<AuthProvider>(context, listen: false)
                                  .email;
                          document.cans = [];
                          document.cans.add({
                            "weight": "5",
                            "unit": "kg",
                            "quantity": can1.text
                          });
                          document.cans.add({
                            "weight": "10",
                            "unit": "kg",
                            "quantity": can2.text
                          });
                          document.cans.add({
                            "weight": "20",
                            "unit": "kg",
                            "quantity": can3.text
                          });
                          document.cans.add({
                            "weight": "50",
                            "unit": "kg",
                            "quantity": can4.text
                          });
                          document.userAddress = Provider.of<LocationProvider>(
                                  context,
                                  listen: false)
                              .getUserAddress();

                          var x = Provider.of<LocationProvider>(context,
                                  listen: false)
                              .addressList[Provider.of<OrderProvider>(context,
                                      listen: false)
                                  .addressIndex]
                              .id;
                          document.location =
                              await Provider.of<LocationProvider>(context,
                                      listen: false)
                                  .getAddress(x);

                          var result =
                              await settingsProvider.saveToDb(document);

                          setState(() {
                            _loading = false;
                          });
                          if (result) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(getTranslated(
                                    'updated_successfully', context)),
                                duration: Duration(milliseconds: 1500),
                                backgroundColor: Colors.green));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(getTranslated('failed', context)),
                                duration: Duration(milliseconds: 1500),
                                backgroundColor: Colors.red));
                          }
                        },
                      ),
              )
            ],
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
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title,
          style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
      onTap: onTap,
    );
  }
}
