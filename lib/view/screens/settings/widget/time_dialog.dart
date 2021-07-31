import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recyminer_app/localization/language_constrants.dart';
import 'package:recyminer_app/provider/settings_provider.dart';
import 'package:recyminer_app/utill/color_resources.dart';
import 'package:recyminer_app/utill/dimensions.dart';
import 'package:recyminer_app/utill/styles.dart';

class TimeDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Duration initialtimer =
        Provider.of<SettingsProvider>(context, listen: false).getTimeTrashOut();

    return Dialog(
      backgroundColor: Theme.of(context).accentColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        width: 300,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                child: Text("Schedule",
                    style: poppinsRegular.copyWith(
                        fontSize: Dimensions.FONT_SIZE_LARGE)),
              ),
              SizedBox(
                  height: 150,
                  child: Consumer<SettingsProvider>(
                    builder: (context, splash, child) {
                      //List<String> _valueList = [];
                      //AppConstants.languages.forEach((language) => _valueList.add(language.languageName));

                      return CupertinoTimerPicker(
                        mode: CupertinoTimerPickerMode.hms,
                        minuteInterval: 1,
                        secondInterval: 1,
                        initialTimerDuration: initialtimer,
                        onTimerDurationChanged: (Duration changedtimer) {
                          //setState(() {
                          initialtimer = changedtimer;
                          //});
                        },
                      );
//              return CupertinoPicker(
//                itemExtent: 40,
//                useMagnifier: true,
//                magnification: 1.2,
//                scrollController: FixedExtentScrollController(initialItem: index = 0),
//                onSelectedItemChanged: (int i) {
//                  index = i;
//                },
//                children: _valueList.map((value) {
//                  return Center(child: Text(value, style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color)));
//                }).toList(),
//              );
                    },
                  )),
              Divider(
                  height: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                  color: ColorResources.getHintColor(context)),
              Row(children: [
                Expanded(
                    child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(getTranslated('cancel', context),
                      style: poppinsRegular.copyWith(
                          color: ColorResources.getYellow(context))),
                )),
                Container(
                  height: 50,
                  padding: EdgeInsets.symmetric(
                      vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  child: VerticalDivider(
                      width: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                      color: Theme.of(context).hintColor),
                ),
                Expanded(
                    child: TextButton(
                  onPressed: () {
                    Provider.of<SettingsProvider>(context, listen: false)
                        .updateTimeTrashOut(initialtimer);
                    Navigator.pop(context);
                  },
                  child: Text(getTranslated('ok', context),
                      style: poppinsRegular.copyWith(
                          color: ColorResources.getGreen(context))),
                )),
              ]),
            ]),
      ),
    );
  }
}
