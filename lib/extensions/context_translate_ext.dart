import 'package:flutter/widgets.dart';
import 'package:user_app/l10n/app_localizations.dart';

extension ContextTranslateExt on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
