import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/localization/locale_provider.dart';


class LanguageSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Select Language')),
      body: Column(
        children: [
          ListTile(
            title: Text('English'),
            onTap: () {
              localeProvider.setLocale(Locale('en'));
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('한국어 (Korean)'),
            onTap: () {
              localeProvider.setLocale(Locale('ko'));
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Polski (Polish)'),
            onTap: () {
              localeProvider.setLocale(Locale('pl'));
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Українська (Ukrainian)'),
            onTap: () {
              localeProvider.setLocale(Locale('uk'));
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
