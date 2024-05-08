// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../app/auth/blocs/authenticate/auth_bloc.dart' as _i6;
import '../app/auth/blocs/login/login_bloc.dart' as _i11;
import '../app/chats/blocs/chat_cubit/chat_cubit.dart' as _i4;
import '../services/data/api_remote.dart' as _i3;
import '../services/data/auth/auth_repository_impl.dart' as _i8;
import '../services/data/filter/filter_repository.dart' as _i10;
import '../services/domain/auth/i_auth_repository.dart' as _i7;
import '../services/domain/filter/i_filter_repository.dart'
    as _i9; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(
  _i1.GetIt get, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i2.GetItHelper(
    get,
    environment,
    environmentFilter,
  );
  gh.singleton<_i3.ApiRemote>(_i3.ApiRemote());
  gh.factoryParam<_i4.ChatCubit, _i5.Stream<_i6.AuthState>, dynamic>((
    authStream,
    _,
  ) =>
      _i4.ChatCubit(authStream));
  gh.singleton<_i7.IAuthRepository>(
      _i8.AuthRepositoryImpl(get<_i3.ApiRemote>()));
  gh.lazySingleton<_i9.IFilterRepository>(
      () => _i10.FilterRepository(get<_i3.ApiRemote>()));
  gh.factory<_i11.LoginBloc>(() => _i11.LoginBloc(
        get<_i7.IAuthRepository>(),
        get<_i9.IFilterRepository>(),
      ));
  gh.factory<_i6.AuthBloc>(() => _i6.AuthBloc(
        get<_i3.ApiRemote>(),
        get<_i7.IAuthRepository>(),
        get<_i9.IFilterRepository>(),
      ));
  return get;
}
