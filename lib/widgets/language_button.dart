import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rider_app/extensions/brand_color_ext.dart';
import 'package:rider_app/models/language_model.dart';
import 'package:rider_app/providers/locale_provider.dart';

// -----------------------------------------------------------------------------
// LANGUAGE BUTTON
//
// Topbar widget that shows the current language flag and opens a popup
// to switch the app locale via LocaleProvider.
//
// Usage:
//   LanguageButton(brandColors: brandColors, colorScheme: colorScheme)
// -----------------------------------------------------------------------------

class LanguageButton extends StatelessWidget {
  final BrandColors brandColors;
  final ColorScheme colorScheme;

  const LanguageButton({
    super.key,
    required this.brandColors,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final currentCode = localeProvider.locale.languageCode;

    return PopupMenuButton<Language>(
      offset: const Offset(0, 44),
      position: PopupMenuPosition.under,
      color: colorScheme.surface,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.outline),
      ),
      constraints: const BoxConstraints(minWidth: 180),
      onSelected: (lang) {
        localeProvider.setLocale(Locale(lang.code, lang.countryCode));
      },
      itemBuilder: (_) => Language.languageList.map((lang) {
        final bool isSelected = lang.code == currentCode;
        return PopupMenuItem<Language>(
          value: lang,
          child: Row(
            children: [
              SizedBox(
                width: 22,
                height: 15,
                child: CountryFlag.fromCountryCode(lang.countryCode),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  lang.name,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                    color: isSelected ? brandColors.navy : null,
                  ),
                ),
              ),
              if (isSelected)
                Icon(Icons.check_rounded, size: 15, color: brandColors.navy),
            ],
          ),
        );
      }).toList(),
      child: Container(
        width: 44,
        height: 36,
        decoration: BoxDecoration(
          border: Border.all(color: colorScheme.outline),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: SizedBox(
            width: 24,
            height: 16,
            child: CountryFlag.fromCountryCode(
              Language.languageList
                  .firstWhere(
                    (l) => l.code == currentCode,
                    orElse: () => Language.languageList.first,
                  )
                  .countryCode,
            ),
          ),
        ),
      ),
    );
  }
}
