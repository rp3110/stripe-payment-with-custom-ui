import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:stripe_custom_ui/api_service/preference_helper.dart';
import 'package:stripe_custom_ui/modules/bloc/payment_initent_bloc/payment_intent_bloc.dart';
import 'package:stripe_custom_ui/modules/card_screen/bloc/get_card_list_bloc.dart';
import 'package:stripe_custom_ui/modules/home_screen/view/screen_home.dart';
import 'package:stripe_custom_ui/utils/navigator_key.dart';
import 'package:stripe_custom_ui/utils/route_generator.dart';

import 'api_service/api_provider.dart';
import 'api_service/repository_auth.dart';
import 'modules/add_card_screen/bloc/bloc_add_card/add_card_bloc.dart';
import 'modules/add_card_screen/bloc/bloc_create_token/bloc_create_token_bloc.dart';
import 'modules/bloc/create_customer_bloc/create_customer_bloc.dart';
import 'modules/pay_using_card/bloc/pay_using_card_bloc.dart';
import 'modules/payment_screen/bloc/make_payment_bloc/make_payment_bloc.dart';
import 'modules/payment_screen/bloc/verify_payment_bloc/verify_payment_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ApiProvider apiProvider = ApiProvider();
  http.Client client = http.Client();
  @override
  void initState() {
    init();
    super.initState();
  }

  void init() {
    PreferenceHelper.load();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          BlocProvider<CreateCustomerBloc>(
            create: (BuildContext context) => CreateCustomerBloc(
              apiProvider: apiProvider,
              client: client,
              repositoryCreateCustomer: RepositoryAuth(),
            ),
          ),
          BlocProvider<CreateTokenBloc>(
            create: (BuildContext context) => CreateTokenBloc(
              apiProvider: apiProvider,
              client: client,
              repositoryCreateToken: RepositoryAuth(),
            ),
          ),
          BlocProvider<GetCardListBloc>(
            create: (BuildContext context) => GetCardListBloc(
              apiProvider: apiProvider,
              client: client,
              repositoryGetCardList: RepositoryAuth(),
            ),
          ),
          BlocProvider<PaymentIntentBloc>(
            create: (BuildContext context) => PaymentIntentBloc(
              apiProvider: apiProvider,
              client: client,
              repositoryPaymentIntent: RepositoryAuth(),
            ),
          ),
          BlocProvider<MakePaymentBloc>(
            create: (BuildContext context) => MakePaymentBloc(
              apiProvider: apiProvider,
              client: client,
              repositoryMakePayment: RepositoryAuth(),
            ),
          ),
          BlocProvider<PayUsingCardBloc>(
            create: (BuildContext context) => PayUsingCardBloc(
              apiProvider: apiProvider,
              client: client,
              repositoryPayUsingCard: RepositoryAuth(),
            ),
          ),
          BlocProvider<AddCardBloc>(
            create: (BuildContext context) => AddCardBloc(
              apiProvider: apiProvider,
              client: client,
              repositoryAddCard: RepositoryAuth(),
            ),
          ),
          BlocProvider<VerifyPaymentBloc>(
            create: (BuildContext context) => VerifyPaymentBloc(
              apiProvider: apiProvider,
              client: client,
              repositoryVerifyPayment: RepositoryAuth(),
            ),
          ),
        ],
        child: MaterialApp(
          navigatorKey: NavigatorKey.navigatorKey,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const ScreenHome(),
          onGenerateRoute: RouteGenerator.generateRoute,
        ));
  }
}
