import 'package:flutter/material.dart';

// For Language
import 'package:provider/provider.dart';
import 'package:user_app/localization/locale_provider.dart';
import 'package:user_app/models/language_model.dart';
import 'package:country_flags/country_flags.dart';
import 'package:user_app/l10n/app_localizations.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);

    // Use the varaible 't' to change language
    var t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar( 
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.cyanAccent, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.topRight,
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          t.changeLanguage, 
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black.withValues(alpha: 0.5),
                offset: const Offset(2, 2), // Position: x=2, y=2
                blurRadius: 4,              // Softness of the shadow
              ),
            ],
          ),
        )
      ),
      body: ListView.builder(
        itemCount: LanguageModel.languageList.length,
        itemBuilder: (context, index) {
          final lang = LanguageModel.languageList[index];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Spacing between list items
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, // Background color of the tile
                borderRadius: BorderRadius.circular(16), // Border radius 16
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1), // Subtle shadow
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: ListTile(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                leading: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                child: CountryFlag.fromCountryCode(
                  lang.countryCode,
                  theme: const ImageTheme(
                    height: 32,
                    width: 32,
                    shape: Circle(),
                  ), // 
                ),
              ),

              title: Text(
                lang.name,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              trailing: localeProvider.locale.languageCode == lang.code 
                  ? Icon(
                    Icons.check_circle, 
                    color: Theme.of(context).primaryColor, 
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 6,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ) : null,
              onTap: () async {
                await localeProvider.setLocale(Locale(lang.code));
              },
              ),
            ),
          );
        }
      )
    );
  }
}
