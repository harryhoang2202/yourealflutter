import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppLoading extends AppDialog {
  // Show loading dialog shortcut
  /// Change icon at https://pub.dev/packages/flutter_spinkit
  static void show(BuildContext context) {
    context.read<AppLoading>().showLoading(context);
  }

  /// Hide loading dialog shortcut
  static void dismiss(BuildContext context) {
    context.read<AppLoading>().dismissLoading();
  }

  /// Show loading dialog
  /// Change icon at https://pub.dev/packages/flutter_spinkit
  Future<void> showLoading(BuildContext context) {
    return showAppDialog(
      context,
      const WAppLoading(
        color: Colors.white,
      ),
    );
  }

  /// Hide loading dialog
  void dismissLoading() {
    return dismissAppDialog();
  }
}

class AppDialog {
  BuildContext? _context;
  bool isShowing = false;

  /// Show the dialog and store it's context for further dismiss
  static Future show(BuildContext context, Dialog dialog,
      {bool dismissible = false}) async {
    return context
        .read<AppDialog>()
        .showAppDialog(context, dialog, dismissble: dismissible);
  }

  static void dismiss(BuildContext context) async {
    context.read<AppDialog>().dismissAppDialog();
  }

  Future showAppDialog(BuildContext context, Widget dialog,
      {bool dismissble = false}) {
    dismissAppDialog();

    isShowing = true;
    return showDialog(
      context: context,
      barrierDismissible: dismissble,
      builder: (dialogContext) {
        if (!isShowing) {
          dismissAppDialog();
        } else {
          _context = dialogContext;
        }
        return dialog;
      },
    ).then((value) {
      _context = null;
      isShowing = false;
    });
  }

  void dismissAppDialog() {
    isShowing = false;
    if (_context != null) {
      try {
        if (Navigator.canPop(_context!)) {
          Navigator.of(_context!).pop(true);
        }
      } catch (e) {
        // Unhandled Exception: Looking up a deactivated widget's ancestor is unsafe.
      } finally {
        _context = null;
      }
    }
  }
}

class WAppLoading extends StatefulWidget {
  const WAppLoading({
    Key? key,
    this.color,
    this.size = 50.0,
    this.itemBuilder,
    this.duration = const Duration(seconds: 1),
    this.controller,
  })  : assert(
            !(itemBuilder is IndexedWidgetBuilder && color is Color) &&
                !(itemBuilder == null && color == null),
            'You should specify either a itemBuilder or a color'),
        super(key: key);

  final Color? color;
  final double size;
  final IndexedWidgetBuilder? itemBuilder;
  final Duration duration;
  final AnimationController? controller;

  @override
  _WAppLoadingState createState() => _WAppLoadingState();
}

class _WAppLoadingState extends State<WAppLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = (widget.controller ??
        AnimationController(vsync: this, duration: widget.duration))
      ..addListener(() => setState(() {}))
      ..repeat();
    _animation = CurveTween(curve: Curves.easeInOut).animate(_controller);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Opacity(
          opacity: 1.0 - _animation.value,
          child: Transform.scale(
            scale: _animation.value,
            child: SizedBox.fromSize(
              size: Size.square(widget.size),
              child: _itemBuilder(0),
            ),
          ),
        ),
      ),
    );
  }

  Widget _itemBuilder(int index) => widget.itemBuilder != null
      ? widget.itemBuilder!(context, index)
      : DecoratedBox(
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: widget.color));
}
