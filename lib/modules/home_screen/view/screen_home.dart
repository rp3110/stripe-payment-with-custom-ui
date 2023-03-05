import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stripe_custom_ui/utils/app_routes.dart';
import 'package:stripe_custom_ui/utils/navigator_key.dart';

import '../../../api_service/preference_helper.dart';
import '../../../common/widget/modal_progress_hud.dart';
import '../../../common/widget/widget_custom_button.dart';
import '../../bloc/create_customer_bloc/create_customer_bloc.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({Key? key}) : super(key: key);

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  /// Used to show the progress bar.
  ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateCustomerBloc, CreateCustomerState>(
        listener: (context, state) {
          if (state is CreateCustomerLoading) {
            isLoading.value = true;
          } else {
            if (state is CreateCustomerFailure) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.mError)));
            } else if (state is CreateCustomerResponse) {
              PreferenceHelper.setString("id", state.mModelUser.id.toString());
              NavigatorKey.navigatorKey.currentState!
                  .pushNamed(AppRoutes.routesPaymentMethod);
            }
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text("Payment"),
          ),
          body: ModalProgressHUD(
            inAsyncCall: isLoading.value,
            color: Colors.transparent,
            progressIndicator: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                backgroundColor: Colors.transparent),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Image.asset("assets/images/demo.jpg")),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text("Pay rs 100 for this product.",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 20)),
                  const Spacer(),
                  WidgetCustomButton(
                      onTap: () async {
                        if (PreferenceHelper.getString("id") == null) {
                          BlocProvider.of<CreateCustomerBloc>(context).add(
                              const CreateCustomerUser(
                                  url: "https://api.stripe.com/v1/customers"));
                        } else {
                          NavigatorKey.navigatorKey.currentState!
                              .pushNamed(AppRoutes.routesPaymentMethod);
                        }
                      },
                      title: "Continue"),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
