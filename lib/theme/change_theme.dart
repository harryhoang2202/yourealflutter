import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youreal/generated/i10n.dart';
import 'package:youreal/view_models/app_model.dart';

class ChangeTheme extends StatefulWidget {
  const ChangeTheme({Key? key}) : super(key: key);

  @override
  _ChangeThemeState createState() => _ChangeThemeState();
}

class _ChangeThemeState extends State<ChangeTheme> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 50,
          alignment: Alignment.center,
          color: Colors.white,
          child: SwitchListTile(
            secondary: Icon(Icons.brightness_2,
                color: Theme.of(context).accentColor, size: 24),
            value: Provider.of<AppModel>(context).darkTheme,
            activeColor: const Color(0xFF0066B4),
            onChanged: (bool value) {
              if (value) {
                Provider.of<AppModel>(context, listen: false).updateTheme(true);
              } else {
                Provider.of<AppModel>(context, listen: false)
                    .updateTheme(false);
              }
            },
            title: Text(S.of(context)!.darkTheme,
                style: const TextStyle(fontSize: 16)),
          ),
        ),
      ),
    );
  }
}
