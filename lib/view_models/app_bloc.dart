import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youreal/app/appraiser/blocs/appraiser_bloc.dart';
import 'package:youreal/app/auth/blocs/authenticate/auth_bloc.dart';
import 'package:youreal/app/chats/blocs/chat_cubit/chat_cubit.dart';
import 'package:youreal/app/common/fliter/blocs/filter_bloc.dart';
import 'package:youreal/app/deal/blocs/deal_bloc.dart';
import 'package:youreal/app/deal/deal_detail/blocs/deal_detail_bloc.dart';
import 'package:youreal/app/form_appraisal/blocs/appraisal_validation_bloc/appraisal_validation_bloc.dart';
import 'package:youreal/app/form_appraisal/blocs/approving_deal_bloc/approving_deal_bloc.dart';
import 'package:youreal/app/home/blocs/home_bloc.dart';

import 'package:youreal/app/notification/blocs/notification_cubit.dart';
import 'package:youreal/di/dependency_injection.dart';

class AppBloc {
  static final filterBloc = FilterBloc();
  static final homeBloc = HomeBloc();
  static final dealBloc = DealBloc();
  static final dealDetailBloc = DealDetailBloc();
  static final appraiserBloc = AppraiserBloc();
  static final appraisalValidationBloc = AppraisalValidationBloc();

  static final approvingDealBloc = ApprovingDealBloc();

  static final notificationCubit = NotificationCubit();
  static List<BlocProvider> get providers => [
        BlocProvider<FilterBloc>(create: (context) => filterBloc),
        BlocProvider<DealBloc>(create: (context) => dealBloc),
        BlocProvider<DealDetailBloc>(create: (context) => dealDetailBloc),
        BlocProvider<HomeBloc>(create: (context) => homeBloc),
        BlocProvider<ChatCubit>(
          create: (context) => getIt.call<ChatCubit>(
            param1: context.read<AuthBloc>().stream.asBroadcastStream(),
          ),
          lazy: false,
        ),
        BlocProvider<AppraiserBloc>(create: (context) => appraiserBloc),
        BlocProvider<AppraisalValidationBloc>(
            create: (context) => appraisalValidationBloc),
        BlocProvider<ApprovingDealBloc>(create: (context) => approvingDealBloc),
        BlocProvider<NotificationCubit>(
          create: (context) => notificationCubit,
        ),
      ];

  ///Singleton factory
  static final AppBloc _instance = AppBloc._internal();

  factory AppBloc() {
    return _instance;
  }

  AppBloc._internal();
}
