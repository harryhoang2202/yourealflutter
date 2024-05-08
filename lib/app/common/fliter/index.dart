import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tuple/tuple.dart';
import 'package:tvt_input_keyboard/tvt_input_keyboard.dart';
import 'package:youreal/app/setup_profile/widgets/opt_check.dart';

import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/size_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:flutter/material.dart';
import 'package:youreal/common/constants/extensions.dart';
import 'package:youreal/common/constants/general.dart';
import 'package:youreal/common/model/country.dart';
import 'package:youreal/common/model/status_state.dart';

import 'package:youreal/common/tools.dart';
import 'package:youreal/services/services_api.dart';

import 'blocs/filter_bloc.dart';

part 'page/filter_page.dart';
part 'services/filter_service.dart';
part 'widgets/slider.dart';
