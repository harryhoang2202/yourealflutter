import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:youreal/app/auth/blocs/authenticate/auth_bloc.dart';
import 'package:youreal/app/deal/common/address_search_provider.dart';

import 'package:youreal/di/dependency_injection.dart';

import 'package:youreal/routes/app_route.dart';
import 'package:youreal/services/notification_services.dart';

import 'app/auth/login/login_with_phone_number.dart';
import 'app/main_screen.dart';
import 'app/setup_profile/setup_profile_screen.dart';
import 'app/splash_screen.dart';
import 'common/constants/general.dart';
import 'common/constants/styles.dart';

import 'common/widget/app_loading.dart';
import 'generated/i10n.dart';
import 'services/services_api.dart';
import 'view_models/app_bloc.dart';
import 'view_models/app_model.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final AppModel _app = AppModel();

  /// Build the App Theme

  Future loadInitData() async {
    try {
      printLog("[AppState] Inital Data");

      /// Load App model config
      APIServices().setAppConfig();
      printLog("[AppState] Init Data Finish");
    } catch (e, trace) {
      printLog("[$runtimeType] $e $trace");
    }
  }

  @override
  void initState() {
    super.initState();
    loadInitData();
  }

  @override
  Widget build(BuildContext context) {
    printLog("[AppState] build");

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: ChangeNotifierProvider<AppModel>(
        create: (_) => _app,
        child: Consumer<AppModel>(
          builder: (context, value, child) {
            return MultiBlocProvider(
              providers: [
                BlocProvider<AuthBloc>(
                  create: (context) => getIt.call<AuthBloc>(),
                ),
              ],
              child: MultiProvider(
                providers: [
                  ChangeNotifierProvider(
                      create: (_) =>
                          AddressSearchProvider(enableAutoComplete: false)),
                ],
                child: MultiRepositoryProvider(
                  providers: [
                    RepositoryProvider.value(value: AppLoading()),
                    RepositoryProvider.value(value: AppDialog()),
                  ],
                  child: ScreenUtilInit(
                      designSize: const Size(414, 896),
                      builder: (context, _) {
                        context.read<AuthBloc>().add(AuthEvent.initial(
                          onExpired: () {
                            context
                                .read<AuthBloc>()
                                .add(const AuthEvent.onSignOut());
                          },
                        ));
                        return const AppContainer();
                      }),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class AppContainer extends StatefulWidget {
  const AppContainer({super.key});

  @override
  State<AppContainer> createState() => _AppContainerState();
}

class _AppContainerState extends State<AppContainer> {
  ThemeData getTheme(context) {
    bool isDarkTheme = Provider.of<AppModel>(context).darkTheme;

    if (isDarkTheme) {
      return buildDarkTheme();
    }
    return buildLightTheme();
  }

  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthEvent.initial(
      onExpired: () {
        context.read<AuthBloc>().add(const AuthEvent.onSignOut());
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        state.whenOrNull(
          authenticated: (user) {
            final appModel = Provider.of<AppModel>(context, listen: false);
            appModel.user = user;
            NotificationServices()
                .navigatorKey
                .currentState
                ?.pushNamed(MainScreen.id);
          },
          unAuthentication: () {
            NotificationServices()
                .navigatorKey
                .currentState
                ?.pushReplacementNamed(LoginWithPhoneNumber.id);
          },
          noFilterAuthenticated: () {
            NotificationServices()
                .navigatorKey
                .currentState
                ?.pushReplacementNamed(
                  SetupProfileScreen.id,
                );
          },
        );
      },
      child: MultiBlocProvider(
        providers: [
          ...AppBloc.providers,
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: NotificationServices().navigatorKey,
          locale: Locale(Provider.of<AppModel>(context).locale, ""),
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            DefaultCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          theme: getTheme(context),
          onGenerateRoute: AppRoute().onGenerateRoute,
          initialRoute: SplashScreen.id,
        ),
      ),
    );
  }
}
