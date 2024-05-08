import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:youreal/common/config/size_config.dart';

import 'auth/blocs/authenticate/auth_bloc.dart';

class SplashScreen extends StatefulWidget {
  static const id = "SplashScreen";

  const SplashScreen({Key? key}) : super(key: key);
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AuthBloc authBloc;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    authBloc = BlocProvider.of<AuthBloc>(context);
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.addListener(() {
        if (_controller.isCompleted) {
          context.read<AuthBloc>().add(const AuthEvent.loadAccount());
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: screenWidth,
        child: Lottie.asset(
          "assets/intro_youreal.json",
          controller: _controller,
          repeat: false,
          fit: BoxFit.fill,
          onLoaded: (composition) {
            _controller
              ..duration = composition.duration
              ..forward();
          },
        ),
      ),
    );
  }
}
