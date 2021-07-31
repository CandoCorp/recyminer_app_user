import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recyminer_app/helper/email_checker.dart';
import 'package:recyminer_app/helper/responsive_helper.dart';
import 'package:recyminer_app/helper/route_helper.dart';
import 'package:recyminer_app/localization/language_constrants.dart';
import 'package:recyminer_app/provider/auth_provider.dart';
import 'package:recyminer_app/utill/color_resources.dart';
import 'package:recyminer_app/utill/dimensions.dart';
import 'package:recyminer_app/utill/images.dart';
import 'package:recyminer_app/utill/styles.dart';
import 'package:recyminer_app/view/base/custom_button.dart';
import 'package:recyminer_app/view/base/custom_snackbar.dart';
import 'package:recyminer_app/view/base/custom_text_field.dart';
import 'package:recyminer_app/view/base/main_app_bar.dart';
import 'package:recyminer_app/view/screens/auth/create_account_screen.dart';
import 'package:recyminer_app/view/screens/forgot_password/verification_screen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? MainAppBar() : null,
      body: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
            physics: BouncingScrollPhysics(),
            child: Center(
              child: Container(
                width: 1170,
                child: Consumer<AuthProvider>(
                  builder: (context, authProvider, child) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Image.asset(
                            Images.app_logo,
                            height: MediaQuery.of(context).size.height / 4.5,
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                          child: Text(
                        getTranslated('signup', context),
                        style: poppinsMedium.copyWith(
                            fontSize: 24,
                            color: ColorResources.getTextColor(context)),
                      )),
                      SizedBox(height: 35),
                      Text(
                        getTranslated('email', context),
                        style: poppinsRegular.copyWith(
                            color: ColorResources.getHintColor(context)),
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      CustomTextField(
                        hintText: getTranslated('demo_gmail', context),
                        isShowBorder: true,
                        inputAction: TextInputAction.done,
                        inputType: TextInputType.emailAddress,
                        controller: _emailController,
                      ),
                      SizedBox(height: 6),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          authProvider.verificationMessage.length > 0
                              ? CircleAvatar(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  radius: 5)
                              : SizedBox.shrink(),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              authProvider.verificationMessage ?? "",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline2
                                  .copyWith(
                                    fontSize: Dimensions.FONT_SIZE_SMALL,
                                    color: Theme.of(context).primaryColor,
                                  ),
                            ),
                          )
                        ],
                      ),

                      // for continue button
                      SizedBox(height: 12),
                      !authProvider.isPhoneNumberVerificationButtonLoading
                          ? CustomButton(
                              buttonText: getTranslated('continue', context),
                              onPressed: () {
                                String _email = _emailController.text.trim();
                                if (_email.isEmpty) {
                                  showCustomSnackBar(
                                      getTranslated(
                                          'enter_email_address', context),
                                      context);
                                } else if (EmailChecker.isNotValid(_email)) {
                                  showCustomSnackBar(
                                      getTranslated(
                                          'enter_valid_email', context),
                                      context);
                                } else {
                                  authProvider
                                      .checkEmail(_email)
                                      .then((value) async {
                                    if (value.isSuccess) {
                                      authProvider.updateEmail(_email);
                                      if (value.message == 'active') {
                                        Navigator.of(context).pushNamed(
                                          RouteHelper.getVerifyRoute(
                                              'sign-up', _email),
                                          arguments: VerificationScreen(
                                              emailAddress: _email,
                                              fromSignUp: true),
                                        );
                                      } else {
                                        Navigator.of(context).pushNamed(
                                            RouteHelper.createAccount,
                                            arguments: CreateAccountScreen());
                                      }
                                    }
                                  });
                                }
                              },
                            )
                          : Center(
                              child: CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).primaryColor))),

                      // for create an account
                      SizedBox(height: 10),
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                getTranslated('already_have_account', context),
                                style: poppinsRegular.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_SMALL,
                                    color:
                                        ColorResources.getHintColor(context)),
                              ),
                              SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                              Text(
                                getTranslated('login', context),
                                style: poppinsMedium.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_SMALL,
                                    color:
                                        ColorResources.getTextColor(context)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
