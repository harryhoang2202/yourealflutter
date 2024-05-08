import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youreal/app/admin/main/admin_main_screen.dart';
import 'package:youreal/app/admin/search/admin_search_deal_screen.dart';
import 'package:youreal/app/admin/search/bloc/admin_search_deal_cubit.dart';
import 'package:youreal/app/appraiser/appraiser_screen.dart';
import 'package:youreal/app/appraiser/blocs/appraiser_bloc.dart';
import 'package:youreal/app/auth/blocs/forgot_password/forgot_password_bloc.dart';
import 'package:youreal/app/auth/blocs/login/login_bloc.dart';
import 'package:youreal/app/auth/blocs/register_bloc/register_bloc.dart';
import 'package:youreal/app/auth/blocs/verify_phone_bloc/verify_phone_bloc.dart';
import 'package:youreal/app/auth/forgot_password/forgot_password_screen.dart';
import 'package:youreal/app/auth/login/login_with_phone_number.dart';
import 'package:youreal/app/auth/register/register_screen.dart';
import 'package:youreal/app/auth/register/verify_phone_screen.dart';
import 'package:youreal/app/chats/blocs/chat_detail_bloc/chat_detail_bloc.dart';
import 'package:youreal/app/chats/blocs/chat_input_bloc/chat_input_bloc.dart';
import 'package:youreal/app/chats/blocs/chat_vote_leader_cubit/chat_vote_leader_cubit.dart';
import 'package:youreal/app/chats/blocs/heart_cubit/heart_cubit.dart';
import 'package:youreal/app/chats/views/chat_detail_info_screen.dart';
import 'package:youreal/app/chats/views/chat_detail_screen.dart';
import 'package:youreal/app/chats/views/chat_screen.dart';
import 'package:youreal/app/common/fliter/index.dart';
import 'package:youreal/app/common/news/index.dart';
import 'package:youreal/app/deal/blocs/cost_incurred_bloc/cost_incurred_bloc.dart';

import 'package:youreal/app/deal/blocs/deal_document/deal_document_bloc.dart';
import 'package:youreal/app/deal/create_deal/blocs/create_deal_bloc.dart';
import 'package:youreal/app/deal/create_deal/views/create_deal.dart';
import 'package:youreal/app/deal/create_deal/views/create_deal_2.dart';
import 'package:youreal/app/deal/create_deal/views/create_deal_complete.dart';
import 'package:youreal/app/deal/deal_detail/admin_detail_deal.dart';
import 'package:youreal/app/deal/deal_detail/appraiser_detail_deal.dart';
import 'package:youreal/app/deal/deal_detail/investor_detail_deal.dart';
import 'package:youreal/app/deal/model/deal.dart';
import 'package:youreal/app/deal/cost_incurred/costs_incurred.dart';
import 'package:youreal/app/deal/deal_detail/widget/deal_document_screen.dart';
import 'package:youreal/app/deal/deal_detail/deal_tracking.dart';
import 'package:youreal/app/deal/deal_detail/detail_deal.dart';
import 'package:youreal/app/deal/deal_detail/widget/list_deposit.dart';
import 'package:youreal/app/deal/deal_detail/widget/list_investor.dart';
import 'package:youreal/app/deal/deal_detail/widget/list_payment.dart';
import 'package:youreal/app/deal/deal_detail/widget/popup_list_interested_parties.dart';
import 'package:youreal/app/form_appraisal/appraisal_1/form_information_appraisal_1.dart';
import 'package:youreal/app/home/views/home_screen.dart';

import 'package:youreal/app/main_screen.dart';
import 'package:youreal/app/menu/draft_deal/draft_deal_screen.dart';
import 'package:youreal/app/menu/history/history_screen.dart';
import 'package:youreal/app/menu/list_request_role/blocs/req_appraisal_role_bloc/req_appraisal_role_bloc.dart';
import 'package:youreal/app/menu/role/role_request_appraiser.dart';
import 'package:youreal/app/my_deal/deal_screen.dart';
import 'package:youreal/app/my_deal/total_deal.dart';

import 'package:youreal/app/notification/views/notification_screen.dart';
import 'package:youreal/app/personally/personnally_screen.dart';
import 'package:youreal/app/setting/blocs/update_info_bloc.dart';
import 'package:youreal/app/setting/views/setting_screen.dart';
import 'package:youreal/app/setup_profile/blocs/setup_profile_bloc.dart';
import 'package:youreal/app/setup_profile/setup_profile_screen.dart';
import 'package:youreal/app/splash_screen.dart';
import 'package:youreal/di/dependency_injection.dart';
import 'package:youreal/services/services_api.dart';
import 'package:youreal/utils/blocs/lazy_load/lazy_load_bloc.dart';
import 'package:youreal/view_models/app_model.dart';

class AppRoute {
  static final AppRoute _singleton = AppRoute._internal();

  factory AppRoute() {
    return _singleton;
  }

  AppRoute._internal();

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case CreateDealScreen.id:
        final args = settings.arguments as CreateDealArgs?;
        return CupertinoPageRoute(
          settings: settings,
          builder: (context) => BlocProvider(
            create: (context) => CreateDealBloc(
              appModel: context.read<AppModel>(),
              draftDeal: args?.draftDeal,
              services: APIServices(),
            ),
            child: CreateDealScreen(editToBuy: args?.editToBuy ?? false),
          ),
        );
      case NewsDetailScreen.id:
        return CupertinoPageRoute(
          settings: settings,
          builder: (context) => NewsDetailScreen(
            newsId: settings.arguments as String,
          ),
        );
      case AdminSearchDealScreen.id:
        return CupertinoPageRoute(
          settings: settings,
          builder: (context) => BlocProvider(
            create: (context) => AdminSearchDealCubit(),
            child: const AdminSearchDealScreen(),
          ),
        );
      case AdminMainScreen.id:
        return CupertinoPageRoute(
          settings: settings,
          builder: (context) => const AdminMainScreen(),
        );
      case DealDocumentScreen.id:
        final args = settings.arguments as Deal;
        return CupertinoPageRoute(
          settings: settings,
          builder: (context) => BlocProvider(
            create: (context) => DealDocumentBloc(args),
            child: const DealDocumentScreen(),
          ),
        );
      case AppraiserScreen.id:
        return CupertinoPageRoute(
          settings: settings,
          builder: (context) => BlocProvider(
            create: (_) => AppraiserBloc(),
            child: AppraiserScreen(),
          ),
        );

      case MainScreen.id:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const MainScreen(),
        );
      case CreateDealComplete.id:
        return CupertinoPageRoute(
          settings: settings,
          builder: (context) => CreateDealComplete(
            dealId: settings.arguments.toString(),
          ),
        );
      case HomeScreen.id:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const HomeScreen(),
        );

      case ChatDetailInfoScreen.id:
        final ChatDetailBloc bloc = settings.arguments as ChatDetailBloc;
        return CupertinoPageRoute(
          builder: (_) => BlocProvider<ChatDetailBloc>.value(
            value: bloc,
            child: const ChatDetailInfoScreen(),
          ),
          settings: settings,
        );
      case ChatDetailScreen.id:
        final args = settings.arguments as ChatDetailArgs;
        return CupertinoPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider<ChatDetailBloc>(
                create: (context) => ChatDetailBloc(
                  args.groupChat,
                  args.authBloc,
                  args.chatCubit,
                ),
              ),
              BlocProvider<ChatInputBloc>(
                create: (context) => ChatInputBloc(context),
              ),
              BlocProvider<ChatVoteLeaderCubit>(
                create: (context) => ChatVoteLeaderCubit(),
              ),
              BlocProvider<HeartCubit>(
                create: (context) => HeartCubit(),
              ),
            ],
            child: ChatDetailScreen(),
          ),
          settings: settings,
        );
      case ChatScreen.id:
        return CupertinoPageRoute(
          builder: (_) => const ChatScreen(),
          settings: settings,
        );

      case CreateDeal_2.id:
        final bloc = settings.arguments as CreateDealBloc;
        return CupertinoPageRoute(
          builder: (_) => BlocProvider.value(
            value: bloc,
            child: const CreateDeal_2(),
          ),
          settings: settings,
        );

      case DealScreen.id:
        return CupertinoPageRoute(
          builder: (_) => const DealScreen(),
          settings: settings,
        );

      case TotalDeal.id:
        final args = settings.arguments as TotalDealArgs;
        return CupertinoPageRoute(
          builder: (_) => TotalDeal(
            title: args.title,
            itemBuilder: args.itemBuilder,
            loadData: args.loadData,
          ),
          settings: settings,
        );

      case DealTracking.id:
        final args = settings.arguments as Deal;
        return CupertinoPageRoute(
          builder: (_) => DealTracking(
            deal: args,
          ),
          settings: settings,
        );
      case DetailDeal.id:
        final args = settings.arguments as DetailDealArs;
        return CupertinoPageRoute(
          builder: (_) => DetailDeal(
            deal: args.deal,
          ),
          settings: settings,
        );
      case InvestorDetailDeal.id:
        final args = settings.arguments as Deal;
        return CupertinoPageRoute(
          builder: (_) => InvestorDetailDeal(
            deal: args,
          ),
          settings: settings,
        );
      case AdminDetailDeal.id:
        final args = settings.arguments as Deal;
        return CupertinoPageRoute(
          builder: (_) => AdminDetailDeal(
            deal: args,
          ),
          settings: settings,
        );
      case AppraiserDetailDeal.id:
        final args = settings.arguments as Deal;
        return CupertinoPageRoute(
          builder: (_) => AppraiserDetailDeal(
            deal: args,
          ),
          settings: settings,
        );
      case FormInformationAppraisal_1.id:
        final bloc = settings.arguments as CreateDealBloc;
        return CupertinoPageRoute(
          builder: (_) => BlocProvider.value(
            value: bloc,
            child: const FormInformationAppraisal_1(),
          ),
          settings: settings,
        );
      case LoginWithPhoneNumber.id:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt.call<LoginBloc>(),
            child: const LoginWithPhoneNumber(),
          ),
          settings: settings,
        );

      case RoleRequestAppraiser.id:
        final args = settings.arguments as RoleRequestAppraiserArgs?;
        return CupertinoPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => ReqAppraisalRoleBloc(request: args.request),
            child: RoleRequestAppraiser(
              request: args!.request,
              isAdmin: args.isAdmin,
            ),
          ),
          settings: settings,
        );

      case HistoryScreen.id:
        return CupertinoPageRoute(
          builder: (_) => const HistoryScreen(),
          settings: settings,
        );
      case FilterView.id:
        return CupertinoPageRoute(
          builder: (_) => const FilterView(),
          settings: settings,
        );

      case NewsScreen.id:
        return CupertinoPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => NewsCubit(),
            child: const NewsScreen(),
          ),
          settings: settings,
        );

      case NotificationScreen.id:
        return CupertinoPageRoute(
          builder: (_) => const NotificationScreen(),
          settings: settings,
        );
      case ForgotPasswordScreen.id:
        final phoneNumber = settings.arguments as String?;
        assert(phoneNumber != null, "Missing phoneNumber");
        return CupertinoPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => ForgotPasswordBloc(phoneNumber!),
            child: const ForgotPasswordScreen(),
          ),
          settings: settings,
        );

      case RegisterScreen.id:
        return CupertinoPageRoute(
          builder: (_) => BlocProvider<RegisterBloc>(
            create: (context) => RegisterBloc(),
            lazy: false,
            child: const RegisterScreen(),
          ),
          settings: settings,
        );

      case VerifyPhoneScreen.id:
        final registerBloc = settings.arguments as RegisterBloc;
        return CupertinoPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => VerifyPhoneBloc(
              registerBloc: registerBloc,
            ),
            child: const VerifyPhoneScreen(),
          ),
          settings: settings,
        );

      case SettingScreen.id:
        return CupertinoPageRoute(
          builder: (_) => const SettingScreen(),
          settings: settings,
        );
      case SplashScreen.id:
        return CupertinoPageRoute(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );

      case PopupListInterestedParties.id:
        return MaterialPageRoute(
          builder: (_) => const PopupListInterestedParties(),
          settings: settings,
        );

      case ListPayment.id:
        final args = settings.arguments as ListPaymentArgs;
        return MaterialPageRoute(
          builder: (_) => ListPayment(
            deal: args.deal,
          ),
          settings: settings,
        );

      case PersonallyScreen.id:
        final args = settings.arguments as AppModel;
        return CupertinoPageRoute(
          builder: (_) => BlocProvider<UpdateInfoBloc>(
            create: (context) => UpdateInfoBloc(args),
            lazy: false,
            child: const PersonallyScreen(),
          ),
          settings: settings,
        );

      case CostsIncurred.id:
        final deal = settings.arguments as Deal;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => CostIncurredBloc(deal: deal),
            child: const CostsIncurred(),
          ),
          settings: settings,
        );

      case DraftDealScreen.id:
        return CupertinoPageRoute(
          builder: (_) => BlocProvider<LazyLoadBloc<Deal>>(
              create: (context) => LazyLoadBloc<Deal>((page, sessionId) =>
                  APIServices()
                      .getDraftDealOfUser(page: page, sessionId: sessionId)),
              child: const DraftDealScreen()),
          settings: settings,
        );

      case SetupProfileScreen.id:
        return CupertinoPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => SetupProfileBloc(),
            child: const SetupProfileScreen(),
          ),
          settings: settings,
        );

      case ListDeposit.id:
        final args = settings.arguments as ListDepositArgs;
        return MaterialPageRoute(
          builder: (_) => ListDeposit(
            deal: args.deal,
          ),
          settings: settings,
        );

      case ListInvestor.id:
        final args = settings.arguments as ListInvestorArgs;
        return MaterialPageRoute(
          builder: (_) => ListInvestor(
            listAllocation: args.listAllocation,
            price: args.price,
          ),
          settings: settings,
        );

      default:
        return _errorRoute();
    }
  }

  Route _errorRoute() {
    return MaterialPageRoute(
      builder: (context) => const Scaffold(
        body: Center(
          child: Text('Error'),
        ),
      ),
      settings: const RouteSettings(
        name: '/error',
      ),
    );
  }
}
