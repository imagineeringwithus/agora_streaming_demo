import 'package:_imagineering_pack/setup/setup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../widgets/widgets.dart';
import 'bloc/sign_in_bloc.dart';
import 'widgets/widget_code_input.dart';
import 'widgets/widget_phone_input.dart';

SignInBloc get _bloc => Get.find<SignInBloc>();

class AuthenticateScreen extends StatefulWidget {
  const AuthenticateScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<AuthenticateScreen> createState() => _AuthenticateScreenState();
}

class _AuthenticateScreenState extends State<AuthenticateScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          width: 500,
          margin: const EdgeInsets.all(16),
          padding: responByWidth(
              context, const EdgeInsets.symmetric(horizontal: 48, vertical: 40),
              phone: const EdgeInsets.symmetric(horizontal: 20, vertical: 16)),
          decoration: BoxDecoration(
              color: appColorBackground,
              borderRadius: BorderRadius.circular(16)),
          child: BlocBuilder<SignInBloc, SignInState>(
              bloc: _bloc,
              buildWhen: (pre, next) {
                return pre.step != next.step || pre.msg != next.msg;
              },
              builder: (context, state) {
                Widget child;
                switch (state.step) {
                  case FormStep.phone:
                    child = const WidgetPhoneInput();
                    break;
                  case FormStep.code:
                    child = const WidgetCodeInput();
                    break;
                }
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    child,
                    if (state.msg != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          state.msg!,
                          style: w300TextStyle(),
                        ),
                      )
                  ],
                );
              }),
        ),
      ),
    );
  }
}
