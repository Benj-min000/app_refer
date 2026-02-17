import 'dart:async';
import 'package:flutter/material.dart';
import "package:user_app/services/location_service.dart";
import 'package:provider/provider.dart';
import 'package:user_app/assistant_methods/locale_provider.dart';

import 'package:user_app/extensions/context_translate_ext.dart';

import 'package:user_app/screens/address_screen.dart';
import 'package:user_app/assistant_methods/address_changer.dart';
import "package:user_app/services/translator_service.dart";

class AddressHeader extends StatefulWidget {
  const AddressHeader({super.key});

  @override
  State<AddressHeader> createState() => _AddressHeaderState();
}

class _AddressHeaderState extends State<AddressHeader> {
  String _location = "";
  bool _showFullAddress = false;
  Timer? _refreshTimer;

  Locale? _lastLocale;
  int? _lastAddressIndex;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final localeProvider = Provider.of<LocaleProvider>(context);
    final addressProvider = Provider.of<AddressChanger>(context);

    // This runs whenever the language (Locale) or Providers change
    if (_lastLocale != localeProvider.locale || 
      _lastAddressIndex != addressProvider.count) {
    
      _lastLocale = localeProvider.locale;
      _lastAddressIndex = addressProvider.count;
      _updateAddress();
    } 
  }

  @override
  void initState() {
    super.initState();

    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (mounted) _updateAddress();
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  void _updateAddress() async {
    final addressProvider = Provider.of<AddressChanger>(context, listen: false);
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final languageCode = localeProvider.locale.languageCode;

    Map<String, dynamic> dataToProcess;

    if (addressProvider.count >= 0) {
      dataToProcess = addressProvider.selectedAddress;
    } else {
      if (mounted) setState(() => _location = context.t.findingLocalization);
    
      try {
        final dataToProcess = await LocationService.fetchUserCurrentLocation(langCode: languageCode);
        if (mounted) {
          setState(() {
            _location = dataToProcess['fullAddress'];
          });
        }
      } catch (e) {
        if (mounted) setState(() => _location = context.t.errorAddressNotFound);
      }
      return;
    }

    String finalAddress = await TranslationService.formatAndTranslateAddress(dataToProcess, languageCode);
    
    if (mounted) {
      setState(() {
        _location = finalAddress;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddressScreen())),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.location_on, color: Colors.white, size: 32),
          const SizedBox(width: 8),
          Expanded(
            child: InkWell(
              onTap: () => setState(() => _showFullAddress = !_showFullAddress),
              child: Text(
                _location.isEmpty ? context.t.findingLocalization : _location,
                style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                maxLines: _showFullAddress ? null : 1,
                overflow: _showFullAddress ? TextOverflow.visible : TextOverflow.ellipsis,
              ),
            ),
          ),
          Icon(
            _showFullAddress ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            color: Colors.white,
            size: 20,
          ),
        ],
      ),
    );
  }
}