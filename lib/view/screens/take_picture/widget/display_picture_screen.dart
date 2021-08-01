import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recyminer_app/provider/ibm_cloud_provider.dart';
import 'package:recyminer_app/utill/dimensions.dart';
import 'package:recyminer_app/utill/styles.dart';
import 'package:recyminer_app/view/base/custom_app_bar.dart';

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final File file;
  bool isLoading = false;

  DisplayPictureScreen({Key key, @required this.file}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: 'Invoice result'),
        // The image is stored as a file on the device. Use the `Image.file`
        // constructor with the given path to display the image.
        body: Container(
          margin: EdgeInsets.only(top: 5, bottom: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.file(file),
              Padding(
                padding: EdgeInsets.all(0),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Center(
                    child: Container(
                      child: isLoading
                          ? null
                          : ElevatedButton(
                              onPressed: () async {
                                isLoading = true;
                                //Call API
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text('Uploading ...'),
                                        duration: Duration(milliseconds: 3000),
                                        backgroundColor:
                                            Colors.lightBlueAccent));

                                bool result =
                                    await Provider.of<IbmCloudProvider>(context,
                                            listen: false)
                                        .uploadPhoto(file);

                                //await Provider.of<RewardProvider>(context,
                                //        listen: false)
                                //    .getPoints();

                                isLoading = false;

                                if (result) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text('Uploaded'),
                                          duration:
                                              Duration(milliseconds: 3000),
                                          backgroundColor: Colors.green));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text('Try again'),
                                          duration:
                                              Duration(milliseconds: 3000),
                                          backgroundColor: Colors.red));
                                }
                              },
                              child: Text(
                                'Upload invoice',
                                textAlign: TextAlign.center,
                                style: poppinsRegular.copyWith(
                                  fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
                                  color: Colors.white,
                                ),
                              ),
                              style: ButtonStyle(
                                  elevation: MaterialStateProperty.all(5),
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.green),
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.all(10.0)),
                                  shadowColor:
                                      MaterialStateProperty.all(Colors.green))),
                    ),
                  )
                ]),
              ),
            ],
          ),
        ));
  }
}
