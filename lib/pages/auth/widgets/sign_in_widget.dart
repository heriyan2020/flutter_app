import 'package:flutter/material.dart';
import 'package:flutter_app/bloc/login/login_bloc.dart';
import 'package:flutter_app/data/datasources/auth_local_datasource.dart';
import 'package:flutter_app/data/models/request/login_request_model.dart';
import 'package:flutter_app/pages/dashboard/dashboard_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/color_resources.dart';
import '../../../utils/custom_themes.dart';
import '../../../utils/dimensions.dart';
import '../../base_widgets/button/custom_button.dart';
import '../../base_widgets/text_field/custom_password_textfield.dart';
import '../../base_widgets/text_field/custom_textfield.dart';

class SignInWidget extends StatefulWidget {
  const SignInWidget({Key? key}) : super(key: key);

  @override
  SignInWidgetState createState() => SignInWidgetState();
}

class SignInWidgetState extends State<SignInWidget> {
  TextEditingController? _emailController;
  TextEditingController? _passwordController;
  GlobalKey<FormState>? _formKeyLogin;

  @override
  void initState() {
    super.initState();
    _formKeyLogin = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController!.dispose();
    _passwordController!.dispose();
    super.dispose();
  }

  final FocusNode _emailNode = FocusNode();
  final FocusNode _passNode = FocusNode();

  void loginUser() async {
    if (_formKeyLogin!.currentState!.validate()) {
      _formKeyLogin!.currentState!.save();

      String email = _emailController!.text.trim();
      String password = _passwordController!.text.trim();

      if (email.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Email'),
          backgroundColor: Colors.red,
        ));
      } else if (password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Password'),
          backgroundColor: Colors.red,
        ));
      } else {
        final model = LoginRequestModel(email: email, password: password);
        context.read<LoginBloc>().add(LoginEvent.login(model));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: Dimensions.marginSizeLarge),
      child: Form(
        key: _formKeyLogin,
        child: ListView(
          padding:
              const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
          children: [
            Container(
                margin:
                    const EdgeInsets.only(bottom: Dimensions.marginSizeSmall),
                child: CustomTextField(
                  hintText: 'Email',
                  focusNode: _emailNode,
                  nextNode: _passNode,
                  textInputType: TextInputType.emailAddress,
                  controller: _emailController,
                )),
            Container(
                margin:
                    const EdgeInsets.only(bottom: Dimensions.marginSizeDefault),
                child: CustomPasswordTextField(
                  hintTxt: 'Password',
                  textInputAction: TextInputAction.done,
                  focusNode: _passNode,
                  controller: _passwordController,
                )),
            Container(
              margin: const EdgeInsets.only(right: Dimensions.marginSizeSmall),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        checkColor: ColorResources.white,
                        activeColor: Theme.of(context).primaryColor,
                        value: false,
                        onChanged: (val) {},
                      ),
                      const Text('Remember', style: titilliumRegular),
                    ],
                  ),
                  InkWell(
                    onTap: () {},
                    child: Text('Forgot Password',
                        style: titilliumRegular.copyWith(
                            color: ColorResources.getLightSkyBlue(context))),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                  left: 20, right: 20, bottom: 20, top: 30),
              child: BlocConsumer<LoginBloc, LoginState>(
                listener: (context, state) {
                  state.maybeWhen(
                      orElse: () {},
                      loaded: (data) async {
                        await AuthLocalDatasource().saveAuthData(data);
                        Navigator.pushAndRemoveUntil(context,
                            MaterialPageRoute(builder: (context) {
                          return DashboardPage();
                        }), (route) => false);
                      },
                      error: (message) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(message),
                          backgroundColor: Colors.red,
                        ));
                      });
                },
                builder: (context, state) {
                  return state.maybeWhen(
                    orElse: () {
                      return CustomButton(
                          onTap: loginUser, buttonText: 'Sign In');
                    },
                    loading: () => Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: Dimensions.paddingSizeDefault),
            const SizedBox(width: Dimensions.paddingSizeDefault),
            Center(
                child: Text('OR',
                    style: titilliumRegular.copyWith(
                        fontSize: Dimensions.fontSizeDefault))),
            GestureDetector(
              onTap: () {
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (context) {
                  return const DashboardPage();
                }), (route) => false);
              },
              child: Container(
                margin: const EdgeInsets.only(
                    left: Dimensions.marginSizeAuth,
                    right: Dimensions.marginSizeAuth,
                    top: Dimensions.marginSizeAuthSmall),
                width: double.infinity,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text('Continue as Guest',
                    style: titleHeader.copyWith(
                        color: ColorResources.getPrimary(context))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
