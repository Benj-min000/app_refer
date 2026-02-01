class LanguageModel {
  final String name;
  final String code;
  final String countryCode;

  const LanguageModel({
    required this.name,
    required this.code,
    required this.countryCode,
  });

  static List<LanguageModel> languageList = [
    LanguageModel(name: "English (US)", code: "en", countryCode: "US"),
    LanguageModel(name: "한국어 (Korean)", code: "ko", countryCode: "KR"),
    LanguageModel(name: "Polski (Polish)", code: "pl", countryCode: "PL"),
    LanguageModel(name: "Українська (Ukrainian)", code: "uk", countryCode: "UA"),
    LanguageModel(name: "Deutsch (German)", code: "de", countryCode: "DE")
  ];
}
